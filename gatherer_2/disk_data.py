import pytsk3
import datetime
import wmi
import json


def get_processes(output_file):
    c = wmi.WMI()
    process_list = []

    for process in c.Win32_Process ():
      data = { 'name': process.Name,
             'pid': process.ProcessId,
             'ppid': process.ParentProcessID,
             'path': process.ExecutablePath,
             'cmdline': process.CommandLine }

      process_list.append(data)


    with open(output_file,'w') as outfile:
        for i in process_list:
            json.dump(i, outfile)

def get_startup(output_file):
    c = wmi.WMI()

    for s in c.Win32_StartupCommand ():
      print "[%s] %s <%s>" % (s.Location, s.Caption, s.Command)

def get_patches(output_file):
    c = wmi.WMI()
    patch_list = []
    for patch in c.Win32_QuickFixEngineering():
      data = { 'Description': patch.Description,
             'HotFixID': patch.HotFixID,
             'InstalledOn': process.InstalledOn }

      patch_list.append(data)

#def get_network(output_file):
#def get_users(output_file):
#def get_networkShares(output_file):


if __name__ == "__main__":
    get_processes("processes.json")



"""
CollectFromDisk is designed to extract a predefined set of files from a disk image or live disk.
It makes heavy use of the pytsk3 library to mount the image, identify files, and move them to a
specified output directory.

collectFromDisk currently takes 5 arguments, the imagefile in question, the output directory, a list
of files to collect, and a list of full directories to collect. It is possible to include the root
directory and export every file in the directory structure, however this is likely very time consuming.
"""

def collectFromDisk(imagefile,outputdir,files,directories,hostname):
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
      if 'Basic' or 'NTFS' in partition.desc:
        try:
            """
            This loop iterates through the list of files specified for acquisition. This loop assumes that 'files'
            is formated in a specific fashion. That is, it's a python dictionary that contains the name of the evidence type
            (registry, event logs, email archive, etc) and the file's path. e.g.

                    {"name":"Registry","path":"/Windows/System32/config/SYSTEM"}
            """
            for i in files:
                path = i["path"]
                try:
                    """
                    if I'm not mistaken, the filesystemObject in this case is the logical partition. It is mounted here
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
                    the outFileName takes the file name of the file specified in the list of target evidence files and
                    prepends a bunch of stuff to look like this:

                    <output directory>/<system name>/<file name>.


                    """
                    outFileName = outputdir+"/"+hostname+"/"+str(partition.addr)+" "+fileobject.info.name.name

                    """
                    If the specified output directory doesn't already exist, this creates the output directory based on the hostname.
                    """

                    outdir = outputdir+"/"+hostname+"/"+entry["name"]
                    if not os.path.exists(outdir): os.makedirs(outdir)

                    """
                    This writes the evidence file to disk
                    """
                    outfile = open(outFileName, 'w')
                    filedata = fileobject.read_random(0,fileobject.info.meta.size)
                    outfile.write(filedata)
                    outfile.close

                """
                here we have some terrible exception handling with no descriptions of what is going on.
                """
                except:

                    pass
            """
            This does exactly the same as above, execpt for a list of directories. It recursively copies every
            file in the directory and its subdirectories to a specified output directory.
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
                        print outputdir
                        print directory, entryObject.info.name.name
                        #print filepath

                        fileobject = filesystemObject.open(filepath)
                        print "File Inode:",fileobject.info.meta.addr
                        print "File Name:",fileobject.info.name.name
                        print "File Creation Time:",datetime.datetime.fromtimestamp(fileobject.info.meta.crtime).strftime('%Y-%m-%d %H:%M:%S')
                        outFileName = outputdir+"/"+hostname+"/"+str(partition.addr)+" "+fileobject.info.name.name
                        outdir = outputdir+"/"+hostname+"/"+entry["name"]
                        if not os.path.exists(outdir): os.makedirs(outdir)
                        print outFileName
                        outfile = open(outFileName, 'w')
                        filedata = fileobject.read_random(0,fileobject.info.meta.size)
                        outfile.write(filedata)
                        outfile.close
                except:
                    pass
        except:
            pass


if __name__ == "__main__":
    import os
    from socket import gethostname

    imagefile = "\\\\.\\PhysicalDrive0"
    hostname = gethostname()

    if not os.path.exists(hostname): os.makedirs(hostname)

    files = [
             {"name":"Registry","path":"/Windows/System32/config/SYSTEM"},
             {"name":"Registry","path":"/Windows/System32/config/software"},
             {"name":"Registry","path":"/Windows/System32/config/SAM"},
             {"name":"Registry","path":"/Windows/System32/config/security"},
             {"name":"MFT","path":"/$MFT"}
            ]

    directories = [{'name':"evtx",'path':"/Windows/System32/Winevt/logs"},
                   {'name':"evtx",'path':"/Windows/System32/Winevt/logs"}]

    outputdir ="c:\\tools"

    collectFromDisk(imagefile,outputdir,hostname,files,directories)