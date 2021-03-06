#!/usr/bin/env bash

show_about() {
  whiptail --title "About openHABian and openhabian-config" --msgbox "openHABian Configuration Tool $(get_git_revision)
  \nThis tool provides a few routines to make your openHAB experience as comfortable as possible. The menu options help with the setup and configuration of your system. Please select a menu entry to learn more.
  \nVisit the following websites for more information:
  - Documentation: http://docs.openhab.org/installation/openhabian.html
  - Development: http://github.com/openhab/openhabian
  - Discussion: https://community.openhab.org/t/13379" 17 80
}

show_main_menu() {
  choice=$(whiptail --title "Welcome to the openHABian Configuration Tool $(get_git_revision)" --menu "Setup Options" 21 116 14 --cancel-button Exit --ok-button Execute \
  "00 | About openHABian    "    "Information about the openHABian project and this tool" \
  "" "" \
  "01 | Update"                  "Pull the latest revision of the openHABian Configuration Tool" \
  "02 | Upgrade System"          "Upgrade all installed software packages to their newest version" \
  "" "" \
  "10 | Apply Improvements"      "Apply the latest improvements to the basic openHABian setup ►" \
  "20 | Optional Components"     "Choose from a set of optional software components ►" \
  "30 | System Settings"         "A range of system and hardware related configuration steps ►" \
  "40 | openHAB related"         "Switch the installed openHAB version or apply tweaks ►" \
  "50 | Backup/Restore"          "Manage backups and restore your system ►" \
  "60 | Manual/Fresh Setup"      "Go through all openHABian setup steps manually ►" \
  "" "" \
  "99 | Help"                    "Further options and guidance with Linux and openHAB" \
  3>&1 1>&2 2>&3)
  RET=$?
  if [ $RET -eq 1 ] || [ $RET -eq 255 ]; then
    # "Exit" button selected or <Esc> key pressed two times
    return 255
  fi

  if [[ "$choice" == "" ]]; then
    true

  elif [[ "$choice" == "00"* ]]; then
    show_about

  elif [[ "$choice" == "01"* ]]; then
    openhabian_update

  elif [[ "$choice" == "02"* ]]; then
    system_upgrade

  elif [[ "$choice" == "10"* ]]; then
    choice2=$(whiptail --title "Welcome to the openHABian Configuration Tool $(get_git_revision)" --menu "Setup Options" 12 116 5 --cancel-button Back --ok-button Execute \
    "11 | Packages          "     "Install needed and recommended system packages" \
    "12 | Bash&Vim Settings"      "Update customized openHABian settings for bash, vim and nano" \
    "13 | System Tweaks"          "Add /srv mounts and update settings typical for openHAB" \
    "14 | Fix Permissions"        "Update file permissions of commonly used files and folders" \
    "15 | FireMotD"               "Upgrade the program behind the system overview on SSH login" \
    3>&1 1>&2 2>&3)
    if [ $? -eq 1 ] || [ $? -eq 255 ]; then return 0; fi
    case "$choice2" in
      11\ *) basic_packages && needed_packages ;;
      12\ *) bashrc_copy && vimrc_copy && vim_openhab_syntax && nano_openhab_syntax ;;
      13\ *) srv_bind_mounts && misc_system_settings ;;
      14\ *) permissions_corrections ;;
      15\ *) firemotd_setup ;;
      "") return 0 ;;
      *) whiptail --msgbox "A not supported option was selected (probably a programming error):\n  \"$choice2\"" 8 80 ;;
    esac

  elif [[ "$choice" == "20"* ]]; then
    choice2=$(whiptail --title "Welcome to the openHABian Configuration Tool $(get_git_revision)" --menu "Setup Options" 18 116 11 --cancel-button Back --ok-button Execute \
    "21 | Log Viewer          "  "openHAB Log Viewer webapp (frontail)" \
    "22 | openHAB Generator"     "openHAB items, sitemap and HABPanel dashboard generator" \
    "23 | Mosquitto"             "MQTT broker Eclipse Mosquitto" \
    "24 | Grafana"               "InfluxDB+Grafana as a powerful persistence and graphing solution" \
    "25 | NodeRED"               "Flow-based programming for the Internet of Things" \
    "26 | Homegear"              "Homematic specific, the CCU2 emulation software Homegear" \
    "27 | knxd"                  "KNX specific, the KNX router/gateway daemon knxd" \
    "28 | 1wire"                 "1wire specific, owserver and related packages" \
    "29 | FIND"                  "Framework for Internal Navigation and Discovery" \
    "2A | miflora-mqtt-daemon"   "Xiaomi Mi Flora Plant Sensor MQTT Client/Daemon" \
    3>&1 1>&2 2>&3)
    if [ $? -eq 1 ] || [ $? -eq 255 ]; then return 0; fi
    case "$choice2" in
      21\ *) frontail_setup ;;
      22\ *) yo_generator_setup ;;
      23\ *) mqtt_setup ;;
      24\ *) influxdb_grafana_setup ;;
      25\ *) nodered_setup ;;
      26\ *) homegear_setup ;;
      27\ *) knxd_setup ;;
      28\ *) 1wire_setup ;;
      29\ *) find_setup ;;
      2A\ *) miflora_setup ;;
      "") return 0 ;;
      *) whiptail --msgbox "A not supported option was selected (probably a programming error):\n  \"$choice2\"" 8 80 ;;
    esac

  elif [[ "$choice" == "30"* ]]; then
    choice2=$(whiptail --title "Welcome to the openHABian Configuration Tool $(get_git_revision)" --menu "Setup Options" 14 116 7 --cancel-button Back --ok-button Execute \
    "31 | Change Hostname     "   "Change the name of this system, currently '$(hostname)'" \
    "32 | Set System Locale"      "Change system language, currently '$(env | grep "LANG=" | sed 's/LANG=//')'" \
    "33 | Set System Timezone"    "Change the your timezone, execute if it's not '$(date +%H:%M)' now" \
    "34 | Change Passwords"       "Change passwords for Samba, openHAB Console or the system user" \
    "35 | Serial Port"            "Prepare serial ports for peripherals like Razberry, SCC, Pine64 ZWave, ..." \
    "36 | Wifi Setup"             "Configure the build-in Raspberry Pi 3 / Pine A64 wifi" \
    "37 | Move root to USB"       "Move the system root from the SD card to a USB device (SSD or stick)" \
    3>&1 1>&2 2>&3)
    if [ $? -eq 1 ] || [ $? -eq 255 ]; then return 0; fi
    case "$choice2" in
      31\ *) hostname_change ;;
      32\ *) locale_setting ;;
      33\ *) timezone_setting ;;
      34\ *) change_password ;;
      35\ *) prepare_serial_port ;;
      36\ *) wifi_setup ;;
      37\ *) move_root2usb ;;
      "") return 0 ;;
      *) whiptail --msgbox "A not supported option was selected (probably a programming error):\n  \"$choice2\"" 8 80 ;;
    esac

  elif [[ "$choice" == "40"* ]]; then
    choice2=$(whiptail --title "Welcome to the openHABian Configuration Tool $(get_git_revision)" --menu "Setup Options" 11 116 4 --cancel-button Back --ok-button Execute \
    "41 | openHAB 2.1 stable   "  "Switch to the openHAB 2.1 release" \
    "   | openHAB 2.2 unstable"   "Switch to the latest openHAB 2.2 snapshot" \
    "42 | Remote Console"         "Bind the openHAB SSH console to all external interfaces" \
    "43 | Reverse Proxy"          "Setup Nginx with password authentication and/or HTTPS access" \
    3>&1 1>&2 2>&3)
    if [ $? -eq 1 ] || [ $? -eq 255 ]; then return 0; fi
    case "$choice2" in
      41\ *) openhab2_stable_updowngrade ;;
      *openHAB\ 2.2\ unstable) openhab2_unstable_setup ;;
      42\ *) openhab_shell_interfaces ;;
      43\ *) nginx_setup ;;
      "") return 0 ;;
      *) whiptail --msgbox "A not supported option was selected (probably a programming error):\n  \"$choice2\"" 8 80 ;;
    esac

  elif [[ "$choice" == "50"* ]]; then
    choice2=$(whiptail --title "Welcome to the openHABian Configuration Tool $(get_git_revision)" --menu "Setup Options" 10 116 3 --cancel-button Back --ok-button Execute \
    "50 | Amanda Backup documentation "   "Read this before installing the Amanda backup software" \
    "51 | Amanda Backup"                  "Set up Amanda to backup your openHAB config and openHABian box" \
    3>&1 1>&2 2>&3)
    if [ $? -eq 1 ] || [ $? -eq 255 ]; then return 0; fi
    case "$choice2" in
      50\ *) whiptail --textbox /opt/openhabian/docs/openhabian-amanda.md --scrolltext 25 116 ;;
      51\ *) amanda_setup ;;
      "") return 0 ;;
      *) whiptail --msgbox "A not supported option was selected (probably a programming error):\n  \"$choice2\"" 8 80 ;;
    esac

  elif [[ "$choice" == "60"* ]]; then
    choice2=$(whiptail --title "Welcome to the openHABian Configuration Tool $(get_git_revision)" --menu "Setup Options" 19 116 12 --cancel-button Back --ok-button Execute \
    "61 | Upgrade System     "    "Upgrade all installed software packages to their newest version" \
    "62 | Packages"               "Install needed and recommended system packages" \
    "63 | Zulu OpenJDK"           "Install Zulu Embedded OpenJDK Java 8" \
    "   | Oracle Java 8"          "(Alternative) Install Oracle Java 8 provided by WebUpd8Team" \
    "64 | openHAB 2"              "Install openHAB 2.1 (stable)" \
    "   | openHAB 2 unstable"     "(Alternative) Install the latest openHAB 2.2 snapshot (unstable)" \
    "65 | System Tweaks"          "Configure system permissions and settings typical for openHAB" \
    "66 | Samba"                  "Install the Samba file sharing service and set up openHAB 2 shares" \
    "67 | Log Viewer"             "The openHAB Log Viewer webapp (frontail)" \
    "68 | FireMotD"               "Configure FireMotD to present a system overview on SSH login (optional)" \
    "69 | Bash&Vim Settings"      "Apply openHABian settings for bash, vim and nano (optional)" \
    3>&1 1>&2 2>&3)
    if [ $? -eq 1 ] || [ $? -eq 255 ]; then return 0; fi
    case "$choice2" in
      61\ *) system_upgrade ;;
      62\ *) basic_packages && needed_packages ;;
      63\ *) java_zulu_embedded ;;
      *Oracle\ Java*) java_webupd8 ;;
      64\ *) openhab2_stable_setup ;;
      *openHAB\ 2\ unstable) openhab2_unstable_setup ;;
      65\ *) srv_bind_mounts && permissions_corrections && misc_system_settings ;;
      66\ *) samba_setup ;;
      67\ *) frontail_setup ;;
      68\ *) firemotd_setup ;;
      69\ *) bashrc_copy && vimrc_copy && vim_openhab_syntax && nano_openhab_syntax ;;
      "") return 0 ;;
      *) whiptail --msgbox "A not supported option was selected (probably a programming error):\n  \"$choice2\"" 8 80 ;;
    esac

  elif [[ "$choice" == "99"* ]]; then
    show_about

  else whiptail --msgbox "Error: unrecognized option \"$choice\"" 10 60
  fi

  if [ $? -ne 0 ]; then whiptail --msgbox "There was an error or interruption during the execution of:\n  \"$choice\"\n\nPlease try again. Open a Ticket if the error persists: $REPOSITORYURL/issues" 12 60; return 0; fi
}
