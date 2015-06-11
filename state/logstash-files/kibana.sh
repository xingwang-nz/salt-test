#!/bin/sh
#
### BEGIN INIT INFO
# Provides:          kibana4
# Required-Start:    $network $remote_fs $named
# Required-Stop:     $network $remote_fs $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Starts kibana4
# Description:       Starts kibana4 using start-stop-daemon
### END INIT INFO

KIBANA_BIN=/usr/local/kibana/bin

PID_FILE=/var/run/$NAME.pid
PATH=/bin:/usr/bin:/sbin:/usr/sbin:$KIBANA_BIN
DAEMON=$KIBANA_BIN/kibana
NAME=kibana
DESC="Kibana"

if [ `id -u` -ne 0 ]; then
	echo "You need root privileges to run this script"
	exit 1
fi

. /lib/lsb/init-functions

if [ -r /etc/default/rcS ]; then
	. /etc/default/rcS
fi

case "$1" in
  start)
	log_daemon_msg "Starting $DESC"

	pid=`pidofproc -p $PID_FILE kibana`
	if [ -n "$pid" ] ; then
		log_begin_msg "Already running."
		log_end_msg 0
		exit 0
	fi

	# Start Daemon
	start-stop-daemon --start --pidfile "$PID_FILE" --make-pidfile --background --exec $DAEMON
	log_end_msg $?
	;;
  stop)
	log_daemon_msg "Stopping $DESC"

	if [ -f "$PID_FILE" ]; then
		start-stop-daemon --stop --pidfile "$PID_FILE" \
			--retry=TERM/20/KILL/5 >/dev/null
		if [ $? -eq 1 ]; then
			log_progress_msg "$DESC is not running but pid file exists, cleaning up"
		elif [ $? -eq 3 ]; then
			PID="`cat $PID_FILE`"
			log_failure_msg "Failed to stop $DESC (pid $PID)"
			exit 1
		fi
		rm -f "$PID_FILE"
	else
		log_progress_msg "(not running)"
	fi
	log_end_msg 0
	;;
  status)
	status_of_proc -p $PID_FILE kibana kibana && exit 0 || exit $?
    ;;
  restart|force-reload)
	if [ -f "$PID_FILE" ]; then
		$0 stop
		sleep 1
	fi
	$0 start
	;;
  *)
	log_success_msg "Usage: $0 {start|stop|restart|force-reload|status}"
	exit 1
	;;
esac

exit 0