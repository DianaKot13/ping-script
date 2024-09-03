#!/bin/bash
if [ -z "$1" ]; then
  echo "Использование: $0 <адрес>"
  exit 1
fi
ADDRESS=$1
INTERVAL=1
THRESHOLD=100
FAIL_COUNT=0
while true
do
  PING_RESULT=$(ping -c 1 $ADDRESS | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')
  if [ ! -z "$PING_RESULT" ]; then
    PING_TIME=$(echo "$PING_RESULT" | awk '{printf("%.0f", $1)}')
    if [ $PING_TIME -gt $THRESHOLD ]; then
      echo "Внимание: Время пинга ($PING_TIME ms) превышает допустимый порог в $THRESHOLD ms"
    fi
    FAIL_COUNT=0
  else
    FAIL_COUNT=$((FAIL_COUNT+1))
    echo "Ошибка: Не удалось выполнить пинг $ADDRESS"
    if [ $FAIL_COUNT -ge 3 ]; then
      echo "Ошибка: Пинг не удается выполнить уже $FAIL_COUNT раз подряд"
    fi
  fi
  sleep $INTERVAL
done
