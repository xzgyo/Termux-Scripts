#!/data/data/com.termux/files/usr/bin/bash
cat <<'EOF'
Termux Proot-Distro + Debian + xfce4 自动安装
Author: @xzgyo (Github) UID:513547173(Bilibili)
EOF
pkg upd -y && pkg upg -y
pkg i nano vim mc curl wget git -y
pkg i x11-repo root-repo -y
pkg i termux-x11-nightly pulseaudio proot-distro -y
pd i debian
pd sh debian --isolated --shared-tmp -- /bin/bash -c "apt update -y && apt upgrade -y && apt install sudo nano vim wget curl git -y"
pd sh debian --isolated --shared-tmp -- /bin/bash -c "useradd -m -u 1000 user && usermod -aG sudo user && echo 'user ALL=(ALL:ALL) ALL' > /etc/sudoers.d/user-1000"
pd sh debian --isolated --shared-tmp -- /bin/bash -c "apt install xfce4 dbus-x11"
cat > startxfce4_debian.sh <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
kill -9 $(pgrep -f "termux.x11") 2>/dev/null
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
export XDG_RUNTIME_DIR=${TMPDIR}
termux-x11 :0 >/dev/null &
sleep 3
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity > /dev/null 2>&1
sleep 1
proot-distro login debian --isolated --shared-tmp -- /bin/bash -c  'export PULSE_SERVER=127.0.0.1 && export XDG_RUNTIME_DIR=${TMPDIR} && su - user -c "env DISPLAY=:0 startxfce4"'
exit 0
EOF
chmod +x startxfce4_debian.sh
./startxfce4_debian.sh
