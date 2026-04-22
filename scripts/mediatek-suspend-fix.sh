#!/bin/bash

case ${1} in
	pre)
		rmmod mt7925e mt7925-common mt792x-lib mt76-connac-lib mt76
		;;
	post)
		modprobe mt7925e
		;;
esac
