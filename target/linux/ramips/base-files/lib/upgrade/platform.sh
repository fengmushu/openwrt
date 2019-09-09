#
# Copyright (C) 2010 OpenWrt.org
#

PART_NAME=firmware
REQUIRE_IMAGE_METADATA=1

platform_check_image() {
	return 0
}

platform_do_upgrade() {
	local board=$(board_name)

	case "$board" in
	mikrotik,rb750gr3|\
	mikrotik,rbm11g|\
	mikrotik,rbm33g)
		[ -z "$(rootfs_type)" ] && mtd erase firmware
		;;
	esac

	case "$board" in
	hiwifi,hc5962|\
	netgear,r6220|\
	netgear,r6260|\
	netgear,r6350|\
	netgear,r6850|\
	xiaomi,mir3g|\
	xiaomi,mir3p|\
	xiaomi,miwifi-r3)
		# this make it compatible with breed
		dd if=/dev/mtd0 bs=64 count=1 2>/dev/null | grep -qi breed && CI_KERNPART_EXT="kernel_stock"
		nand_do_upgrade "$1"
		;;
	tplink,archer-c50-v4)
		MTD_ARGS="-t romfile"
		default_do_upgrade "$1"
		;;
	ubiquiti,edgerouterx|\
	ubiquiti,edgerouterx-sfp)
		platform_upgrade_ubnt_erx "$1"
		;;
	*)
		default_do_upgrade "$1"
		;;
	esac
}
