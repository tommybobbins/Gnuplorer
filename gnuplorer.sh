#!/bin/bash
# Name: gnuplorer.sh
# Version: 0.362
# Date: 20-Jan-2012
# Author: tng@chegwin.org
# Description: Program used for gathering enough system information to 
#              be able to rebuild the entire system. It is based on the
#              same philosophy as the explorer program for Solaris.
# Copyright: Tim Gibbon 2012
# Version: 0.2
# Date: 4-Dec-2005
# Description: Added Debian networking in.
# Version: 0.3
# Date: 31-Mar-2006
# Description: LVM addition, more debian configs.
# Version: 0.31
# Date: 29-Aug-2006
# Description: Modified zip behaviour, run as root only
# Version: 0.32
# Date: 5-Oct-2006
# Description: Added more commands and directories.
# Version: 0.33
# Date: 29-Jan-2007
# Description: Moved config file to /usr/local/gnuplorer/etc
# Version: 0.331
# Date: 17-May-2007
# Description: Added more system calls to config file
# Version: 0.341
# Date: 17-Nov-2008
# Description: Added /etc/NetworkManager and /etc/sysconfig
# Version: 0.342
# Date: 15-Jan-2009
# Description: Added mii-tool
# Version: 0.343
# Date: 28-Aug-2009
# Description: Added mdadm
# Version: 0.35
# Date: 30-Aug-2009
# Description: Added lshw, free and lsb
# Version: 0.351
# Date: 15-Nov-2009
# Description: Modified PATH in .cfg, added /proc/mdstat, cron
# Version: 0.36
# Date: 13-Jan-2012
# Description: Modified .cfg to gather /etc/ as one blob
# Version: 0.361
# Date: 13-Jan-2012
# Description: Modified zip to perform --test before removing output dir
# Version: 0.362
# Date: 20-Jan-2012
# Description: Modified DIRECTORY cp to cp -r
# Version: 0.363
# Date 22-Jan-2012
# Description: Major bugfix of 0.362. Changed behaviour of cp to zip for DIRS
#


#    This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

CONFIGDIR="/usr/local/gnuplorer/etc"
CONFIGFILE="${CONFIGDIR}/gnuplorer.cfg"
OUTDIR="/usr/local/gnuplorer/output"

if [ `whoami` != root ]
then
	echo "Sorry needs to be run as root"
	exit 1
fi


if [ ! -e ${CONFIGFILE} ]
then
echo "Sorry - I can't find configfile $CONFIGFILE. Exiting"
exit 1
fi

################
##Source the env variables found in gnuplorer.cfg
. ${CONFIGFILE}
################

DATESTAMP=`date +%d%b%Y`
GNUPLORER_DIR=${OUTDIR}/gnuplorer.${HOSTNAME}.${DATESTAMP}


#############################CLEANUP BEFORE WE DO WORK#######################
find ${OUTDIR} -name gnuplorer.${HOSTNAME}.\*  -exec rm -rf {} \;
ls ${OUTDIR}/gnup*
#############################################################################

#############################################################################
#####FILES######################
for FILE in $FILES
do
  if [ -r ${FILE} ]
      then
      echo "Copying ${FILE}"
      BASENAME=`basename ${FILE}`
      DIRNAME=`echo ${FILE} | sed -e s/${BASENAME}//g;`

      if [ ! -d ${GNUPLORER_DIR}/${DIRNAME} ]
	  then
	  echo "making ${GNUPLORER_DIR}${DIRNAME}"
	  mkdir -p ${GNUPLORER_DIR}/${DIRNAME}

      fi
      cat ${FILE} > ${GNUPLORER_DIR}${FILE}
  fi


done
#############################################################################


#############################################################################
#####DIRECTORIES#################
echo "################################"
for DIRECTORY in $DIRECTORIES
do
  echo ${DIRECTORY}
  if [ -d ${DIRECTORY} ]
      then
      echo "${DIRECTORY} exists"
	WD=`echo ${DIRECTORY} | sed -e 's/\//\_/g'`
	WD=`echo ${DIRECTORY} | sed -e 's/\//\_/g'`
      echo "Zipping to ${WD}"
      zip -r ${GNUPLORER_DIR}/${WD}.zip ${DIRECTORY}
   fi
done #End of for directories
#exit 0
#############################################################################


#############################################################################
#####COMMANDS################

mkdir ${GNUPLORER_DIR}/commands


for CMND in $COMMANDS
  do
  

  CMND_TO_RUN=`echo ${CMND} | sed -e 's/_/\ /g;'`
  CMND_OUTPUT=`echo $CMND`

  echo "${CMND_TO_RUN} >${GNUPLORER_DIR}/commands/${CMND_OUTPUT}"
#  echo ${CMND_OUTPUT}
  ${CMND_TO_RUN} > ${GNUPLORER_DIR}/commands/${CMND_OUTPUT}
  done
#############################################################################



#############################################################################
#Pack up the directory


cd ${OUTDIR}
BASEGNUPLORER_DIR=`basename ${GNUPLORER_DIR}`
zip --test -rm ${BASEGNUPLORER_DIR}.zip ${BASEGNUPLORER_DIR}
md5sum ${GNUPLORER_DIR}.zip >${GNUPLORER_DIR}.zip.md5

echo ########################################################################

if [ -e ${GNUPLORER_DIR}.zip ] 
then
echo "Zipped up to ${GNUPLORER_DIR}.zip"
else
echo "Something went wrong zipping up ${GNUPLORER_DIR}"
fi
echo ########################################################################


#ls -lrt /tmp

#############################################################################
