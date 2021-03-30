root@babasse # cat > /etc/cron.daily/borg-backup

#!/bin/sh

#

# Script de sauvegarde.

#

# Envoie les sauvegardes sur un serveur distant, via le programme Borg.

# Les sauvegardes sont chiffrées

#

 

set -e

 

BACKUP_DATE=`date +%Y-%m-%d`
LOG_PATH=/var/log/borg-backup.log

BORG_REPOSITORY=borg@172.26.0.10:/root/saves/web1
BORG_ARCHIVE=${BORG_REPOSITORY}::${BACKUP_DATE}

borg create \
-v --stats --compression lzma,9 \
$BORG_ARCHIVE \
"/Here the /path of the /dir to save" \
>> ${LOG_PATH} 2>&1
 

# Prune backup clean
# - 1 save per day for the last 7 days,
# - 1 save per week for the last 4 weeks,
# - 1 save per month for the last 6 month,.

borg prune -v $BORG_REPOSITORY \
--keep-daily=7 \
--keep-weekly=4 \
--keep-monthly=6 \
>> ${LOG_PATH} 2>&1