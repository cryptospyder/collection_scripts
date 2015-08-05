__author__ = 'spydir'
import pytsk3
import datetime
import wmi
import json
import csv
import sys
import pytsk3
import datetime
import pyewf
import argparse
import hashlib
import csv
import os
import re
import psutil
from artifacts import files

def get_processes(output):
    outdir = output + "/vol"
    if not os.path.exists(outdir): os.makedirs(outdir)
    output = output + "/vol/processes.json"
    c = wmi.WMI()
    process_list = []

    for process in c.Win32_Process ():
        data = { 'name': process.Name,
             'pid': process.ProcessId,
             'ppid': process.ParentProcessID,
             'path': process.ExecutablePath,
             'cmdline': process.CommandLine }
        process_list.append(data)

    with open(output,'w') as outfile:
        for i in process_list:
            json.dump(i, outfile)

def get_startup(output):
    outdir = output + "/vol"
    if not os.path.exists(outdir): os.makedirs(outdir)
    output = output + "/vol/startup.json"
    c = wmi.WMI()
    startup_list = []

    for s in c.Win32_StartupCommand ():

        print "[%s] %s <%s>" % (s.Location, s.Caption, s.Command)

def get_updates(output):
    outdir = output + "/vol"
    if not os.path.exists(outdir): os.makedirs(outdir)
    output = output + "/vol/updates.json"
    c = wmi.WMI()
    patch_list = []
    for patch in c.Win32_QuickFixEngineering():
        data = { 'Description': patch.Description,
             'HotFixID': patch.HotFixID,
             'InstalledOn': patch.InstalledOn }

        patch_list.append(data)

    with open(output,'w') as outfile:
        for i in patch_list:
            json.dump(i, outfile)

def get_network(output):
    output = output + "/vol/network.json"
    pass

def directoryRecurse(directoryObject, parentPath,search):
  for entryObject in directoryObject:
      if entryObject.info.name.name in [".", ".."]:
        continue
      #print entryObject.info.name.name
      try:
        f_type = entryObject.info.name.type
        size = entryObject.info.meta.size
      except Exception as error:
          #print "Cannot retrieve type or size of",entryObject.info.name.name
          #print error.message
          continue

      try:

        filepath = '/%s/%s' % ('/'.join(parentPath),entryObject.info.name.name)
        outputPath ='./%s/' % ('/'.join(parentPath))

        if f_type == pytsk3.TSK_FS_NAME_TYPE_DIR:
            sub_directory = entryObject.as_directory()
            print "Entering Directory: %s" % filepath
            parentPath.append(entryObject.info.name.name)
            directoryRecurse(sub_directory,parentPath,search)
            parentPath.pop(-1)
            print "Leaving Directory: %s" % filepath


        elif f_type == pytsk3.TSK_FS_NAME_TYPE_REG and entryObject.info.meta.size != 0:
            searchResult = re.match(search,entryObject.info.name.name)
            if not searchResult:
              continue
            #print "File:",parentPath,entryObject.info.name.name,entryObject.info.meta.size
            BUFF_SIZE = 1024 * 1024
            offset=0
            md5hash = hashlib.md5()
            sha1hash = hashlib.sha1()
            # if args.extract == True:
            #       if not os.path.exists(outputPath):
            #         os.makedirs(outputPath)
            #       extractFile = open(outputPath+entryObject.info.name.name,'w')
            while offset < entryObject.info.meta.size:
                available_to_read = min(BUFF_SIZE, entryObject.info.meta.size - offset)
                filedata = entryObject.read_random(offset,available_to_read)
                md5hash.update(filedata)
                sha1hash.update(filedata)
                offset += len(filedata)
            #     if args.extract == True:
            #       extractFile.write(filedata)
            #
            # if args.extract == True:
            #     extractFile.close
            wr.writerow([int(entryObject.info.meta.addr),'/'.join(parentPath)+entryObject.info.name.name,datetime.datetime.fromtimestamp(entryObject.info.meta.crtime).strftime('%Y-%m-%d %H:%M:%S'),datetime.datetime.fromtimestamp(entryObject.info.meta.mtime).strftime('%Y-%m-%d %H:%M:%S'),datetime.datetime.fromtimestamp(entryObject.info.meta.atime).strftime('%Y-%m-%d %H:%M:%S'),int(entryObject.info.meta.size),md5hash.hexdigest(),sha1hash.hexdigest()])
        elif f_type == pytsk3.TSK_FS_NAME_TYPE_REG and entryObject.info.meta.size == 0:
            wr.writerow([int(entryObject.info.meta.addr),'/'.join(parentPath)+entryObject.info.name.name,datetime.datetime.fromtimestamp(entryObject.info.meta.crtime).strftime('%Y-%m-%d %H:%M:%S'),datetime.datetime.fromtimestamp(entryObject.info.meta.mtime).strftime('%Y-%m-%d %H:%M:%S'),datetime.datetime.fromtimestamp(entryObject.info.meta.atime).strftime('%Y-%m-%d %H:%M:%S'),int(entryObject.info.meta.size),"d41d8cd98f00b204e9800998ecf8427e","da39a3ee5e6b4b0d3255bfef95601890afd80709"])

        else:
          print "This went wrong",entryObject.info.name.name,f_type

      except IOError as e:
        #print e
        continue

