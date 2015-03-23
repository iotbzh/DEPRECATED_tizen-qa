#!/usr/bin/python

import time
import io
import os
import sys
import getopt
import subprocess
import json 
from lxml import etree
from collections import OrderedDict

def parse_test_file(testfile, qametafile):

    testlist = []
    #print ">> content of testlist : %s" % testlist
    testdoc = etree.parse(testfile)
    suite = testdoc.find('suite')
    launcher = suite.get('launcher')

    testdociter = testdoc.getiterator('testcase')

    for elt in testdociter:
        testdico = OrderedDict ([
            ('launcher', launcher), # TODO take into account this parameter in infra
            ('name', elt.get('id')),
            ('exec_type', elt.get('execution_type')),
            ('priority', elt.get('priority', default='0')),
            ('status', elt.get('status', default='designed')),
            ('type', elt.get('type', default='')),
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

    f = open(qametafile, 'w')
    jsondatas = json.dumps(testlist, indent=2)
    f.write(jsondatas)
    f.close()

def main(argv):
    infile = ''
    outfile = ''
   
    try:
	opts, args = getopt.getopt(argv,"hi:o:",["infile=","outfile="])
   
    except getopt.GetoptError:
	print 'test.py -i <infile.xml> -o <outfile.json>'
	sys.exit(2)
   
    for opt, arg in opts:
	if opt == '-h':
	    print 'test.py -i <infile.xml> -o <outfile.xml>'
	    sys.exit()
	elif opt in ("-i", "--infile"):
	    infile = arg
	elif opt in ("-o", "--outfile"):
	    outfile = arg

    print 'Input file is ', infile
    print 'Output file is ', outfile

if __name__ == "__main__":
   main(sys.argv[1:])
