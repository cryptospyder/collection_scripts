#!/usr/bin/python
# Sample program or step 11 in becoming a DFIR Wizard!
# No license as this code is simple and free!
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
import admin
from socket import gethostname
from collectors import *

argparser = argparse.ArgumentParser(description='Hash files recursively from all NTFS parititions in a live system and optionally extract them')
argparser.add_argument(
        '-i', '--image',
        dest='imagefile',
        action="store",
        type=str,
        default=None,
        required=False,
        help='E01 to extract from'
    )
argparser.add_argument(
        '-p', '--path',
        dest='path',
        action="store",
        type=str,
        default='/',
        required=False,
        help='Path to recurse from, defaults to /'
    )
argparser.add_argument(
        '-o', '--output',
        dest='output',
        action="store",
        type=str,
        default='inventory.csv',
        required=True,
        help='File to write the hashes to'
    )
argparser.add_argument(
        '-s', '--search',
        dest='search',
        action="store",
        type=str,
        default='.*',
        required=False,
        help='Specify search parameter e.g. *.lnk'
    )
argparser.add_argument(
        '-e', '--extract',
        dest='extract',
        action="store_true",
        default=False,
        required=False,
        help='Pass this option to extract files found'
    )

argparser.add_argument(
        '-l', '--live',
        dest='live',
        action="store_true",
        default=False,
        required=False,
        help='determines if this is live or dead acquisition'
    )


args = argparser.parse_args()

class ewf_Img_Info(pytsk3.Img_Info):
  def __init__(self, ewf_handle):
    self._ewf_handle = ewf_handle
    super(ewf_Img_Info, self).__init__(
        url="", type=pytsk3.TSK_IMG_TYPE_EXTERNAL)

  def close(self):
    self._ewf_handle.close()

  def read(self, offset, size):

    self._ewf_handle.seek(offset)
    return self._ewf_handle.read(size)

  def get_size(self):
    return self._ewf_handle.get_media_size()

def checkAdmin():
    if not admin.isUserAdmin():
      admin.runAsAdmin()
      sys.exit()

def output():
    if args.live == True:
        output = args.output +"/"+ gethostname()

    elif args.imagefile != None:
        output = args.output +"/"+ args.imagefile

    else:
        output = args.output

    return output

if __name__ == "__main__":

    imagefile = "\\\\.\\PhysicalDrive0"
    checkAdmin()
    get_processes(output())
    get_updates(output())
    timeline(output(),args.path,args.search)
    collectFromDisk(imagefile,output())
