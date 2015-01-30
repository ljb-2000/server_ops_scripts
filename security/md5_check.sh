#! /bin/bash

#declare variable
shopt -s -o nounset

Date=$(date +'%Y%m%d%H%M%S')

Dirs="/bin /sbin /usr/bin /usr/sbin /lib /usr/local/sbin /usr/local/bin /usr/local/lib"

tmpFile=$(mktemp)

#store checksum
FP="/root/fp.$Date.chksum"

Checker="/usr/bin/md5sum"
#Checker="/usr/bin/sha1sum"

Find="/usr/bin/find"

scan_files() {
  local f
  for f in $Dirs
  do
    $Find $f -type f >> $tmpFile
  done
}

cr_checksum_list() {
  local f
  if [ -f $tmpFile ];then
    for f in $(cat $tmpFile);
      do $Checker $f >> $FP
    done
  fi
}

rmTMP() {
  [ -f $tmpFile ] && rm -rf $tmpFile
}

scan_files

cr_checksum_list

rmTMP
