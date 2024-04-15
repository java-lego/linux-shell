#!/bin/bash

pg_name="postgres"
function clean_wal_log(){
	local pg_controldata=$(docker exec -i "${pg_name}" find / -path '/proc' -prune -o -name 'pg_controldata' -print)
	
	echo "pg_controldata = $pg_controldata"
	local pg_data_dir=$(dirname `docker exec -i "${pg_name}" find /var/lib/postgresql -name 'pg_wal' -type d`)
	echo "pg_data_dir = $pg_data_dir"
	
	if [ "$pg_controldata" ] && [ "$pg_data_dir" ];then
		local checkpoint=$(docker exec -i "${pg_name}" bash -c "$pg_controldata -D $pg_data_dir" | grep -oP "[0-9A-Z]{24}")
		echo "pg_wal清理${checkpoint}"
		docker exec -i "${pg_name}" bash -c "pg_archivecleanup ${pg_data_dir}/pg_wal $checkpoint"
		if [ $? -ne 0 ]; then
			echo "【失败】"
			exit 1
		fi
	fi
	echo "【完成】"
}


clean_wal_log