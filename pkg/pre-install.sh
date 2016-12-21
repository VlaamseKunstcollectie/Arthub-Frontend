/usr/bin/getent group blacklight || /usr/sbin/groupadd -r blacklight
/usr/bin/getent passwd blacklight || /usr/sbin/useradd -r -d /opt/blacklight -s /sbin/nologin blacklight -g blacklight
