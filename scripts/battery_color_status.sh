#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

# script global variables
color_status_primary_charged=''
color_status_primary_charging=''
color_status_primary_discharging=''
color_status_primary_attached=''
color_status_primary_unknown=''
color_status_secondary_charged=''
color_status_secondary_charging=''
color_status_secondary_discharging=''
color_status_secondary_attached=''
color_status_secondary_unknown=''

# script default variables
color_status_primary_charged_default='colour33'
color_status_primary_charging_default='colour33'
color_status_primary_discharging_default='colour14'
color_status_primary_attached_default='colour201'
color_status_primary_unknown_default='colour7'
color_status_secondary_charged_default='colour0'
color_status_secondary_charging_default='colour0'
color_status_secondary_discharging_default='colour0'
color_status_secondary_attached_default='colour0'
color_status_secondary_unknown_default='colour0'

# colors are set as script global variables
get_color_status_settings() {
	color_status_primary_charged=$(get_tmux_option "@batt_color_status_primary_charged" "$color_status_primary_charged_default")
	color_status_primary_charging=$(get_tmux_option "@batt_color_status_primary_charging" "$color_status_primary_charging_default")
	color_status_primary_discharging=$(get_tmux_option "@batt_color_status_primary_discharging" "$color_status_primary_discharging_default")
	color_status_primary_attached=$(get_tmux_option "@batt_color_status_primary_attached" "$color_status_primary_attached_default")
	color_status_primary_unknown=$(get_tmux_option "@batt_color_status_primary_unknown" "$color_status_primary_unknown_default")
	color_status_secondary_charged=$(get_tmux_option "@batt_color_status_secondary_charged" "$color_status_secondary_charged_default")
	color_status_secondary_charging=$(get_tmux_option "@batt_color_status_secondary_charging" "$color_status_secondary_charging_default")
	color_status_secondary_discharging=$(get_tmux_option "@batt_color_status_secondary_discharging" "$color_status_secondary_discharging_default")
	color_status_secondary_attached=$(get_tmux_option "@batt_color_status_secondary_attached" "$color_status_secondary_attached_default")
	color_status_secondary_unknown=$(get_tmux_option "@batt_color_status_secondary_unknown" "$color_status_secondary_unknown_default")
}

print_fg_color_status() {
	local status="$1"
	if [[ $status =~ (charged) || $status =~ (full) ]]; then
		printf "$color_status_primary_charged"
	elif [[ $status =~ (^charging) ]]; then
		printf "$color_status_primary_charging"
	elif [[ $status =~ (^discharging) ]]; then
		printf "$color_status_primary_discharging"
	elif [[ $status =~ (attached) ]]; then
		printf "$color_status_primary_attached"
	else
		printf "$color_status_primary_unknown"
	fi
}

print_bg_color_status() {
	local status="$1"
	if [[ $status =~ (charged) || $status =~ (full) ]]; then
		printf "$color_status_secondary_charged"
	elif [[ $status =~ (^charging) ]]; then
		printf "$color_status_secondary_charging"
	elif [[ $status =~ (^discharging) ]]; then
		printf "$color_status_secondary_discharging"
	elif [[ $status =~ (attached) ]]; then
		printf "$color_status_secondary_attached"
	else
		printf "$color_status_secondary_unknown"
	fi
}

print_color_status() {
	local plane="$1"
	local status="$2"
	if [ "$plane" == "fg" ]; then
		print_fg_color_status "$status"
	else
		print_bg_color_status "$status"
	fi
}

main() {
	local plane="$1"
	local status=${2:-$(battery_status)}
	get_color_status_settings
	print_color_status "$plane" "$status"
}

main $@
