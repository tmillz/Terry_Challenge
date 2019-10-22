## Site Reliability Engineering (SRE) challenge

For this project, please think about how you would architect a scalable and secure static web
application in AWS.
* Create and deploy a running instance of a web server using a configuration management
tool of your choice. The web server should serve one page with the following content.

```
<html>
<head>
<title>Hello World</title>
</head>
<body>
<h1>Hello World!</h1>
</body>
</html>
```
* Secure this application and host such that only appropriate ports are publicly exposed and
any http requests are redirected to https. This should be automated using a configuration
management tool of your choice and you should feel free to use a self-signed certificate for
the web server.

* Develop and apply automated tests to validate the correctness of the server configuration.

* Express everything in code.

* Provide your code in a Git repository named <FIRSTNAME>_Challenge on GitHub.com
Be prepared to walk though your code, discuss your thought process, and talk through how you
might monitor and scale this application. You should also be able to demo a running instance of the
host.

## Coding

Please solve the below problem in python or go. You don't need to do the submission on the web
site. Include the program in the repo above.

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
