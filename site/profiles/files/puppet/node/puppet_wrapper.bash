#!/bin/bash

# Script to launch a puppet run in masterles mode
#
# Var :
#  env : environment for puppet run.
#  r10k-logs : log file for r10k run.
#  logs : log file for puppet run.

OPTIONS=""

while [[ $# -gt 1 ]]
do
  key="$1"

  case $key in
      -e|--environment)
      ENV="$2"
      shift # past argument
      ;;
      --r10k-logs)
      R10K_LOGS="$2"
      shift # past argument
      ;;
      --logs)
      LOG="$2"
      shift # past argument
      ;;
      *)
      echo "syntax : puppet_wrapper.bash
        -e|--environment <YOUR ENV>
        --r10k-logs <PATH TO LOG r10k run>
        --logs <PATH TO LOG puppet run execution>."
      exit 1
      ;;
  esac
  shift # past argument or value
done

if [ -z $R10K_LOGS ];then
  R10K_LOGS=/var/log/puppetlabs/puppet/r10k.log
fi

if [ -z $LOGS ];then
  LOGS=/var/log/puppetlabs/puppet/puppet_run.log
fi

if [ -z $ENV ];then
  ENV=$(cat /etc/puppetlabs/puppet/puppet.conf | grep environment | awk '{print $3}')
fi


# if [ ${#ENV} -gt 0 ];then
#   OPTIONS="--environment ${ENV}"
# fi

# Update code
ts=$(date +"%Y-%m-%d %H:%M:%S")
echo "r10k starts : $ts" >>$R10K_LOGS
/opt/puppetlabs/puppet/bin/r10k deploy environment --puppetfile -v 1>>$R10K_LOGS 2>&1
ts=$(date +"%Y-%m-%d %H:%M:%S")
echo "r10k ends : $ts" >>$R10K_LOGS

# Launch a puppet run
ts=$(date +"%Y-%m-%d %H:%M:%S")
echo "puppet run starts : $ts" >>$LOGS
/opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/environments/${ENV}/site.pp 1>>$LOGS 2>&1
ts=$(date +"%Y-%m-%d %H:%M:%S")
echo "puppet run ends : $ts" >>$LOGS
