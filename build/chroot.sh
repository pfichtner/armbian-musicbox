#!/bin/bash

ROOTFS_DIR=$1


BACKUP_DIR=`mktemp -d`
backup() {
	[ -r "${ROOTFS_DIR}$1" ] && tar --remove-files -rpf $BACKUP_DIR/backup.tar ${ROOTFS_DIR}$1
}

prepare_chroot() {
    mount -o bind /dev ${ROOTFS_DIR}/dev
    mount -t sysfs none ${ROOTFS_DIR}/sys
    mount -t proc none ${ROOTFS_DIR}/proc
    mount -t devpts none ${ROOTFS_DIR}/dev/pts
        
    # Disable preloaded shared library to get everything including networking to work on x86
    backup /etc/ld.so.preload

    backup ${ROOTFS_DIR}/usr/bin/qemu-arm-static ; cp `which qemu-arm-static` ${ROOTFS_DIR}/usr/bin/
    # Prevent upgraded services from trying to start inside chroot
    backup ${ROOTFS_DIR}/usr/sbin/policy-rc.d
    echo "exit 101" >${ROOTFS_DIR}/usr/sbin/policy-rc.d
    chmod +x ${ROOTFS_DIR}/usr/sbin/policy-rc.d
}

finish_chroot() {
    rm -f ${ROOTFS_DIR}/usr/bin/qemu-arm-static ${ROOTFS_DIR}/usr/sbin/policy-rc.d
    [ -r "$BACKUP_DIR/backup.tar" ] && tar -xpf $BACKUP_DIR/backup.tar && rm $BACKUP_DIR/backup.tar
    sync
    umount ${ROOTFS_DIR}/dev/pts
    umount ${ROOTFS_DIR}/proc
    umount ${ROOTFS_DIR}/sys
    umount ${ROOTFS_DIR}/dev
}

prepare_chroot
trap finish_chroot EXIT
chroot "$@"