def timeline(output,dirPath,search):
    outdir = output + "/vol"
    if not os.path.exists(outdir): os.makedirs(outdir)
    output = output + "/vol/timeline.csv"
    outfile = open(output,'wb')
    outfile.write('"Inode","Full Path","Creation Time","Modified Time","Accessed Time","Size","MD5 Hash","SHA1 Hash"\n')
    global wr
    wr = csv.writer(outfile, quoting=csv.QUOTE_ALL)

    partitionList = psutil.disk_partitions()
    for partition in partitionList:
      imagehandle = pytsk3.Img_Info('\\\\.\\'+partition.device.strip("\\"))
      if 'NTFS' in partition.fstype:
        filesystemObject = pytsk3.FS_Info(imagehandle)
        directoryObject = filesystemObject.open_dir(path=dirPath)
        print "Directory:",dirPath
        directoryRecurse(directoryObject,[],search)

"""
CollectFromDisk is designed to extract a predefined set of files from a disk image or live disk.
It makes heavy use of the pytsk3 library to mount the image, identify files, and move them to a
specified output directory.

collectFromDisk currently takes 5 arguments, the imagefile in question, the output directory, a list
of files to collect, and a list of full directories to collect. It is possible to include the root
directory and export every file in the directory structure, however this is likely very time consuming.
"""

def collectFromDisk(imagefile,output):

    imagehandle = pytsk3.Img_Info(imagefile) #Img_Info opens and stores general information about a disk
    partitionTable = pytsk3.Volume_Info(imagehandle) #The partition table is returned from the Volume_Info function

    """
    **This may not be entirely accurate and I need to do more research, but it's the basic idea.

    the following for loop iterates through each element in 'partitionTable'. If 'Basic' or 'NTFS' is found
    a predefined set of files are extracted and written to the output director. Older disks with smaller partitions
    normally have an Master File Table (MFT). The Partition table within the MFT typically contains the string
    'NTFS' for NTFS formated partitions. However newer drives with a GUID Partition Table (GPT) usally contain the
    strings 'Basic File System' for NTFS formated partition. As a result, both strings are included.
    """
    for partition in partitionTable:
      print partition.addr, partition.desc, "%ss(%s)" % (partition.start, partition.start * 512), partition.len
      if 'Basic data partition' in partition.desc:
        try:
            """
            This loop iterates through the list of files specified for acquisition. This loop assumes that 'files'
            is formated in a specific fashion. That is, it's a python dictionary that contains the name of the evidence type
            (registry, event logs, email archive, etc) and the file's path. e.g.

                    {"name":"Registry","path":"/Windows/System32/config/SYSTEM"}
            """
            for entry in files:
                path = entry["path"]
                try:
                    """
                    if I'm not mistaiken, the filesystemObject in this case is the logical partition. It is mounted here
                    so that we can look for specific files by their path.
                    """
                    filesystemObject = pytsk3.FS_Info(imagehandle, offset=(partition.start*512))

                    fileobject = filesystemObject.open(path)


                    # I normally print the following items for debugging purposes.
                    """
                    #print path
                    #print "File Inode:",fileobject.info.meta.addr
                    #print "File Name:",fileobject.info.name.name
                    #print "File Creation Time:",datetime.datetime.fromtimestamp(fileobject.info.meta.crtime).strftime('%Y-%m-%d %H:%M:%S')
                    """

                    """
                    If the specified output directory doesn't already exist, this creates the output directory based on the hostname.
                    """

                    outdir = output+"/"+entry["name"]
                    if not os.path.exists(outdir): os.makedirs(outdir)

                    """
                    the outFileName takes the file name of the file specified in the list of target evidence files and
                    prepends a bunch of stuff to look like this:

                    <output directory>/<system name>/<file name>.


                    """
                    outFileName = output+"/"+entry["name"]+ "/" +str(partition.addr)+" "+fileobject.info.name.name

                    """
                    This writes the evidence file to disk
                    """
                    outfile = open(outFileName, 'w')
                    filedata = fileobject.read_random(0,fileobject.info.meta.size)
                    outfile.write(filedata)
                    outfile.close

                #here we have some terrible exception handling with no descriptions of what is going on.

                except:

                    pass
            """
            #This does exactly the same as above, execpt for a list of directories. It recursively copies every
            #file in the directory and its subdirectories to a specified output directory.
            """
            for entry in directories:
                directory = entry["path"]

                try:
                    filesystemObject = pytsk3.FS_Info(imagehandle, offset=(partition.start*512))
                    directoryObject = filesystemObject.open_dir(directory)
                    for entryObject in directoryObject:
                        if entryObject.info.name.name in [".", ".."]:
                            continue

                        filepath =(directory+"/"+entryObject.info.name.name)
                        #print output
                        #print directory, entryObject.info.name.name
                        #print filepath

                        fileobject = filesystemObject.open(filepath)
                        #print "File Inode:",fileobject.info.meta.addr
                        #print "File Name:",fileobject.info.name.name
                        #print "File Creation Time:",datetime.datetime.fromtimestamp(fileobject.info.meta.crtime).strftime('%Y-%m-%d %H:%M:%S')
                        outFileName = output+"/"+entry["name"]+"/"+str(partition.addr)+" "+fileobject.info.name.name
                        outdir = output+"/"+entry["name"]
                        if not os.path.exists(outdir): os.makedirs(outdir)
                        #print outFileName
                        outfile = open(outFileName, 'w')
                        filedata = fileobject.read_random(0,fileobject.info.meta.size)
                        outfile.write(filedata)
                        outfile.close
                except:
                    pass
        except:
            pass

