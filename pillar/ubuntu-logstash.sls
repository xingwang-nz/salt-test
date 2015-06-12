ec2_server:
  time_zone: Pacific/Auckland
  
  user_accounts:
    xing:
      is_sudo: True

redis_bind_ip: 172.25.115.40 

# htpasswd password file location
ht_password:
  password_file: /etc/htpasswd.users
        