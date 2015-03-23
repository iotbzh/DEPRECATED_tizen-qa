#!/usr/bin/python

import time
import io
import os
import sys
import getopt
import shutil
import subprocess
import json
import argparse
from lxml import etree
from collections import OrderedDict


##############  support functions #############

## To handle formatting of folder names in the db ##

def base36encode(number):
    if not isinstance(number, (int, long)):
        raise TypeError('number must be an integer')
    if number < 0:
        raise ValueError('number must be positive')

    alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'

    number, i = divmod(number, 36)
    base36 = alphabet[number] + alphabet[i]

    return base36


def formatnamebase36(number, name):
  return "-".join([base36encode(number), name])


## To handle patching of files in the upstream cloned test suite ##

def getlinenumber(filepath, stringtofind):
    lineno = 0
    with open(filepath) as thefile:
        for index, line in enumerate(thefile,1):
            if stringtofind in line:
                lineno = index
    return lineno

def replaceline(filepath, oldline, newline):
    lineno  = getlinenumber(filepath, oldline)
    cmdline = ['sed', '-i', str(lineno)+'s/.*/'+newline+'/', filepath]
    print "previous line : %s" % oldline 
    print "new line : %s" % newline
    print "cmdline : %s" % cmdline
    process = subprocess.Popen(cmdline, cwd=os.path.dirname(filepath))
    process.wait()

def deletelines(filepath, beginline, endline, errorbegin=0, errorend=0):
    linebegin = str(getlinenumber(filepath, beginline) + errorbegin)
    lineend = str(getlinenumber(filepath, endline) + errorend)
    lines = linebegin + ',' + lineend + 'd'
    print "lines : %s" % lines
    cmdline = ['sed', '-i', lines, filepath]
    print "cmdline : %s" % cmdline
    process = subprocess.Popen(cmdline, cwd=os.path.dirname(filepath))
    process.wait()

############ essential functions #############

def parse_test_file(testfile, qametafile, withmanual):
   
    testlist = []
    #print ">> content of testlist : %s" % testlist
    testdoc = etree.parse(testfile)
    suite = testdoc.find('suite')
    launcher = suite.get('launcher')

    testdociter = testdoc.getiterator('testcase')

    for elt in testdociter:
        if not withmanual and elt.get('execution_type') == 'manual':
            continue
        testdico = OrderedDict ([
            ('launcher', launcher), # TODO take into account this parameter in infra
            ('name', elt.get('id')),
            ('exec_type', elt.get('execution_type')),
            ('priority', elt.get('priority', default='0')),
            ('status', elt.get('status', default='designed')),
            ('type', elt.get('type', default='compliance')),
            ('subtype', ''), ## not specific to a testcase
            ('objective', elt.get('purpose')),
            ('description', elt.get('purpose')),
	        ('onload_delay', elt.get('onload_delay', default='0')), # TODO : to handle in tcbrowse ? in infra
            ('pre_condition', elt.find('description').findtext('pre_condition', default='')),
            ('steps', []), ## TODO : to handle later
            ('post_condition', elt.find('description').findtext('post_condition', default='')),
            ('notes', ''), ## not specific to a testcase
            ('bugs', ''), ## not specific to a testcase
            ('exec_pre', elt.find('description').findtext('exec_pre', default='')), 
            ('exec', elt.find('description').findtext('test_script_entry')),
            ('exec_expected_retcode', elt.find('description').findtext('exec_expected_retcode', default='0')),
            ('exec_kill_timeout', elt.find('description').findtext('exec_kill_timeout', default='0')),
            ('exec_post', elt.find('description').findtext('exec_post')),
            ('service', {}),
            ('author', 'qadmin'),
            ('ctime', time.strftime("%Y-%m-%d %H:%M:%S GMT", time.localtime())),
            ('mtime', '')])

        testlist.append(testdico)
        #print "==========================="

        #print ">> tag : %s" % elt.tag
        #print ">> attrib : %s" % elt.attrib


    #print "\n>> content of testlist : %s" % testlist
    f = open(qametafile, 'w')
    jsondatas = json.dumps(testlist, indent=2)
    f.write(jsondatas)
    f.close()

def generate_test_suite(repodir, suitedir, withmanual):
    commonapidir = os.path.join(suitedir, "00-commonapi")  
    deviceapidir = os.path.join(suitedir, "01-deviceapi")   
    os.mkdir(commonapidir) # contains common webapi sets 
    os.mkdir(deviceapidir) # contains device api sets
    cptcommonapi = 0
    cptdeviceapi = 0
    suiteinput = os.path.join(repodir, "webapi")    # directory that contains the upstream webapi suite 
    setdirs    = os.listdir(suiteinput)
    # remove unecessary directories
    try:
        setdirs.remove("apk-shared")
        setdirs.remove("xpk")
    except ValueError:
        pass
    
    setdirs.sort()

    for setdir in setdirs:
	nativesetdir = os.path.join(suiteinput, setdir)	# directory of the set to handle
	testxmlfile  = os.path.join(nativesetdir, "tests.xml") # testkit xml file of the set to handle

	if os.path.isfile(testxmlfile):
	    if "tizen" in setdir:
		realsetdir = os.path.join(deviceapidir, formatnamebase36(cptdeviceapi, setdir))
		cptdeviceapi += 1
	    else:
		realsetdir = os.path.join(commonapidir, formatnamebase36(cptcommonapi, setdir))
		cptcommonapi += 1

	    os.mkdir(realsetdir)
	    qametafile = os.path.join(realsetdir, "QAMETA.json")
	    parse_test_file(testxmlfile, qametafile, withmanual)

    print "%s suites generated." % str(cptcommonapi+cptdeviceapi)

