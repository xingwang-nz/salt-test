ec2_server:
  time_zone: Pacific/Auckland
  
  user_accounts:
    xing:
      is_sudo: True

# htpasswd password file location
ht_password:
  password_file: /etc/htpasswd.users

elasticsearch:
  cluster_name: logstash

rsyslog:
  # It specifies how often files are to be polled for new data. The time specified is in seconds
  input_file_poll_interval: 2