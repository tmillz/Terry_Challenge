## Site Reliability Engineering (SRE) challenge

The challenge is to use the AWS cli to automate the setting up of a website.

## Coding

Solve the below problem in python or go.

https://www.hackerrank.com/challenges/validating-credit-card-number/problem

## My Solution

The launchEC2.sh script uses AWS CLI to launch an ec2 t1.micro Ubuntu 18.04 instance.  The scripts then waits ~ 2 min and performs commands on the instance via SSH. The commands update apt local repo, install lighttpd and configures it.

It uses wget and NMAP to check the configuration.

I set up ports 80, 443, and 22 to be open on my default security group. The self signed a certificate was upload to the instance with scp.

The index.js file is what I uploaded and configured on AWS lambda to watch the website 24x7 and notify me via text message if the it is unavailable.

The Hackerrank challenge code is in the ccValidation.py file which uses the cc.txt file.

## What I learned

I learned how to set up an s3 bucket with Cloud front, how to set up auto scaling ec2 instances, a load balancer, AWS lambda functions, and AWS Lightsail.  

The output of the terminal is in the output.txt file.
