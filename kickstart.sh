#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Script     : kickstart.sh 
# Usage      : ./kickstart.sh
# Author     : Sujen Shah, Giuseppe Totaro
# Date       : 05-25-2017 [MM-DD-YYYY]
# Last Edited: 05-25-2017, Giuseppe Totaro
# Description: This script automatically builds the docker containers, pulls 
#              the firefox engine and then performs the docker compose tool for 
#              defining and running the multi-container application that allow 
#              Sparkler Crawl Environment to be used by a Subject Matter Expert.
# Notes      : This script is included in the following repository:
#              https://github.com/sujen1412/sce
#

function print_usage() {
	echo "Usage: $0 -l path/to/log"
	printf "\n\t-l <dir>, --log-file <dir>\n\t\tPath to the log file. If it is not specified, the script writes out everything on the standard output."
}

LOG_FILE=/dev/stdout

while [ ! -z $1 ]
do
	case $1 in
		-l|--log-file)
			LOG_FILE="$2"
			echo $LOG_FILE
			shift
			;;
			*)
			print_usage
			exit 1
			;;
		esac
	shift
done

SPARKLER="sparkler-docker"
DD="domain-discovery"
COMPOSE="compose"
FIREFOX="selenium/standalone-firefox-debug"

# Full directory name of the script no matter where it is being called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR/$SPARKLER

docker build -t sparkler . > $LOG_FILE 2>&1

cd $DIR/$DD

docker build -t domain-discovery . > $LOG_FILE 2>&1

#TODO perform docker build in background and check for docker images installed

docker pull $FIREFOX > $LOG_FILE 2>&1

cd $DIR
cd $COMPOSE

docker-compose up > $LOG_FILE 2>&1
