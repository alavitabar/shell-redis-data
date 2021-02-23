#!/bin/bash
keys=`redis-cli -n 2  keys '*'`
if [ "$keys" ]; then
    echo "$keys" | while IFS= read -r key; do
        type=`echo | redis-cli -n 2 type "$key"`
        case "$type" in
            string) value=`echo | redis-cli -n 2  get "$key"`;;
            hash) value=`echo | redis-cli -n 2 hgetall "$key"`;;
            set) value=`echo | redis-cli -n 2 smembers "$key"`;;
            list) value=`echo | redis-cli -n 2 lrange "$key" 0 -1`;;
            zset) value=`echo | redis-cli -n 2 zrange "$key" 0 -1 withscores`;;
        esac
        echo "> $key ($type):" >> ./log.txt
        echo "$value" >> ./log.txt | sed -E 's/^/    / ' 
    done
fi
