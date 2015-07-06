#!/bin/bash
#
# tomcat     This shell script takes care of starting and stopping Tomcat
#

export PATH=$JAVA_HOME/bin:$PATH
export TOMCAT_HOME=/usr/local/tomcat
export JAVA_HOME=/usr/lib/jvm/java-7-oracle

if [ -z "$JAVA_OPTS" ]; then
   JAVA_OPTS="-Dfile.encoding=UTF-8 \
  -Dcatalina.logbase=$TOMCAT_HOME/logs \
  -Dnet.sf.ehcache.skipUpdateCheck=true \
  -XX:+DoEscapeAnalysis \
  -XX:+UseConcMarkSweepGC \
  -XX:+CMSClassUnloadingEnabled \
  -XX:+UseParNewGC \
  -XX:MaxPermSize=512m \
  -Xms512m -Xmx1024m"
fi

SHUTDOWN_WAIT=20
 
tomcat_pid() {
  echo `ps aux | grep org.apache.catalina.startup.Bootstrap | grep -v grep | awk '{ print $2 }'`
}
 
start() {
  pid=$(tomcat_pid)
  if [ -n "$pid" ] 
  then
    echo "Tomcat is already running (pid: $pid)"
  else
    # Start tomcat
    echo "Starting tomcat"
    ulimit -n 100000
    umask 003
    sudo -u tomcat /bin/bash $TOMCAT_HOME/bin/startup.sh
  fi
 
 
  return 0
}
 
stop() {
  pid=$(tomcat_pid)
  if [ -n "$pid" ]
  then
    echo "Stoping Tomcat"
    
    sudo -u tomcat /bin/bash $TOMCAT_HOME/bin/shutdown.sh
 
    let kwait=$SHUTDOWN_WAIT
    count=0;
    until [ `ps -p $pid | grep -c $pid` = '0' ] || [ $count -gt $kwait ]
    do
      echo -n -e "\nwaiting for processes to exit";
      sleep 1
      let count=$count+1;
    done
 
    if [ $count -gt $kwait ]; then
      echo -n -e "\nkilling processes which didn't stop after $SHUTDOWN_WAIT seconds\n"
      kill -9 $pid
    else
      echo -n -e "\nTomcat stopped.\n"  
    fi
  else
    echo "Tomcat is not running"
  fi
 
  return 0
}
 
case $1 in
  start)
    start
  ;; 
  stop)   
    stop
  ;; 
  restart)
    stop
    start
  ;;
status)
  pid=$(tomcat_pid)
  if [ -n "$pid" ]
  then
    echo "Tomcat is running with pid: $pid"
  else
    echo "Tomcat is not running"
    exit 1
  fi
;; 
 *)
 echo -n -e "\nUsage: $0 {start|stop|restart|status}\n" 
	exit 1
 ;;
esac    
exit 0
