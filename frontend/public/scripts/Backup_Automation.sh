#!/bin/bash
set -e
rsync -av --delete /etc /backup/etc_backup
tar czf /backup/etc_backup_$(date +%F).tar.gz /backup/etc_backup