def pack_test_suite(suitedir, repodir, buggysetsdir):
    webapidir = os.path.join(repodir, "webapi")
    commondir = os.path.join(suitedir, "00-commonapi")
    devicedir = os.path.join(suitedir, "01-deviceapi")
    commonList = os.listdir(commondir)
    deviceList = os.listdir(devicedir)
    cmdline = ['./pack.py', '-t', 'wgt', '-m', 'embedded', '-a', 'x86', '-s', '-d']

    for index, value in enumerate(commonList):
        setdir = os.path.join(webapidir, value.split('-',1)[1])
        cmdline.insert(-1, setdir)
        cmdline.append(os.path.join(commondir, value))
        process = subprocess.Popen(cmdline, cwd=os.path.join(repodir,'tools', 'build'), stdout=subprocess.PIPE)
        process.wait()
        cmdline.pop(-1)
        cmdline.pop(-2)

    for index, value in enumerate(deviceList):
        setdir = os.path.join(webapidir,value.split('-',1)[1])
        cmdline.insert(-1, setdir)
        cmdline.append(os.path.join(devicedir, value))
        process = subprocess.Popen(cmdline, cwd=os.path.join(repodir,'tools', 'build'), stdout=subprocess.PIPE)
        process.wait()
        cmdline.pop(-1)
        cmdline.pop(-2)

def main():

    parser = argparse.ArgumentParser(description='Tool to generate the database of the crosswalk test suite')
    parser.add_argument('-s', '--srcgit', help='path of the crosswalk-test-suite git repo', dest='srcgit', required=True)
    parser.add_argument('-o', '--oudir', help='output directory of the generated test database', dest='outdir', default='/tmp/testdb')
    parser.add_argument('-n', '--name', help='name of the topdir of the test database', dest='name', default='E0-crosswalk')
    parser.add_argument('-m', '--manual', help='also generate the manual testcases', dest='manual', action='store_true')

    args = parser.parse_args()

    repodir = args.srcgit
    suitedir = os.path.join(args.outdir, args.name)
    buggysetsdir = os.path.join(args.outdir, 'buggysets')
    withmanual = args.manual

    print "\n#### Given arguments : %s" % args

    if not (os.path.isdir(args.srcgit)):
        print "\nPath of the crosswalk-test-suite git isn't valid !"
        sys.exit(1)

    if (os.path.isdir(args.outdir)):
        print "#### Erasing previous directory..."
        shutil.rmtree(args.outdir)

    print "\n Creating output directory : %s" % suitedir
    os.makedirs(suitedir)
    os.makedirs(buggysetsdir)

    print "\n Generating crosswalk test suite..."
    generate_test_suite(repodir, suitedir, withmanual)

    print "\n#### Packing test suite..."
    pack_test_suite(suitedir, repodir, buggysetsdir)

'''
    workingpath	    = "/home/zingile/tmp"
    workingdirname  = "tests-crosswalk"
    reponame	    = "crosswalk-test-suite"
    suitename	    = "E0-Crosswalk"
    buggysetsname   = "buggysets"
    workspace	    = os.path.join(workingpath, workingdirname) # top directory in which we will work
    repodir	        = os.path.join(workspace, reponame)		# where is located the whole upstream test suites
    suitedir	    = os.path.join(workspace, suitename)	# suite that will be copied in the db
    buggysetsdir    = os.path.join(workspace, buggysetsname)	# contains all the set that doesn't have a test widget

    if (os.path.isdir(workspace)):
	print "#### Erasing previous directory..."
	shutil.rmtree(workspace)

    print "\n#### Working dir is created... : %s" % workspace
    os.mkdir(workspace)
    os.mkdir(suitedir)
    os.mkdir(buggysetsdir)

    print "\n#### Cloning test suite..."
    clone_test_suite(workspace)
   
    # Warning ! :platform option (-p) is no longer required to pack a set
    #print "\n#### Patching the packall.sh file..."
    #oldline = "./pack.sh -t $type -m $mode -p $platform -a $arch"
    #newline = "    .\/pack.sh -t $type -m $mode -a $arch"
    #replaceline(os.path.join(repodir, "webapi", "packall.sh"), oldline, newline)
    
    print "\n#### Removing webapi/tct-manual-w3c-tests test directory..."
    shutil.rmtree(os.path.join(repodir,"webapi", "tct-manual-w3c-tests")) 
    
    print "\n#### Generating crosswalk test suite..."
    generate_test_suite(repodir, suitedir)
    
    print "\n#### Packing test suite..."
    pack_test_suite(suitedir, repodir, buggysetsdir)    
'''
 
if __name__ == "__main__":
        main()
