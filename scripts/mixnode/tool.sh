#!/bin/bash

#Characters
check_mark="\xE2\x9C\x93"
fail_x="\xE2\x9C\x97"
#Font formats
set_bold="\033[1m"
set_normal="\033[22m"
# nym variables
nym_path=""
nym_config_file=""

###############
## FUNCTIONS ##
###############

find_nym_folder() {
	echo -e "\nSearching for .nym folder on current user, please wait\n"
	nym_path=$(find $HOME -type d -name ".nym" 2>/dev/null)
	if [ -n "$nym_path" ]
	then
		echo -e "$check_mark NYM folder found.\n"
		return
	else
		echo -e "$fail_x NYM folder not found.\n"
		return 1
	fi
}

find_config() {
	node_path="$nym_path/mixnodes"
	nym_node_id=$(find "$node_path" -mindepth 1 -maxdepth 1 -type \
		d -printf "%f\n" | head -n1)
	nym_config_file=$node_path/$nym_node_id/config/config.toml
	
	if ! [ -f "$nym_config_file" ]
	then
		echo -e "Cant find config.toml\n"
		return 1
	fi
}

no_nym_folder_menu() {
	clear ; $EXPLORE_NYM_PATH/display-logo.sh
	while true
	do
		echo -e "\n$set_bold nym-mixnode menu:$set_normal\n"
		echo "1. Install nym-mixnode"
		echo "2. Migrate nym-mixnode"
		echo "3. Quit"
		read -p "Enter your choice: " choice

		case $choice in
			1)
				$EXPLORE_NYM_PATH/install.sh && exit
			    ;;
			2)
				$EXPLORE_NYM_PATH/migrate.sh && exit
				;;
			3)
				exit
				;;
			*)
				echo -e "\n$fail_x Invalid option, please try again."
				;;
		esac
	done
}

has_nym_folder_menu() {
	while true; do
		echo -e "$set_bold nym-mixnode menu:\n$set_normal"
		echo "1. Update nym-mixnode"
		echo "2. Backup nym-mixnode"
		echo "3. Change mixnode details (name/description/link/location)"
		echo "4. Check nym-mixnode status"
		echo "5. Quit"
		read -p "Enter your choice: " choice
		
		case $choice in
		1)
			$EXPLORE_NYM_PATH/update.sh $nym_path && exit
			;;
		2)
			$EXPLORE_NYM_PATH/backup.sh $nym_path && exit
			;;
		3)
			$EXPLORE_NYM_PATH/change-details.sh $nym_path && exit
			;;
		4)
			$EXPLORE_NYM_PATH/status.sh
			;;
		5)
			exit
			;;
		*)
			echo -e "\n$fail_x Invalid option, please try again."
			;;
		esac
	done
}

##############################
## MAIN EXECUTION OF SCRIPT ##
##############################

if find_nym_folder
then
	find_config || exit;

	nym_version=$(grep "version" "$nym_config_file" | awk -F "'" '{print $2}')
	echo -e "\nnym-mixnode current version $nym_version"
	has_nym_folder_menu
else
	no_nym_folder_menu
fi
