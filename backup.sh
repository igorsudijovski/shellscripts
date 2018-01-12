#!/bin/bash

#####################################
# @author Igor Sudijovski
# @date 2018-12-01
#####################################

function extract_param() {
	echo $1 | sed 's/[-a-zA-Z0-9]*=//'
}

function end_script() {
	status=`test $2 -gt 0 && echo "FAILED" || echo "SUCCESS"`
	echo "Scriplet '$1' finished with status: ${status}"
	exit $2
}

SCRIPT_NAME=`basename $0`

#Start script
echo "Start scriplet '${SCRIPT_NAME}'..."

#Define variables
for i in $*
do
	case $i in
		-homedir=*)
			TC_HOMEDIR=`extract_param $i`			
			;;
		-appdir=*)
			TC_APP_DIR=`extract_param $i`
			;;
		-artifactname=*)
			ARTIFACT_NAME=`extract_param $i`			
			;;			
	esac	
done

if [ -z ${ARTIFACT_NAME} ]
then
	echo "Artifact name is not set"
	end_script ${SCRIPT_NAME} 1
fi

if [ -z ${TC_HOMEDIR} ]
then
	echo "Home directory is not set"
	end_script ${SCRIPT_NAME} 1
fi

if [ -z ${TC_APP_DIR} ]
then
	echo "Application directory is not set"
	end_script ${SCRIPT_NAME} 1
fi

DEPLOY_DIR=${TC_HOMEDIR}${TC_APP_DIR}
echo ${DEPLOY_DIR}

#Check if there is an artifact with that name
if [ ! -f ${DEPLOY_DIR}/${ARTIFACT_NAME} ]
then
	echo "There is no artifact at: ${DEPLOY_DIR}/${ARTIFACT_NAME}"
	end_script ${SCRIPT_NAME} 1
fi

#If there is a backup make new backup
#Keeping the old backup until the new backup is created
if [ -f "${DEPLOY_DIR}/${ARTIFACT_NAME}.backup" ]
then
	#Creating new backup
	echo "Creating new backup with name '${DEPLOY_DIR}/${ARTIFACT_NAME}.new.backup'"
	cp ${DEPLOY_DIR}/${ARTIFACT_NAME} "${DEPLOY_DIR}/${ARTIFACT_NAME}.new.backup"
	if [ -f "${DEPLOY_DIR}/${ARTIFACT_NAME}.new.backup" ]
	then
		rm -rf "${DEPLOY_DIR}/${ARTIFACT_NAME}.backup"
		mv "${DEPLOY_DIR}/${ARTIFACT_NAME}.new.backup" "${DEPLOY_DIR}/${ARTIFACT_NAME}.backup"
		echo "Changing the name to '${DEPLOY_DIR}/${ARTIFACT_NAME}.backup'"
		end_script ${SCRIPT_NAME} 0
	else
		end_script ${SCRIPT_NAME} 1
	fi
fi
echo "Creating new backup with name '${DEPLOY_DIR}/${ARTIFACT_NAME}.backup'"
cp ${DEPLOY_DIR}/${ARTIFACT_NAME} "${DEPLOY_DIR}/${ARTIFACT_NAME}.backup"
if [ -f "${DEPLOY_DIR}/${ARTIFACT_NAME}.backup" ]
then
	end_script ${SCRIPT_NAME} 0
else
	end_script ${SCRIPT_NAME} 1
fi