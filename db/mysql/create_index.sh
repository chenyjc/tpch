# !/bin/bash
script=$(readlink -f "$0")
script_path=$(dirname "$script")

source $script_path/tpch.conf

scale_list=${1:-1 3 10 30}

for scale in $scale_list
do
  echo -----------------------------------------------------------
  echo `date +%Y-%m-%d-%H:%M:%S`: start building primary keys and indexes
  $script_path/sql_file.sh $script_path/dss.index tpch_${scale}g 
  echo `date +%Y-%m-%d-%H:%M:%S`: finish building primary keys and indexes
done
