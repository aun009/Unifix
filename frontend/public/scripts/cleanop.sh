#!/bin/bash
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo"
    exit 1
fi
if ! ping -q -c 1 -W 1 google.com &>/dev/null; then
  echo "No internet connection. Exiting."
  exit 1
fi

sudo apt-get install shc -y > /dev/null

cat <<EOF > .temp.sh
#!/bin/bash
if [ "\$EUID" -ne 0 ]; then
    echo "Please run with sudo"
    exit 1
fi

exec > /dev/null 2>&1
find /tmp -type f -mtime +1 -delete
find /var/tmp -type f -mtime +1 -delete
sudo rm -rf /home/*/.local/share/Trash/*/**
sudo rm -rf /root/.local/share/Trash/*/**
sudo rm -rf ~/.cache/thumbnails/*
sudo rm -rf /var/log/apt/history.log
sudo rm -rf /var/log/apt/term.log
sudo rm -rf /var/log/syslog.1
sudo rm -rf /var/log/debug
sudo rm -rf /var/log/messages
sudo rm -rf /var/log/mail.log
sudo apt autoremove -y
sudo apt clean -y
sudo apt autoclean -y
sudo truncate -s 0 /var/log/syslog
sudo truncate -s 0 /var/log/auth.log
sudo truncate -s 0 /var/log/kern.log
sudo truncate -s 0 /var/log/cron.log
sudo truncate -s 0 /var/log/daemon.log
sudo apt-get install deborphan -y
sudo deborphan | xargs sudo apt -y remove --purge
sudo journalctl --vacuum-time=3d
sudo rm -rf /var/log/journal/*
set -eu
snap list --all | awk '/disabled/{print \$1, \$3}' |
    while read snapname revision; do
        snap remove "\$snapname" --revision="\$revision"
    done
sudo rm -r ~/.local/share/Trash/info/ && rm -r ~/.local/share/Trash/files/
if hash pip 2>/dev/null; then
    pip cache purge
    sudo pip cache purge
fi
echo "Cleaned"
EOF

chmod +x .temp.sh
shc -vrf .temp.sh -o /usr/bin/cleanop 2>1 /dev/null
rm .temp.sh .temp.sh.x.c

sudo apt-get purge shc -y > /dev/null

echo "Cleanop installed!!"