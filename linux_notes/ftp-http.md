# FTP, HTTP, Apache

### FTP Server Installation

```shell script
yum install vsftpd
/etc/vsftpd/vsftpd.conf  # anonymous_enable=YES
/etc/init.d/vsftpd start
chkconfig vsftpd on  # set vsftpd to start automatically
system-config-firewall-tui  # mark ftp as a trusted service
mkdir /var/ftp/pub/inst/
cp -ar /media/centos6/. /var/ftp/pub/inst/
chcon -R --reference=/var/ftp/pub/ /var/ftp/pub/inst
lftp 192.168.110.3/pub/inst  # test connection to ftp server
```

### HTTP Server Installation

```shell script
yum install httpd
/etc/init.d/httpd start
chkconfig httpd on  # set httpd to start automatically
system-config-firewall-tui  # mark httpd as a trusted service
mkdir /var/www/html/inst
cp -ar /media/centos/. /var/www/html/inst
chcon -R --reference /var/www/html/ /var/www/html/inst
lynx 192.168.110.3/inst  # test connection to the web server
```

### Apache

##### Apache installation
```shell script
yum groupinstall "web server"
chkconfig httpd on
apachectl start

apachectl graceful  # restart or start httpd,  current open connections are not aborted
/etc/init.d/httpd reload  # functionally equivalent to apachectl graceful
apachectl graceful-stop  # stops httpd, current open connections are not aborted
kill -TERM `cat /var/run/httpd/httpd.pid`  # if apachectl stop isn’t working
```

##### Apache configuration
```
/etc/httpd/conf/httpd.conf:
DocumentRoot (specifies location of web pages)
DirectoryIndex (specifies the filename of the web page)
ServerRoot (base location of configuration and logs)
LogFormat (specifies the log format)

/etc/httpd/conf.d/welcome.conf (refers to /var/www/error/)noindex.html
/etc/httpd/conf.d/ssl.conf (Apache ssl config file)

Log directories, these are hardlinked:
/etc/httpd/logs/
/var/log/httpd/
```

### Deploy a simple CGI script

```
Check that the following directives exist in httpd.conf:
LoadModule cgi_module modules/mod_cgi.so
ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"

Uncomment the AddHandler line and add the script’s file extension as follows.
AddHandler cgi-script .cgi .py

Here is a simple three line python script:
#!/usr/bin/python
print "Content-type: text/html\n\n"
print "Hello, World. -python"

chmod -c 755 /var/www/cgi-bin/hello.py
ls -Z /var/www/cgi-bin/hello.py  # should contain httpd_sys_script_exec_t)
<web-server>/cgi-bin/hello.py (url for the script)
<web-server>/manual/howto/cgi.html (apache cgi documentation)
```