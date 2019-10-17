# Actions for setting up server
# I used AWS lightsail configuration page to set up an bare Ubuntu 18.04 server that creates automatic snapshots
# Checked ports on networking tab and opened port 443 for Https
# I Also installed/configured AWS Cli and am looking into how to create the same Ubuntu instance via the AWS cli

$ ssh -i LightsailDefaultKey-us-east-2.pem ubuntu@##.###.#.###

$ sudo apt-get update

$ sudo apt-get install lighttpd

$ sudo echo "<html> <head> <title>HelloWorld</title> </head> <body> <h1>Hello World!</h1> </body> </html>" \
  > /var/www/html/index.lighttpd.html

$ sudo mkdir /etc/lighttpd/certs

$ cd /etc/lighttpd/certs

$ sudo openssl req -new -newkey rsa:2048 -nodes -keyout terrychallenge.com.key -out terrychallenge.com.csr

# Entered certificate details

$ sudo openssl x509 -req -days 365 -in terrychallenge.com.csr -signkey terrychallenge.com.key -out terrychallenge.com.crt

$ sudo cat terrychallenge.com.key terrychallenge.com.crt > terrychallenge.com.pem

$ sudo echo "$SERVER["socket"] == ":443" \
  { ssl.engine = "enable" ssl.pemfile = "/etc/lighttpd/certs/terrychallenge.com.pem" } \
  $HTTP["scheme"] == "http" { $HTTP["host"] =~ ".*" { url.redirect = (".*" => "https://%0$0") }}" \
  >> /etc/lighttpd/lighttpd.conf

$ sudo service lighttpd restart

$ sudo cp /etc/lighttpd/lighttpd.conf /lighttpd.conf.backup

$ sudo echo "*  1    * * *   root    { diff /lighttpd.conf.backup /etc/lighttpd/lighttpd.conf ; date ; } >> /home/ubuntu/checks.txt" \
  >> /etc/crontab

$ exit