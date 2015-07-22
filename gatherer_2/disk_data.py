import pytsk3
import datetime



def collectFromDisk(imagefile,outputdir,hostname,files,directories):
    imagehandle = pytsk3.Img_Info(imagefile)
    partitionTable = pytsk3.Volume_Info(imagehandle)
    for partition in partitionTable:
      print partition.addr, partition.desc, "%ss(%s)" % (partition.start, partition.start * 512), partition.len
      if 'Basic' or 'NTFS' in partition.desc:
        try:
            for i in files:
                path = i["path"]
                try:
                    filesystemObject = pytsk3.FS_Info(imagehandle, offset=(partition.start*512))
                    fileobject = filesystemObject.open(path)
                    print path
                    print "File Inode:",fileobject.info.meta.addr
                    print "File Name:",fileobject.info.name.name
                    print "File Creation Time:",datetime.datetime.fromtimestamp(fileobject.info.meta.crtime).strftime('%Y-%m-%d %H:%M:%S')
                    outFileName = outputdir+"/"+hostname+"/"+str(partition.addr)+" "+fileobject.info.name.name
                    outdir = outputdir+"/"+hostname+"/"+entry["name"]
                    if not os.path.exists(outdir): os.makedirs(outdir)
                    outfile = open(outFileName, 'w')
                    filedata = fileobject.read_random(0,fileobject.info.meta.size)
                    outfile.write(filedata)
                    outfile.close
                except:
                    pass

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