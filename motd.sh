#!/bin/bash

# Stylized greeter. Displays a colorized info box.

showmotd () {
	# The different colors as variables

	# Background. Default: blue (40m)
	local BG="\e[40m"
	# Item descriptions (text on the left)
	# Default: bold red (01;31m)
	local R="\e[01;31m"
	# Returned status (text on the right)
	# Default: bold white (01;37m)
	local W="\e[01;37m"
	# Reset style (don't modify)
	local N="\e[m"

	# Padding string.
	local PAD="   "

	local HOSTNAME=`uname -n`
	local KERNEL=`uname -r`
	local UP=`uptime -p`

	local R1="$N $BG$R"$PAD"Host:       ${W}$HOSTNAME"
	local R2="$N $BG$R"$PAD"Kernel:     ${W}$KERNEL"
	local R3="$N $BG$R"$PAD"Uptime:     ${W}$(echo $UP | cut -d ' ' -f 2-)"
	local Rb="$N $BG$R"$PAD"Last Login: ${W}"

	# Parse last login.
	local Rh=`last -2wda | awk 'FNR == 2 { printf $NF }'`
	local Rt=`last -2wi | awk -v PAD="$PAD" -v H="$Rh" 'FNR == 2 { \
	L=$3; R2="|" PAD "             " $1 " @ " $4 " " $5  " " $6 " " $7 "-" $9; printf L R2 }'`

	# Parse awk output using | as separator.
	IFS='|'; read -a RS <<< "${Rt}"

	if [ ${RS[0]} = "0.0.0.0" ]; then
		local R4="${Rb}local session"
	else
		local R4="${Rb}${RS[0]}"
		if [ ${RS[0]} != ${Rh} ]; then
			local R4=${R4}" ("${Rh}")"
		fi
	fi

	local R5="$N $BG$W"${RS[1]}

	# Compensate for length of last row (color codes add length to other rows).
	local M5=`expr ${#R5} + ${#R}`

	# Alternative box widths.
	#local NCOL=`tput cols`
	#local NCOL=60

	# Compute trailing whitespace lengths.
	local NCOL=`printf "${#R1}\n${#R2}\n${#R3}\n${#R4}\n${M5}" | sort -rn | head -n1`
	local NCOL=`expr $NCOL + ${#PAD}`
	local L1=`expr $NCOL - ${#R1}`
	local L2=`expr $NCOL - ${#R2}`
	local L3=`expr $NCOL - ${#R3}`
	local L4=`expr $NCOL - ${#R4}`
	local L5=`expr $NCOL - ${M5}`

	# Print the greeter.
	printf "\n${R1}%${L1}s$N\n"
	printf   "${R2}%${L2}s$N\n"
	printf   "${R3}%${L3}s$N\n"
	printf   "${R4}%${L4}s$N\n"
	printf   "${R5}%${L5}s$N"

	printf "\n\n"
}

showmotd
