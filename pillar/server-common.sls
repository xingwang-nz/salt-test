logging_server:
  host: 172.25.115.40
#  host: 192.168.1.75

# the port number of different event inbound endpoints in logstash server
  logstash_port: 4560
  rsyslog_port: 5514
  redis_port: 6379

kibana_server:
  #optional, if not supplied, assume kibana is in the logstash server, thus uses  logging_server:host 
  host: localhost
  port: 5601 