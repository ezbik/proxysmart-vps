#!/bin/bash

function usage {
  echo "$(basename $0) usage: "
  echo "    -w warning_level Example: 80"
  echo "    -c critical_level Example: 90"
  echo "    -ws steal_warning_level Example: 20"
  echo "    -cs steal_critical_level Example: 40"
  echo ""
  exit 1
}

while [[ $# -gt 1 ]]
do
    key="$1"
    case $key in
      -w)
      WARN="$2"
      shift
      ;;
      -c)
      CRIT="$2"
      shift
      ;;
      -ws)
      WARN_ST="$2"
      shift
      ;;
      -cs)
      CRIT_ST="$2"
      shift
      ;;
      *)
      usage
      shift
      ;;
  esac
  shift
done

[ ! -z ${WARN} ] && [ ! -z ${CRIT} ] || usage
[ -z $WARN_ST ] && WARN_ST=20
[ -z $CRIT_ST ] && CRIT_ST=40

CPU_USAGE="$(vmstat 1 2|tail -1)"
CPU_USER="$(echo ${CPU_USAGE} | awk '{print $13}')"
CPU_SYSTEM="$(echo ${CPU_USAGE} | awk '{print $14}')"
CPU_IDLE="$(echo ${CPU_USAGE} | awk '{print $15}')"
CPU_IOWAIT="$(echo ${CPU_USAGE} | awk '{print $16}')"
CPU_ST="$(echo ${CPU_USAGE} | awk '{print $17}')"

CPU_TOTAL=$(( $CPU_USER + $CPU_SYSTEM ))

PERF_DATA="CPU_TOTAL=${CPU_TOTAL};$WARN;$CRIT;; "

if [[ ${CPU_TOTAL} -gt ${CRIT} || ${CPU_TOTAL} -gt ${CRIT} ]]
then
  echo "CRITICAL - CPU Usage $CPU_TOTAL% |$PERF_DATA"
  exit 2
elif [[ ${CPU_TOTAL} -gt ${WARN} || ${CPU_TOTAL} -gt ${WARN} ]]
then
  echo "WARNING - CPU Usage $CPU_TOTAL% |$PERF_DATA"
  exit 1
else
  echo "OK - CPU Usage $CPU_TOTAL% |$PERF_DATA"
  exit 0
fi
