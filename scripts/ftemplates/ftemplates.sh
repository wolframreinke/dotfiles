#! /bin/bash

# ==============================================================================
#
# This script manages file-type-specific templates. Users cannot add new
# templates with the aid of this script, but new files based on existing
# templates can be created.
#
# this script is a mess. Never touch it again, if you want a happy life.
#
# ==============================================================================

DEBUG="false"
function debug
{
	if [ "$DEBUG" == "true" ]
	then
		echo "[DEBUG] $1"
	fi
}

function display_help
{
	cat $HOME/scripts/ftemplates/ftemplates.help
	return 0
}

function main
{
	local TEMPLATE_LOC="$HOME/scripts/ftemplates"
	local TEMPLATE_STORE="$TEMPLATE_LOC/store"
	local VARS_FILE="$TEMPLATE_LOC/vars.txt"
	local VARS_FILE_TMP="$TEMPLATE_LOC/vars_tmp.txt"

	# --------------------------------
	# Parse the command line arguments
	# --------------------------------

	local TEMPLATE_PATH="$1"
	
	if [ -z "$TEMPLATE_PATH" ]
	then
		echo "No template path specified." >&2
		exit 1
	fi

	debug "Copying vars.txt"
	cp $VARS_FILE $VARS_FILE_TMP
	while [ $# -ne 0 ]
	do
		shift
		echo "echo \"$1\"" >> $VARS_FILE_TMP	
	done

	local VARS="dummy=dummy"
	while read LINE
	do
		if [ "$(echo $LINE | grep 'fname=')" ]
		then
			debug "Found Custom name"
			CUSTOM_NAME=$(echo $LINE|cut -c13-|rev|cut -c2-|rev)
		fi
		VARS="$VARS\n$(eval $LINE)"
	done < $VARS_FILE_TMP
	debug "Vars = ($VARS)"

	for FULL_FNAME in $TEMPLATE_STORE/$TEMPLATE_PATH*
	do
		debug "Formatting file: $FULL_FNAME"
		local FNAME=$(basename $FULL_FNAME)				
		local CONTENT=""
		while read LINE
		do
			if [ -z "$CONTENT" ]
			then
				CONTENT=$LINE
			else
				CONTENT="$CONTENT\n$LINE"
			fi

		done < $FULL_FNAME

		debug "Content = ($CONTENT)"

		if [ "$CUSTOM_NAME" ]
		then
			debug "Custom name = $CUSTOM_NAME"
			echo -e "$VARS" | format "$CONTENT" > "$CUSTOM_NAME"
		else
			debug "FName = $FNAME"
			echo -e "$VARS" | format "$CONTENT" > "$FNAME"	
		fi

	done

	rm $VARS_FILE_TMP

	exit 0
}

main "$@"
