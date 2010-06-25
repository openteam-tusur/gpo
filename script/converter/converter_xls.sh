#!/bin/bash
cleanup() {
  rm -f ${ODS} ${XLS}
}

DIR=`dirname $0`
ODS=${1}.ods
XLS=${2}.${3}

cleanup
ln -s ${1} ${ODS}
ln -s ${2} ${XLS}
java -jar ${DIR}/lib/jodconverter-cli-2.2.1.jar ${ODS} ${XLS} 2>/dev/null
cleanup

