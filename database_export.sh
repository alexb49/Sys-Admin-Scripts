#!/bin/bash

##############
#auth: alexis
##############

TECHOPSDBHOST=_YOUR_DB_HOST_
OUTPUT_PATH="_YOUR_BACKUP_DIRECTORY"
USER=_YOUR_DB_USER_
DATABASE=_YOUR_DATABASE_NAME_
DATE=`date +%Y-%m-%d`

# Get the DB password
PASSWORD_PATH="/root/secure/cmdb_pw"
while IFS= read -r var
do
  PASSWORD="$var"
done < "$PASSWORD_PATH"


## Usage message
Usage () {

        echo
        echo "DESCRIPTION"
        echo "     The options are as follows:"
        echo
        echo "     -t      def: table. <table1|table2|table3|...etc>. Optional. Can be comma separated valyes"
        echo
        echo "     -n      def: no data. To use if you only want the Database Schema"
        echo
        echo "DEFAULT"
        echo "      Will dump the whole DataBase and its data."
        echo
        echo "EXAMPLES"
        echo
        echo "$0 -t table1"
        echo "$0 -t table2 -n"
        echo "$0 -t table3,table4 -n"
        echo "$0"
        echo
        exit 1
}


while getopts t:nh flag; do
  case $flag in
    t)
      tables="${OPTARG}"
      ;;
    n)
      get_data="1"
      ;;
    h)
      Usage
      ;;
  esac
done


IssueCommand () {

  for table in $(echo ${tables} | sed "s/,/ /g"); do 
    OUTPUT_PATH="${OUTPUT_PATH}-${table}"
    COMMAND="${COMMAND} ${table}"
  done   
  ${COMMAND} > ${OUTPUT_PATH}-${DATE}.sql
  echo "${OUTPUT_PATH}-${DATE}.sql created"

}


COMMAND="mysqldump -h${TECHOPSDBHOST} -u${USER} -p${PASSWORD}"


if [[ "${get_data}" == "1" ]]; then
  COMMAND="${COMMAND} --no-data"
fi


COMMAND="${COMMAND} ${DATABASE}"


if [[ "${tables}" != "" ]]; then
  IssueCommand ${tables} {OUTPUT_PATH}
else
  OUTPUT="${OUTPUT_PATH}-${DATE}.sql"
  ${COMMAND} > ${OUTPUT}
  echo "${OUTPUT} created"
fi