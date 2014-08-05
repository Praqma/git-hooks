#!/usr/bin/env bash
#


regexp="#[0-9]\+"

grep_msg()
{
	grepped=$( echo $message | grep -i $regexp )
}

process_revision ()
{
  revisions=$(git rev-list $old_revision..$new_revision)
  IFS='\n' read -ra array <<< "$revisions"
  for rid in "${!array[@]}"; do 
	revision=${array[rid]}
    message=$(git cat-file commit $revision | sed '1,/^$/d')
#	grepped=$(echo $message | grep -i "#[0-9]\+")
    grep_msg()
    if [ -z "$grepped" ] ; then
		grepped_none=$(echo $message | grep -i "#none")
		if [ -n "$grepped_none" ] ; then
			echo "Warning, you are committing without a ticket reference" >&1
		else
			echo "You have not included a ticket reference" >&2
			exit 1
		fi
    fi
  done


}

