#!/usr/bin/env bash
#

source pre-receive-functions.sh

cat test_messages.txt | while read line
do
	case "$line" in \%*) continue ;; esac
	echo "$line"
	message="$line"
	grep_msg $message 
	if [ "$grepped" != "$line" ]
	then
		echo "Test failure"
		echo "$grepped <> $line"
		exit 1;
	fi
done
