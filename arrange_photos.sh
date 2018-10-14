#!/usr/bin/env bash

DIR="$1"
BASEDIR="$2"
LABEL="$3"
FINDOPTS="$4"

function getShotAt() {
   exiftool -dateTimeOriginal -dateFormat %s -veryShort "$1" 2>/dev/null | cut -d' ' -f2
}

if [ -z "$DIR" ] ; then
   DIR="$(pwd)"
fi

if [ -z "$BASEDIR" ] ; then
   BASEDIR="${DIR}/ARRANGED"
fi

find "${DIR}" -type f $FINDOPTS | while read FPATH ; do
   SHOTAT=`getShotAt "${FPATH}"`
   FMOD=`stat -c'%Y' "${FPATH}"`
   FNAME=`basename "${FPATH}"`
   FEXT="${filename##*.}"

   if [ -z "$SHOTAT" ] ; then
       SHOTAT="${FMOD}"
       echo "  (cannot get shot date, fallback to file mod time)"
   fi

   NEWDIR=`date -d "@${FMOD}" +'%Y/%m/%Y-%m-%d'`

   if [ ! -z "$LABEL" ] ; then
       NEWDIR="${NEWDIR}-${LABEL}"
   fi

   NEWPATH="${BASEDIR}/${NEWDIR}/$FNAME"
   echo -e "+ ${FPATH}\t->\t${NEWPATH}"
#   mkdir -p "${BASEDIR}/${NEWDIR}"
#   mv "${FPATH}" "${NEWPATH}"
done
