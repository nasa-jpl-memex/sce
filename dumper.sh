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
# Script     : dumper.sh 
# Usage      : ./dumper.sh [-l /path/to/log]
# Author     : Sujen Shah, Giuseppe Totaro
# Date       : 05-30-2017 [MM-DD-YYYY]
# Last Edited: 05-30-2017, Giuseppe Totaro
# Description: This script automatically dumps out the crawled data within the 
#              Sparkler segments. 
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

# Full directory name of the script no matter where it is being called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z $LOG_FILE ]
then 
	mkdir -p $DIR/logs
	LOG_FILE="$DIR/logs/dumper.log"
	[[ -f $LOG_FILE ]] && cat "$LOG_FILE" >> "$LOG_FILE.$(date +%Y%m%d)"
fi

docker exec compose_domain-discovery_1 python /projects/sce/dumper/cdrv3_exporter.py

echo "The dump of segments has been started. All the log messages will be reported also to $LOG_FILE"

for dir in $(ls ${DIR}/data/crawl-segments/)
do
	docker exec compose_sparkler_1 ./sparkler/bin/sparkler.sh dump -i /data/crawl-segments/${dir##*/} -o /data/sparkler/dump/dump-${dir##*/} 2>&1 | tee -a $LOG_FILE
done
