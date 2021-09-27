#!/bin/bash

TS_PTRN="%Y-%m-%dT%H:%M:%S.%3N"

echo $(date +$TS_PTRN)": CFL Demo restart started"

# Git URL to demo package project
DEMO_GIT=""
# Location where running Demo saves reports (docker host location)
REPORT_VOLUME_DIR="/root/.cfl/reports"
# Name of branch to checkout from DEMO_GIT
DEMO_BRANCH=demo
# Work dir for this script (crontab executes in home dir)
WORK_DIR=./demo-restart-workdir
# Directory where to copy reports (executed in WORK_DIR)
REPORT_DIR=./reports
# Name of DEMO_GIT project
DEMO_PROJECT=cfl-openmrs
# Location of server start script within DEMO_GIT project
SCRIPTS_PROJECT_DIR=cfl
# The name of script used to start the demo server (all in one)
START_SCRIPT=server-start.sh

# Prepare work directory
echo $(date +$TS_PTRN)": Create work directory"
mkdir -p $WORK_DIR
pushd $WORK_DIR > /dev/null

  # Checkout or pull latest demo package
  if [ ! -d "$DEMO_PROJECT/.git" ]
  then
    echo $(date +$TS_PTRN)": Checkout demo package"
    git clone -b "$DEMO_BRANCH" "$DEMO_GIT" "$DEMO_PROJECT"
  else
    pushd $DEMO_PROJECT > /dev/null
    echo $(date +$TS_PTRN)": Pull changes to demo package"
    git pull --ff-only
    popd > /dev/null #$DEMO_PROJECT
  fi

# Copy reports from docker volume dir to work dir
  echo $(date +$TS_PTRN)": Save reports"
  mkdir -p $REPORT_DIR
  cp -ua "$REPORT_VOLUME_DIR/." $REPORT_DIR

# Clean previous and start new demo
  pushd "$DEMO_PROJECT/$SCRIPTS_PROJECT_DIR" > /dev/null
    echo $(date +$TS_PTRN)": Start demo docker"
    . "$START_SCRIPT"
  popd > /dev/null #$DEMO_PROJECT/$SCRIPTS_PROJECT_DIR

popd > /dev/null #$WORK_DIR

echo $(date +$TS_PTRN)": CFL Demo restart completed - demo startup in progress"
