SRE challenge summary. Detailed commands used in actions.sh file

Website is http://terrychallenge.com

Running and configured on AWS Lightsail

Self signed certificate

Cronjob diffs the current lighttpd.conf with the lighttpd.conf.backup every hour and prints changes to /home/ubuntu/checks.txt with time stamp.

AWS Lambda is set up to check the website every 15 min and send an SMS to alert me when the website is offline by following this tutorial [Medium] (http://marcelog.github.io/articles/aws_lambda_check_website_http_online.html).  This has been tested and is working.

HackerRank challenge screenshot and ccValidation.py and cc.txt are in repo along with hackerRank.py which is the code I uploaded for the challenge.
