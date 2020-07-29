#!/usr/bin/bash

NGINX_A_LOG_FILE='.././nginx0_log/access.log';
UNIQ_IP_SAVED_FILE='uniq_ip_saved.txt';
LAST_NUM_OF_LOG_FILE='last_log_num.txt';
TMP_FILE='tmp_file.txt'

LAST_NUM_OF_LOG=0;
NOW_NUM_OF_LOG=0;
GREP_LINE='';

if test -f "$UNIQ_IP_SAVED_FILE"; then
    LAST_NUM_OF_LOG=`cat $LAST_NUM_OF_LOG_FILE`;
else
    `cat $NGINX_A_LOG_FILE | awk '{print $1;}'| sort | uniq > $UNIQ_IP_SAVED_FILE`;
    `wc -l < $NGINX_A_LOG_FILE > $LAST_NUM_OF_LOG_FILE`;
    exit;
fi

NOW_NUM_OF_LOG=`wc -l < $NGINX_A_LOG_FILE`;

if (($NOW_NUM_OF_LOG>$LAST_NUM_OF_LOG)); then
    `tail -n +$LAST_NUM_OF_LOG "$NGINX_A_LOG_FILE" | awk '{print $1;}'| sort | uniq > $TMP_FILE`;
    while read line
    do
	GREP_LINE=`grep -a "$line" $UNIQ_IP_SAVED_FILE`;
	if [ -z "$GREP_LINE" ]; then
	    echo "$line" >> "$UNIQ_IP_SAVED_FILE";
	fi
    done < $TMP_FILE;
    rm $TMP_FILE;
    `echo "$NOW_NUM_OF_LOG" > "$LAST_NUM_OF_LOG_FILE"`;
fi
