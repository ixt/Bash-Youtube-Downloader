Youtube downloader
==================

Youtube video downloader bash shell version

> ./get_video.sh https://www.youtube.com/watch?v=xxxxxxxxxx [ -f ext,quality ]

e.g.

> ./get_video.sh https://www.youtube.com/watch?v=dgKGixi8bp8 -f mp4,medium

Doesn't depend on python.
uses wget, sed, egrep, head, tail, cut, grep, perl, rm
should be quite portable, only tested on Debian Testing (2016/11/26)
