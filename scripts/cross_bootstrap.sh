pacman -Rcns linux-aarch64 vi --noconfirm
pacman-key --init
pacman-key --populate
pacman -Syu base-devel git sudo --noconfirm
echo 'alarm ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/alarm_allow_sudo_no_passwd