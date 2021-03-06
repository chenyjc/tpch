# !/bin/bash
script=$(readlink -f "$0")
script_path=$(dirname "$script")

source $script_path/tpch.conf

scale_list=${1:-1 3 10 30}

old_path=`pwd`
tables="region nation supplier customer part partsupp orders lineitem"

for scale in $scale_list
do
  echo -----------------------------------------------------------
  echo `date +%Y-%m-%d-%H:%M:%S`: start load ${scale}g data
  for table in $tables
  do
    echo `date +%Y-%m-%d-%H:%M:%S`: load $table
    cd $data_path/${scale}g
    copy_command="COPY $table FROM '${s3_path}/${scale}g/${table}.csv.lzo' 
iam_role '$s3_iam' region '$s3_region' DELIMITER '|' lzop;" 
    $script_path/sql.sh "$copy_command"  tpch_${scale}g 
  done
  echo `date +%Y-%m-%d-%H:%M:%S`: finish load ${scale}g data
  $script_path/sql_file.sh $script_path/dss.check  tpch_${scale}g 
  echo `date +%Y-%m-%d-%H:%M:%S`: done
  echo -----------------------------------------------------------
done

cd $old_path
