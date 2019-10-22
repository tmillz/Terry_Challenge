#!/bin/bash

aws ec2 run-instances --image-id ami-04b9e92b5572fa0d1 --count 1 --instance-type t1.micro \
--key-name terry_aws --subnet-id subnet-0db6d512d55cb20c8 --associate-public-ip-address \
>> initial_aws.json

sleep 200

INSTANCE_ID=`jq -r '.Instances[].InstanceId' initial_aws.json`

printf "\n\nInstance ID = $INSTANCE_ID\n\n"

EC2_IP_ADDRESS=`aws ec2 describe-instances --instance-id $INSTANCE_ID --query 'Reservations[*].Instances[*].PublicIpAddress' --output text`

printf "IP address = $EC2_IP_ADDRESS\n\n"

ssh -o StrictHostKeyChecking=no -i "~/.ssh/terry_aws.pem" ubuntu@"$EC2_IP_ADDRESS" -yes << EOF
  sudo apt-get update -y && sudo apt-get install lighttpd -y
  sudo su
  mkdir /etc/lighttpd/certs
  echo "<html> <head> <title>HelloWorld</title> </head> <body> <h1>Hello World"'!'"</h1> </body> </html>" > /var/www/html/index.lighttpd.html
EOF

scp -i "~/.ssh/terry_aws.pem" terrychallenge.com.pem  ubuntu@"$EC2_IP_ADDRESS":/home/ubuntu/terrychallenge.com.pem
scp -i "~/.ssh/terry_aws.pem" terrychallenge.com.pem  ubuntu@"$EC2_IP_ADDRESS":/home/ubuntu/terrychallenge.com.crt
scp -i "~/.ssh/terry_aws.pem" terrychallenge.com.pem  ubuntu@"$EC2_IP_ADDRESS":/home/ubuntu/terrychallenge.com.csr
scp -i "~/.ssh/terry_aws.pem" lighttpd.conf  ubuntu@"$EC2_IP_ADDRESS":/home/ubuntu/lighttpd.conf

ssh -o StrictHostKeyChecking=no -i "~/.ssh/terry_aws.pem" ubuntu@"$EC2_IP_ADDRESS" -yes << EOF
  sudo mv terrychallenge.com.pem /etc/lighttpd/certs
  sudo mv terrychallenge.com.crt /etc/lighttpd/certs
  sudo mv terrychallenge.com.csr /etc/lighttpd/certs
  sudo su
  sudo mv -f lighttpd.conf /etc/lighttpd
  sudo service lighttpd restart
EOF

sleep 20

wget -O index.html --no-check-certificate --ca-certificate=terrychallenge.com.pem $EC2_IP_ADDRESS

cat index.html > results.txt

nmap -oN results.txt --append-output -p 1-500 $EC2_IP_ADDRESS

DIFF1=$(diff <(head -n 1 results.txt) <(head -n 1 base.txt))

if [ "$DIFF1" != "" ]
then 
  printf "\n\nERROR website html does not match or website does not exist\n\n"
  rm initial_aws.json
  exit 1;
fi

printf "\n\nwebpage looks good!\n\n"

DIFF2=$(diff <(head -n 10 results.txt | tail -n $((10-5+1))) <(head -n 10 base.txt | tail -n $((10-5+1))))

if [ "$DIFF2" != "" ]
then 
  printf "\n\nERROR something is wrong with your port scan\n\n"
  rm initial_aws.json
  exit 1;
fi

printf "\n\nports look good!\n\n"

rm initial_aws.json
