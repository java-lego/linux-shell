#!/bin/bash

function clean_docker_log(){
    local log_dirs=$(docker inspect --format='{{.LogPath}}' $(docker ps -q))
	
	if [ "$log_dirs" ]; then
		for dir in $log_dirs; do
			find $dir* -type f -size +900M -exec ls -lh {} \;
			find $dir* -type f -size +900M -exec sh -c 'echo "" >  {}' \;
		done
	fi
	echo "【完成】"
}

clean_docker_log