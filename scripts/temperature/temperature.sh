#! /bin/bash

# prints to STDOUT the current temperature of the CPU and GPU. The first line
# of the output contains the CPU temperature, the second line contains the
# GPU temperature.
function callInxi
{
	# use inxi to measure the temperature
	inxi -s | grep -Po '\d+\.\d+'
}

function measureCPUTemperature
{
	echo $(callInxi | head -n1)
}

function measureGPUTemperature
{
	echo $(callInxi | tail -n1)
}

# measures the temperature at the CPU and GPU and displays it formatted by
# using the specified template. The template can be an arbitrary string with
# control characters (such like \n) and the two wildcards %cpu and %gpu which
# are replaced with the current temperatures
function displayTemperature
{
	local CPU=$(measureCPUTemperature)
	local GPU=$(measureGPUTemperature)
	echo -e $(echo "$1" | sed "s/\%cpu/$CPU/" | sed "s/\%gpu/$GPU/")
}

# prints the help message for this tool
function printHelp
{
	cat $HOME/scripts/temperature/temperature.help
}

# The main function of the temperature script. This function first evaluates
# the command line arguments and eventually displays the CPU and/or GPU
# temperature on screen.
function temperature_main
{
	# default values of the options, the user can choose. If calling the
	# script without any parameters, these default values are used.
	local LOOP=false
	local TEMPLATE=""
	local FORMAT=false

	# iterate over all command line arguments
	while [ $# -ne 0 ]
	do

		local CURRENT_OPT=$1
		shift

		local CURRENT_ARG=$1

		case $CURRENT_OPT
		in

			# The loop parameter makes the script run until the
			# user terminates it. Until that, the script prints
			# the current temperatures every second.
			-l|--loop)
				LOOP=true;;

			# The template determines, how the temperatures are
			# formatted.
			-t|--template)
				;;
			# Adds to the template the %gpu wildcard. Therefore the
			# GPU temperature will be displayed.
			-g|--gpu)
				TEMPLATE="$TEMPLATE%gpu";;

			# Adds to the template the %cpu wildcard. Therefore the
			# CPU temperature will be displayed.
			-c|--cpu)
				TEMPLATE="$TEMPLATE%cpu";;

			# Omits the formatted output and prints key-value pairs
			# instead. These can be used by the format script
			-f|--format)
				FORMAT=true
				;;

			# displays the help message for this tool.
			-h|--help)
				printHelp;
				exit;;

			# Any unrecognized option is ignored and does not lead
			# to the script being stopped. However, the user is
			# warned about the unkown option.
			-*)
				echo "Unknown option $CURRENT_OPT" >&2;;

			# Non-Option strings are considered the template.
			# Consequently, the user can specify a template as the
			# sole argument.
			*)
				TEMPLATE="$TEMPLATE $CURRENT_OPT"
		esac

	done

	if [ "$FORMAT" == true ]
	then

		local CPU=$(measureCPUTemperature)
		local GPU=$(measureGPUTemperature)
		echo "cpu=$CPU"
		echo "gpu=$GPU"

	else
		# if the template is empty, it is set to %cpu, which will display the
		# cpu temperature.
		if [ -z "$TEMPLATE" ]
		then
			TEMPLATE="%cpu"
		fi
	
		# Decides, whether the tool should run forever or just print the 
		# temperatures once.
		if [ "$LOOP" == true ]
		then
		
			while :
			do
				displayTemperature "$TEMPLATE"
			done

		else

			displayTemperature "$TEMPLATE"

		fi
	fi
}

temperature_main "$@"
