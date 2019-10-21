#!/bin/bash

aws ec2 run-instances --image-id ami-04b9e92b5572fa0d1 --count 1 --instance-type t1.micro \
--key-name terry_aws --subnet-id subnet-0db6d512d55cb20c8 --associate-public-ip-address \
>> initial_aws.json

sleep 100

INSTANCE_ID=`jq -r '.Instances[].InstanceId' initial_aws.json`

echo "Instance ID = $INSTANCE_ID"

EC2_IP_ADDRESS=`aws ec2 describe-instances --instance-id $INSTANCE_ID --query 'Reservations[*].Instances[*].PublicIpAddress' --output text`

echo "IP address = $EC2_IP_ADDRESS"

ssh -o StrictHostKeyChecking=no -i "terry_aws.pem" ubuntu@$EC2_IP_ADDRESS -yes << EOF
  sudo apt-get update -y && sudo apt-get install lighttpd -y &&
  sudo su
  echo "<html> <head> <title>HelloWorld</title> </head> <body> <h1>Hello World"'!'"</h1> </body> </html>" > /var/www/html/index.lighttpd.html
  echo "$SERVER["socket"] == ":443" { ssl.engine = "enable" ssl.pemfile = "/etc/lighttpd/certs/terrychallenge.com.pem" } $HTTP["scheme"] == "http" { $HTTP["host"] =~ ".*" { url.redirect = (".*" => "https://%0$0") }}"
  >> /etc/lighttpd/lighttpd.conf
EOF

curl $EC2_IP_ADDRESS | sed 's/<\/*[^>]*>//g'

curl 3.88.18.106 -o results.txt

nmap -oN results.txt --append-output -p 1-500 3.88.18.106

aws elb register-instances-with-load-balancer --load-balancer-name TerryClassicLoadBalancer --instances $INSTANCE_ID

