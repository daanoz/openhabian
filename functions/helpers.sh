#!/usr/bin/env bash

# Attention: This file will be sourced earlier than all others

# Colors for later use
ESC="\033["
COL_DEF=$ESC"39;49;00m"
COL_RED=$ESC"31;01m"
COL_GREEN=$ESC"32;01m"
COL_YELLOW=$ESC"33;01m"
COL_BLUE=$ESC"34;01m"
COL_MAGENTA=$ESC"35;01m"
COL_CYAN=$ESC"36;01m"
COL_LGRAY=$ESC"37;01m"
COL_DGRAY=$ESC"90;01m"

cond_redirect() {
  if [ -n "$SILENT" ]; then
    "$@" &>/dev/null
    return $?
  else
    echo -e "\n$COL_DGRAY\$ $@ $COL_DEF"
    "$@"
    return $?
  fi
}

cond_echo() {
  if [ -z "$SILENT" ]; then
    echo -e "$COL_YELLOW$@$COL_DEF"
  fi
}

is_pizero() {
  grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]09[0-9a-fA-F]$" /proc/cpuinfo
  return $?
}
is_pizerow() {
  grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]0[cC][0-9a-fA-F]$" /proc/cpuinfo
  return $?
}
is_pione() {
  if grep -q "^Revision\s*:\s*00[0-9a-fA-F][0-9a-fA-F]$" /proc/cpuinfo; then
    return 0
  elif  grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]0[0-36][0-9a-fA-F]$" /proc/cpuinfo; then
    return 0
  else
    return 1
  fi
}
is_pitwo() {
  grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]04[0-9a-fA-F]$" /proc/cpuinfo
  return $?
}
is_pithree() {
  grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]08[0-9a-fA-F]$" /proc/cpuinfo
  return $?
}
is_pi() {
  # needed for raspbian-ua-netinst chroot env
  if [ "$hostname" == "openHABianPi" ] || [ "$boot_volume_label" == "openHABian" ]; then return 0; fi
  # normal conditions
  if is_pizero || is_pizerow || is_pione || is_pitwo || is_pithree; then return 0; fi
  return 1
}
is_pine64() {
  [[ $(uname -r) =~ "pine64-longsleep" ]]
  return $?
}
is_arm() {
  case "$(uname -m)" in
    armv6l|armv7l|armhf|arm64|aarch64) return 0 ;;
    *) return 1 ;;
  esac
}
is_arm64() {
  case "$(uname -m)" in
    arm64|aarch64) return 0 ;;
    *) return 1 ;;
  esac
}
is_ubuntu() {
  [[ $(lsb_release -d) =~ "Ubuntu" ]]
  return $?
}
is_debian() {
  [[ $(lsb_release -d) =~ "Debian" ]]
  return $?
}
is_jessie() {
  [[ $(lsb_release -c) =~ "jessie" ]]
  return $?
}
