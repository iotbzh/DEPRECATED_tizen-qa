#!/usr/bin/env python

#----------------------------------------------------------------------------------------------------
# @Name: pkgconsistancy.py
# @author: Nicolas Zingile
# @copyright: (c) 2013 Intel Open Source Technology Centre
# @license: GPL-v2
# Description : This program test if all the binaries has their libraries installed on the system
#----------------------------------------------------------------------------------------------------
import sys
import shlex
import subprocess
import getopt

def printDico(dico):
    for keyValue in dico.iteritems() :
        print "[key] = %s  [value] = %s" %(keyValue[0], keyValue[1])


def getPkgFiles(path):
    """
    Retrieves the list of all the files of the installed in the system the system using the RPM command.
    @precondition: Linux system with RPM package management and rpm command installed
    @return: a dictionary where the key is the name of the path and the value, the associated package
    @param: 
    """
    
    filesDico  = {}
    cmd        = "rpm -qa --filesbypkg"
    cmd_split  = shlex.split(cmd)   
    process1   = subprocess.Popen(cmd_split, stdout=subprocess.PIPE)
    cmd        = "egrep '^.+?\s+" + path + "'"
    cmd_split  = shlex.split(cmd) 
    process2   = subprocess.Popen(cmd_split, stdin=process1.stdout, stdout=subprocess.PIPE)
    cmd_out    = process2.stdout.read()
    cmd_out    = cmd_out.split("\n")
    
    for line in cmd_out :
        firstspace = line.find(" ")
        lastspace  = line.rfind(" ")
        path       = line[lastspace+1:]
        pkgName    = line[:firstspace]
        filesDico[path] = pkgName
    
    filesDico.pop('')
    
    return filesDico


def getBinFiles(dico):
    """
    Give the list of the binary files installed on the system
    @param : a dictionary - where the key is a path and the value is the package which provide the file
    @return: a dictionary where the key is the absolute path of a installed binary file and the value is the 
    package which provide the key.
    """
    binFilesDico  = {}
    
    for path in dico.keys() :
        cmd       = "file -bi %s" %path
        #os.lstat(cmd)
        cmd_split = shlex.split(cmd)
        process = subprocess.Popen(cmd_split, stdout=subprocess.PIPE)
        cmd_out = process.stdout.read()
        if (cmd_out.find("x-executable") > 0) or (cmd_out.find("x-sharedlib")>0) :
            binFilesDico[path] = dico[path]
    
    return binFilesDico
            
    
def getLdd(path):
    """
    Retrieves the result of the ldd command in a dictionary. 
    @param path : path of the binary that we want to get the dependencies from
    @return: a dictionary where the key is a symbolic link of a library and the value, the path of the library 
    """
    lddDico={}
    cmd       = "ldd "
    cmd       = cmd + path
    cmd_split = shlex.split(cmd)
    process1  = subprocess.Popen(cmd_split, stdout=subprocess.PIPE)
    cmd       = "awk '/^\tlib/ {printf(\"%s %s %s\\n\",$1,$3,$4)}'"
    cmd_split = shlex.split(cmd)
    process2  = subprocess.Popen(cmd_split, stdin=process1.stdout, stdout=subprocess.PIPE)
    cmd_out   = process2.stdout.read()
    cmd_out   = cmd_out.split("\n")
    
    for line in cmd_out : 
        sep   = line.find(" ")
        key   = line[:sep]
        value = line[sep+1:]
        if key != '' :
            lddDico[key]=value
        
    return lddDico


def checkDependency(entry):
    """
    Parse the string "entry" and check if it contains the substring "found" which means 
    @param depList: list of the dependencies given by the ldd comand line
    @return : if entry contains an error (the word "found")  
    """
    
    error = False
        
    if (entry.find("not found") >= 0) :
        error = True
            
    return error


# getting list of installed packages
def main(argv):

    path_to_parse=''
    try:
        opts, argvs =  getopt.getopt(argv, "h:p:", "path=")
    except getopt.GetoptError:
        print 'checklibs.py -p <pathtoparse>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'checklibs.py -p <pathtoparse>'
            sys.exit()
        elif opt in ("-p","--path"):
            path_to_parse = arg

    retcode       = 0
    nb_bin_tested = 0
    nb_error      = 0
    dico          = getPkgFiles(path_to_parse)
    #print "############################ Content of dico ###############################"
    #printDico(dico)
    binFiles = getBinFiles(dico)
    nb_bin_tested = len(binFiles)
    #print "############################ Content of binFiles ###########################"
    #printDico(binFiles)

    for path in binFiles.keys() :
        lddDico = getLdd(path)
        #print "############################ Dico of %s ###########################" %path
        #printDico(lddDico)
        print "== Checking dependencies of [%s] provided by [%s]..." %(path, binFiles.get(path))
        for keyValue in lddDico.iteritems() :
            if(checkDependency(keyValue[1])) :
                print >> sys.stderr, "Error ! Package : [%s] - Missing library [%s] required by [%s]" %(binFiles.get(path), keyValue[0], path)
                retcode = 1
                nb_error+=1
            else :
                print"%s => %s" % (keyValue[0], keyValue[1])
    
    print retcode   
    print ("###[NOTE]### Number of binary/libraries tested : %s") % nb_bin_tested 
    print ("###[NOTE]### Number of error found : %s") % nb_error       
    exit(retcode)
    
if __name__ == "__main__":
        main(sys.argv[1:])

    
