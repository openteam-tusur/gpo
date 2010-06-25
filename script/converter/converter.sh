#!/bin/bash
cleanup() {
  rm -f ${ODT} ${DOC}
}

DIR=`dirname $0`
ODT=${1}.odt
DOC=${2}.${3}

cleanup
ln -s ${1} ${ODT}
ln -s ${2} ${DOC} 
java -jar ${DIR}/lib/jodconverter-cli-2.2.1.jar ${ODT} ${DOC} 2>/dev/null
cleanup
