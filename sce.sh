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
# Script     : sce.sh 
# Usage      : ./sce.sh -sf /path/to/seed -i num_iterations -id job_id [-l /path/to/log]
# Author     : Sujen Shah, Giuseppe Totaro
# Date       : 06-28-2017 [MM-DD-YYYY]
# Last Edited: 06-14-2017, Giuseppe Totaro
# Description: This script allows to inject a seed file into Sparkler and then 
#              crawl the URLs through the Docker container.
# Notes      : This script is included in the following repository:
#              https://github.com/memex-explorer/sce
#

function print_usage() {
	echo "Usage: $0 -sf /path/to/seed -i num_iterations -id job_id [-l /path/to/log]"
	printf "\n\t-sf\n\t\tPath to the seed file.\n"
	printf "\n\t-i\n\t\tNumber of iterations to run.\n"
	printf "\n\t-id\n\t\tJob identifier.\n"
	printf "\n\t-l <dir>, --log-file <dir>\n\t\tPath to the log file. If it is not specified, the script writes out everything on the standard output.\n"
}

if [ $# -lt 6 ]
then
	print_usage
	exit 1
fi

while [ ! -z $1 ]
do
	case $1 in
		-sf)
			SEED="$2"
			shift
			;;
		-i)
			ITERATIONS="$2"
			shift
			;;
		-id)
			JOB_ID="$2"
			shift
			;;
		-l|--log-file)
			LOG_FILE="$2"
			shift
			;;
			*)
			print_usage
			exit 1
			;;
		esac
	shift
done

if [ ! -f $SEED ]
then
	echo "Error: you must provide a valid seed file."
	print_usage
	exit 1
fi

if [ -z $ITERATIONS ]
then
	echo "Error: you must provide the number of iterations."
	print_usage
	exit 1
fi

if [ -z $JOB_ID ]
then
	echo "The name of the seed file will be used as job identifier."
	seed_filename=$(basename $SEED)
	JOB_ID=${seed_filename%.*}
	exit 1
fi

## Full directory name of the script no matter where it is being called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z $LOG_FILE ]
then 
	mkdir -p $DIR/logs
	LOG_FILE="$DIR/logs/sce.log"
	[[ -f $LOG_FILE ]] && mv "$LOG_FILE" "$LOG_FILE.$(date +%Y%m%d)"
fi

echo "The crawl job has been started. All the log messages will be reported to $LOG_FILE"

docker cp $SEED $(docker ps -a -q --filter="name=compose_sparkler_1"):/data/seed_$(basename $SEED) >> $LOG_FILE 2>&1

docker exec compose_sparkler_1 /data/sparkler/bin/sparkler.sh inject -sf /data/seed_$(basename $SEED) -id $JOB_ID >> $LOG_FILE 2>&1

docker exec compose_sparkler_1 /data/sparkler/bin/sparkler.sh crawl -i $ITERATIONS -id $JOB_ID >> $LOG_FILE 2>&1
