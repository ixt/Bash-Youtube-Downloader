#!/bin/bash
#
#
# Youtube Video Downloader bash shell version
#
# usage: ./get_video.sh https://www.youtube.com/watch?v=xxxxxxxxxx
#
# Rev 1.1a
# 2016/11/26
# Modified by NfN Orange <orange@ff4500.red>
# Copyright 2013 Jacky Shih <iluaster@gmail.com>
#
# Licensed under the GNU General Public License, version 2.0 (GPLv2)
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
# NON INFRINGEMENT.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
#


declare -i line=0

function select_option ()
{
  for i in `cat video_type_option.txt`
  do
    line=line+1
    echo "${line}.$i"
  done

  echo "Which one ?"
  read n

  if [ "$n" -le "$line" ];
  then
   head -n "$n" tmp3.txt | tail -n 1 > tmp4.txt
  else
   echo "Input Error!!"
   exit
  fi
}

echo "$1" > youtube_tmp.txt
id_name=`perl -ne 'print "$1\n" if /v=(.*)/' youtube_tmp.txt`

  name="http://www.youtube.com/get_video_info?video_id=${id_name}"
  wget "$name" -qO- |sed -e 's/&/\n/g' | grep 'url_encoded_fmt_stream_map' | sed -e 's/%2C/,/g' -e 's/,/\n/g' > tmp3.txt
# cut and filter mp4 url

# print out total video format name and quality
  perl -ne 'print "$2,$1\n" if /quality%3D(.*?)%.*video%252F(.*?)(%|\n)/' tmp3.txt > video_type_option.txt

# if video format name is prior to quality
  perl -ne 'print "$1,$2\n" if /video%252F(.*?)%.*quality%3D(.*?)(%|\n)/' tmp3.txt >> video_type_option.txt
  sed -i -e 's/x-flv/flv/g' video_type_option.txt

  select_option

# set file extension name variable and video quality variable
  extension_name=`head -n "$n" video_type_option.txt | tail -n 1 | cut -d "," -f 1`
  quality_name=`head -n "$n" video_type_option.txt | tail -n 1 | cut -d "," -f 2`

  sed -i -e 's/%26/\&/g' -e 's/&/\n/g' tmp4.txt
  egrep 'http|sig%3D' tmp4.txt > tmp5.txt
# url decoding
  perl -pe 's/\n//g' tmp5.txt |\
      sed -e 's/sig%3D/\&signature%3D/g;s/url%3D//g;s/%25/%/g;s/%25/%/g;
      s/%3A/:/g;s/%2F/\//g;s/%3F/\?/g;s/%3D/=/g;s/%26/\&/g' > tmp7.txt

  wget -i tmp7.txt -O "${id_name}_${quality_name}.${extension_name}"

  # rm -f tmp[2-7].txt

