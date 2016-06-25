# Platform engineering test

This repository does not include the original problem specification, which is available locally

## Contents

  1. Questions
  2. Assumptions
  3. Stakeholders
  4. Preparation of platform engineer working environemnt
  5. Information gathering
  6. Solution design considerations
  7. Solution documentation 
  8. Solution resources

## 1 Questions

### 1.1 Which operating systems may be used for unprovisioned servers ?

It is stated that unprovisioned servers on which the solution should work will be clean installs, but not which operating system(s).

GB:  Assume Ubuntu for the purpose of the test; I believe we run Ubuntu 12.04 on the Platform Tech Test instances.


### 1.2 How much time do changes take currently ?

The solution should measurably improve delivery time.

GB:  Whilst no specific measure of time is available, assume due to the manually-managed nature of the existing solution that changes take 'days' to implement, and therefore anything shorter than that would be an improvement. 
 
### 1.3 Does the load balancer affect the operation of the Apache web server ?

A simple load balancing approach should not; a more sophisticated approach may involve changes to the requests and responses which will need to be investigated as part of a comprehensive solution defintion.

GB: The load balancer doesn't do anything with the request/response.

### 1.4 Is version control with Subversion a part of the current server management strategy ?

/opt/apache/conf/extra/httpd-vhosts.conf contains information about a Subversion repository

GB: Subversion isn't used at all here; just coincidence.

### 1.5 Is Ansible part of the current server management strategy ?

Ansible binaries are present in /usr/local/bin, and the ubuntu user's home directory contains a .ansible directory

GB: It isn't; all changes to the system are manually implemented by the System Administration team

## 2 Assumptions

**The username ubuntu does not mean that the target operating system is ubuntu.**  

Confirmed that the server is running Ubuntu.  Notes below.

**The load balancer does not affect the operation of the web servers.** 

Confirmed that this is the case by email.

**Amendments of the Apache configuration were conducted within the Apache configuration files.** 

Confirmed that Apache is being used as a proxy for Node.  Notes below.

**The web developers mentioned in the user story are internal staff in the web team mentioned in the background.** 

Solutions available to permanent staff may not be available to contract, freelance or other web developers.

**The platform engineer has a working local environment.** 
  * Git client
  * Active internet connection
  * Supplied credentials file
  * Text editor (Adobe Brackets)
  * Port scanner (nmap)
  * Web browser (Vivaldi)
  * SSH client (OpenSSH)

** Installation of applications required for operation of a state management system is acceptable **

The wget utility will be required to download a Zip archive of this github repository

The unzip utility will be required to uncompress the Zip aarchive

wget and unzip are both available on a clean installation of Ubuntu

The version of Puppet available from the default Ubuntu repositories does not include the module subcommand required to install the PuppetLabs Apache module.  The PuppetLabs release for the target version of Ubuntu will be installed from PuppetLabs repository.

This bootstrapping will be handled by the prepare/setup.sh script in this repository.

## 3 Stakeholders

* Technical test co-ordinator
* Platform engineer
* University of Leodis
* Web development team
* System administration team

## 4 Preparation of platform engineer working environemnt

1 Clone this repository with Git

    [you@local ~]$ mkdir git
    [you@local ~]$ cd git
    [you@local git]$ git clone https://github.com/infinity-technical/platform-engineering.git

2 Store credentials away from the local Git repository

    [you@local ~]$ mv ~/Downloads/Techtest-XXX-XXX.pem ~/.ssh
    [you@local ~]$ chmod 400 ~/.ssh/Techtest-XXX-XXX.pem

3 Set up environment variables

  * ${REMOTE_FQDN} stores the supplied fully qualified domain name for the target server
  * ${REMOTE_IP} stores the supplied fully qualified domain name for the target server
  * ${REMOTE_USERNAME} stores the supplied fully qualified domain name for the target server
  * ${CREDENTIALS} stores the full absolute local path and filename for the supplied credentials file

## 5 Information gathering

Determining the existing server cofiguration will assist in selecting appropriate tools and techniques

### 5.01 Scan open ports on the target machine

A polite port scan of ${REMOTE_FQDN} shows three ports listening

* 22
* 80
* 443

[Full port scan log](./port-scan.md)

### 5.02 Check public DNS information about the website

Use the dig utility to confirm DNS information, particulary that the ANSWER section contains the expected IP address

    [you@local ~] dig ${REMOTE_FQDN}

### 5.03 Review public information about the website

https://netcraft.com provides a summary of the server at ${REMOTE_FQDN}

### 5.04 Browse the website

The web server delivers HTML in response to an HTTP GET request

All pages contain 
  * a site title
  * four navigation links to index pages
  
File format is not specified by extension

A request for a sitemap.xml file gets a text response

    Cannot GET /sitemap.xml
  
Similar responses are received for other files which are unlikely to exist

### 5.05 Connect to target using SSH 

Using supplied credentials file, username and FQDN

    [you@local ~]$ ssh -i ${CREDENTIALS} ${REMOTE_USERNAME}@${REMOTE_FQDN}

During the first access, check the FQDN and IP address before confirming that you wish to continue

### 5.06 Check the user's home

Several of the hidden files may be relevant

    ubuntu@ip-172-31-4-0:~$ ls -lah
    total 32K
    drwxr-xr-x 5 ubuntu ubuntu 4.0K Dec  7 06:12 .
    drwxr-xr-x 3 root   root   4.0K Nov 16  2015 ..
    drwxrwxr-x 3 ubuntu ubuntu 4.0K Dec  7 06:12 .ansible
    -rw-r--r-- 1 ubuntu ubuntu  220 Apr  3  2012 .bash_logout
    -rw-r--r-- 1 ubuntu ubuntu 3.5K Apr  3  2012 .bashrc
    drwx------ 2 ubuntu ubuntu 4.0K Dec  7 06:10 .cache
    -rw-r--r-- 1 ubuntu ubuntu  675 Apr  3  2012 .profile
    drwx------ 2 ubuntu ubuntu 4.0K Dec  7 06:10 .ssh
    -rw-r--r-- 1 ubuntu ubuntu    0 Dec  7 06:10 .sudo_as_admin_successful

The .ansible file may indicate a partial or complete solution in place.  Further information has been requested.

Checked user's .profile, .bashrc for customisation but nothing obvious was found

Checked for scheduled commands for the ubuntu user and the root user

    ubuntu@ip-172-31-4-0:~$ crontab -l
    no crontab for ubuntu

    ubuntu@ip-172-31-4-0:~$ sudo crontab -l
    no crontab for root

### 5.07 Confirm the operating system on the target

The message of the day presented on authentication shows

    Welcome to Ubuntu 12.04.5 LTS (GNU/Linux 3.2.0-94-virtual x86_64)

     * Documentation:  https://help.ubuntu.com/

      System information as of Sat Jun  4 23:49:19 PDT 2016

      System load:  0.0               Processes:           71
      Usage of /:   16.0% of 7.86GB   Users logged in:     0
      Memory usage: 10%               IP address for eth0: 172.31.4.0
      Swap usage:   0%

      Graph this data and manage this system at:
        https://landscape.canonical.com/

      Get cloud support with Ubuntu Advantage Cloud Guest:
        http://www.ubuntu.com/business/services/cloud

    69 packages can be updated.
    56 updates are security updates.

    New release '14.04.3 LTS' available.
    Run 'do-release-upgrade' to upgrade to it.

Uname reports

    ubuntu@ip-172-31-4-0:~$ uname -a
    Linux ip-172-31-4-0 3.2.0-94-virtual #134-Ubuntu SMP Fri Nov 6 19:00:28 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

Checking in /etc, there is a debian_version file

    ubuntu@ip-172-31-4-0:~$ cat /etc/debian_version
    wheezy/sid

and a lsb-release file

    ubuntu@ip-172-31-4-0:~$ cat /etc/lsb-release
    DISTRIB_ID=Ubuntu
    DISTRIB_RELEASE=12.04
    DISTRIB_CODENAME=precise
    DISTRIB_DESCRIPTION="Ubuntu 12.04.5 LTS"

so this is a long term support version of Ubuntu, Precise Pangolin, from 2012

A test machine has been set up with VirtualBox using the Precise Pangolin ISO from Ubuntu to test bootstrapping and develop the state management solution.

### 5.08 Confirm which processes are listening to the open ports

The standards ports for SSH, HTTP & HTTPS were found by the port scan

Apache web server appears in the list of running processes (this is an extract of only the httpd part of the output)

    ubuntu@ip-172-31-4-0:~$ ps auxf
    root       948  0.0  0.2  28264  2372 ?        Ss   Jun02   0:04 /opt/apache/bin/httpd -k start
    root       950  0.0  0.2  28400  2636 ?        S    Jun02   0:00  \_ /opt/apache/bin/httpd -k start
    root       951  0.0  0.2  28400  2636 ?        S    Jun02   0:00  \_ /opt/apache/bin/httpd -k start
    root       952  0.0  0.2  28400  2608 ?        S    Jun02   0:00  \_ /opt/apache/bin/httpd -k start
    root       953  0.0  0.2  28400  2608 ?        S    Jun02   0:00  \_ /opt/apache/bin/httpd -k start
    root       954  0.0  0.2  28400  2608 ?        S    Jun02   0:00  \_ /opt/apache/bin/httpd -k start
    root      1116  0.0  0.2  28400  2604 ?        S    Jun02   0:00  \_ /opt/apache/bin/httpd -k start
    root      3319  0.0  0.2  28400  2596 ?        S    02:14   0:00  \_ /opt/apache/bin/httpd -k start

The Apache web server is running as root so security considerations may need emphasising

An examination of the listening processes on the open ports shows

    ubuntu@ip-172-31-4-0:~$ sudo netstat -plunt
    Active Internet connections (only servers)
    Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
    tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      948/httpd
    tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      743/sshd
    tcp6       0      0 :::22                   :::*                    LISTEN      743/sshd
    tcp6       0      0 :::1337                 :::*                    LISTEN      853/node
    udp        0      0 0.0.0.0:68              0.0.0.0:*                           636/dhclient3

Port 443 was reported as open during the port scan but does not appear in the netstat output

The nodejs server listening on port 1337 is of interest and will be more closely investigated annd this is the point at which I would confer with colleagues if I were working on a client system as there is no reason in the brief to expect this process.

### 5.09 Investigation of plaform context for the Apache web server

/etc/init.d has a link to apachectl to start the webserver

The who command reports the current runlevel as 2

    root@ip-172-31-4-0:/opt/apache# who -r
         run-level 2  2016-06-02 07:18

Apache is installed in /opt, which also contains a web directory.  Both are owned by root but allow group, owner and world permission to read, write and execute

    root@ip-172-31-4-0:/opt/apache# ll /opt
    total 16
    drwxr-xr-x  4 root root 4096 Dec  7 06:14 ./
    drwxr-xr-x 23 root root 4096 Jun  2 07:18 ../
    drwxrwxrwx 15 root root 4096 Dec  7 06:14 apache/
    drwxrwxrwx  3 root root 4096 Dec  7 06:14 web/

as do it's subdirectories

    root@ip-172-31-4-0:/opt/apache# ll /opt/apache
    total 60
    drwxrwxrwx 15 root root 4096 Dec  7 06:14 ./
    drwxr-xr-x  4 root root 4096 Dec  7 06:14 ../
    drwxrwxrwx  2 root root 4096 Dec  7 06:14 bin/
    drwxrwxrwx  2 root root 4096 Dec  7 06:14 build/
    drwxrwxrwx  2 root root 4096 Dec  7 06:14 cgi-bin/
    drwxrwxrwx  3 root root 4096 Dec  7 06:14 conf/
    drwxrwxrwx  3 root root 4096 Dec  7 06:14 error/
    drwxrwxrwx  2 root root 4096 Jan  5  2007 htdocs/
    drwxrwxrwx  3 root root 4096 Dec  7 06:14 icons/
    drwxrwxrwx  2 root root 4096 Dec  7 06:14 include/
    drwxrwxrwx  3 root root 4096 Dec  7 06:14 lib/
    drwxrwxrwx  2 root root 4096 Jun  2 07:18 logs/
    drwxrwxrwx  4 root root 4096 Dec  7 06:14 man/
    drwxrwxrwx 14 root root 4096 Jan  5  2007 manual/
    drwxrwxrwx  2 root root 4096 Dec  7 06:14 modules/

The Apache control interface reports that the configuration syntax is currently acceptable

    root@ip-172-31-4-0:/opt/apache# /opt/apache/bin/apachectl configtest
    Syntax OK

The Apache configuration files seem to be in the expected locations

    root@ip-172-31-4-0:/opt/apache# ll /opt/apache/conf
    total 56
    drwxrwxrwx  3 root root  4096 Dec  7 06:14 ./
    drwxrwxrwx 15 root root  4096 Dec  7 06:14 ../
    drwxrwxrwx  2 root root  4096 Dec  7 06:14 extra/
    -rwxrwxrwx  1 root root 12280 Dec  7 06:14 httpd.conf*
    -rwxrwxrwx  1 root root 12958 Dec  7 06:14 magic*
    -rwxrwxrwx  1 root root 15020 Dec  7 06:14 mime.types*
    
    root@ip-172-31-4-0:/opt/apache# ll /opt/apache/conf/extra/
    total 52
    drwxrwxrwx 2 root root 4096 Dec  7 06:14 ./
    drwxrwxrwx 3 root root 4096 Dec  7 06:14 ../
    -rwxrwxrwx 1 root root 2831 Dec  7 06:14 httpd-autoindex.conf*
    -rwxrwxrwx 1 root root 1654 Dec  7 06:14 httpd-dav.conf*
    -rwxrwxrwx 1 root root 2344 Dec  7 06:14 httpd-default.conf*
    -rwxrwxrwx 1 root root 1103 Dec  7 06:14 httpd-info.conf*
    -rwxrwxrwx 1 root root 5040 Dec  7 06:14 httpd-languages.conf*
    -rwxrwxrwx 1 root root  786 Dec  7 06:14 httpd-manual.conf*
    -rwxrwxrwx 1 root root 3523 Dec  7 06:14 httpd-mpm.conf*
    -rwxrwxrwx 1 root root 2165 Dec  7 06:14 httpd-multilang-errordoc.conf*
    -rwxrwxrwx 1 root root  815 Dec  7 06:14 httpd-userdir.conf*
    -rwxrwxrwx 1 root root 1211 Dec  7 06:14 httpd-vhosts.conf*

The server has sufficient storage capacity, should the decision be taken to compress and archive files

    root@ip-172-31-4-0:/opt/apache# df -hP
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/xvda1      7.9G  1.3G  6.3G  17% /
    udev            494M  8.0K  494M   1% /dev
    tmpfs           100M  208K  100M   1% /run
    none            5.0M     0  5.0M   0% /run/lock
    none            498M     0  498M   0% /run/shm
    
    root@ip-172-31-4-0:/opt/apache# df -hiP
    Filesystem     Inodes IUsed IFree IUse% Mounted on
    /dev/xvda1       512K   68K  445K   14% /
    udev             124K   385  123K    1% /dev
    tmpfs            125K   264  125K    1% /run
    none             125K     3  125K    1% /run/lock
    none             125K     1  125K    1% /run/shm

### 5.10 Investigation of Apache configuration files

/opt/apache/conf/httpd.conf

  * ServerRoot is set to /opt/apache
  * User and group are set to root
  * ServerAdmin directs email to webmasters@leodis.ac.uk
  * DocumentRoot is set to /opt/web/www
  * Directory AllowOverride disables .htaccess configuration for the server root and /opt/web/www
  * Directory Options enables symbolic linking
  * DirectoryIndex is set to index.html
  * ErrorLog is set to logs/error_log
  * CustomLog is set to logs/access_log
  * ScriptAlias is set to /cgi-bin/ "/opt/apache/cgi-bin"
  * DefaultType is set to text/plain
  * AddType is used to define x-compress and x-gzip media types

/opt/apache/conf/extra/httpd-default.conf

    Timeout 300
    KeepAlive On
    MaxKeepAliveRequests 100
    KeepAliveTimeout 5
    UseCanonicalName Off
    AccessFileName .htaccess
    ServerTokens Full
    ServerSignature On
    HostnameLookups Off

/opt/apache/conf/extra/httpd-vhosts.conf seems to be version controlled using Subversion 

    # ID              : $Id: httpd-vhosts.conf 7424 2014-08-23 15:36:27Z svn $
    # Last changed on : $Date: 2014-08-23 16:36:27 +0100 (Mon, 23 Aug 2014) $
    # Last edited by  : $Author: svn $
    # Revision        : $Revision: 7424 $
    # URL Head        : $HeadURL: svn+ssh://svn@srvl1/uni/opt/apache/conf/extra/httpd-vhosts.conf $

VirtualHost and NameVirtualHost are set to listen for requests on port 80 of all interfaces

ProxyPass sets the Apache web server as a gateway for the Node process that listens to port 1337

    <Location />
        ProxyPass http://localhost:1337/
        ProxyPassReverse http://localhost:1337/
    </Location>

### 5.11 Investigate Apache log files

Crontab for the root user does not contain any log management commands

The log files are present and contain the expected information

  * /opt/apache/logs/access_log
  * /opt/apache/logs/error_log shows that Apache is version 2.2.4
  * /opt/apache/logs/httpd.pid

### 5.12 Investigate Apache web content

/opt/apache/web/www contains no files, which is to be expected if it is acting as a gateway to another web server as defined with the ProxyPass and ProxyPassReverse directives

### 5.13 Investigate the Node web server listening on port 1337

Confirm the process id for the node process detected with the process list

    ubuntu@ip-172-31-4-0:/$ pgrep node
    853

Confirm the binary that is running with the node command is issued

    ubuntu@ip-172-31-4-0:/$ which node
    /usr/local/bin/node

Find out which files the node process is using

    ubuntu@ip-172-31-4-0:/$ sudo lsof -p 853
    COMMAND PID USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME
    node    853 root  cwd    DIR  202,1     4096      2 /
    node    853 root  rtd    DIR  202,1     4096      2 /
    node    853 root  txt    REG  202,1 24360255  30756 /usr/local/bin/node
    node    853 root  mem    REG  202,1  1807032 397104 /lib/x86_64-linux-gnu/libc-2.15.so
    node    853 root  mem    REG  202,1   135366 397145 /lib/x86_64-linux-gnu/libpthread-2.15.so
    node    853 root  mem    REG  202,1    88384 397114 /lib/x86_64-linux-gnu/libgcc_s.so.1
    node    853 root  mem    REG  202,1  1030512 397120 /lib/x86_64-linux-gnu/libm-2.15.so
    node    853 root  mem    REG  202,1   962656   7743 /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.16
    node    853 root  mem    REG  202,1    31752 397148 /lib/x86_64-linux-gnu/librt-2.15.so
    node    853 root  mem    REG  202,1    14768 397110 /lib/x86_64-linux-gnu/libdl-2.15.so
    node    853 root  mem    REG  202,1   149280 397095 /lib/x86_64-linux-gnu/ld-2.15.so
    node    853 root    0u   CHR    1,3      0t0   4848 /dev/null
    node    853 root    1u   CHR 136,10      0t0     13 /dev/pts/10
    node    853 root    2u   CHR 136,10      0t0     13 /dev/pts/10
    node    853 root    3r  FIFO    0,8      0t0   7660 pipe
    node    853 root    4w  FIFO    0,8      0t0   7660 pipe
    node    853 root    5u  0000    0,9        0   4823 anon_inode
    node    853 root    6r  FIFO    0,8      0t0   7661 pipe
    node    853 root    7w  FIFO    0,8      0t0   7661 pipe
    node    853 root    8u  0000    0,9        0   4823 anon_inode
    node    853 root    9r   CHR    1,3      0t0   4848 /dev/null
    node    853 root   10u  IPv6   7870      0t0    TCP *:1337 (LISTEN)

Check for a node binary or symbolic link in /usr/local/bin 

    ubuntu@ip-172-31-4-0:/usr/local/bin$ ll /usr/local/bin/
    total 23892
    drwxr-xr-x  2 root root     4096 Dec  7 06:12 ./
    drwxr-xr-x 11 root root     4096 Dec  7 06:12 ../
    -rwxr-xr-x  1 root root     7281 Dec  7 06:12 ansible*
    -rwxr-xr-x  1 root root    11071 Dec  7 06:12 ansible-doc*
    -rwxr-xr-x  1 root root    36094 Dec  7 06:12 ansible-galaxy*
    -rwxr-xr-x  1 root root    13078 Dec  7 06:12 ansible-playbook*
    -rwxr-xr-x  1 root root    10541 Dec  7 06:12 ansible-pull*
    -rwxr-xr-x  1 root root     7791 Dec  7 06:12 ansible-vault*
    -rwxr-xr-x  1 root root 24360255 Dec  7 06:12 node*
    lrwxrwxrwx  1 root root       38 Dec  7 06:12 npm -> ../lib/node_modules/npm/bin/npm-cli.js*

There is also an installation of node in /usr/local/n/versions/node/5.0.0/bin

    ubuntu@ip-172-31-4-0:/usr/local/n/versions/node/5.0.0/bin$ ll
    total 23800
    drwxrwxr-x 2  500  500     4096 Oct 29  2015 ./
    drwxr-xr-x 6 root root     4096 Dec  7 06:12 ../
    -rwxrwxr-x 1  500  500 24360255 Oct 29  2015 node*
    lrwxrwxrwx 1  500  500       38 Oct 29  2015 npm -> ../lib/node_modules/npm/bin/npm-cli.js*

The process list reveals this node process running as root (this is an extract of the output)

    ubuntu@ip-172-31-4-0:/usr/local/bin$ sudo ps aux
    root       853  0.0  2.5 943172 25760 ?        Ssl  Jun02   0:00 node /var/node/leodis/app.js

Examination of the application configuration file /var/node/leodis/app.js confirms that this is the installation of Node serving the web content

    ubuntu@ip-172-31-4-0:/var/node/leodis$ cat app.js
    var express = require('express');
    var hbs = require('express-handlebars');
    var path = require('path');
    var app = express();

    app.engine('hbs', hbs({
      extname:'hbs',
      defaultLayout:'main.hbs',
      layoutsDir: path.join(__dirname, 'views/layouts/')
    }));

    app.set('views', path.join(__dirname, 'views/'));
    app.set('view engine', 'hbs');

    app.get('/', function(req, res) {
      res.render('index');
    });

    app.get('/courses', function(req, res) {
      res.render('courses');
    });

    app.get('/courses/french', function(req, res) {
      res.render('course', { course: 'French' });
    });

    app.get('/courses/computing', function(req, res) {
      res.render('course', { course: 'Computing' });
    });

    app.get('/undergraduate', function(req, res) {
      res.render('undergraduate');
    });

    app.get('/mail', function(req, res) {
      res.render('mail');
    });

    app.get('/vle', function(req, res) {
      res.render('vle');
    });

    var server = app.listen(1337);

The /var/node/leodis/views directory contains the content and /var/node/leodis/views/layouts the generic page layout template

    ubuntu@ip-172-31-4-0:/var/node/leodis$ cat views/index.hbs
    <h1>Homepage</h1>

    <p>
      Ok, If you’ve just joined us, we’re talking about who is the best Lord. Lord of the Rings, of the Dance or of the Flies, that’s tonight’s hot topic. Ok, the votes are closed and clearly the rings and the flies have been roundly trounced by the quick feet of blouse wearing tycoon Michael Flatly. Flatly my dear, I don’t riverdance.
    </p>

    <p>
      All this wine nonsense! You get all these wine people, don't you? Wine this, wine that. Let's have a bit of red, let's have a bit of white. Ooh, that's a snazzy bouquet. Oh, this smells of, I don't know, basil. Sometimes you just want to say, sod all this wine, just give me a pint of, mineral water.
    </p>

    ubuntu@ip-172-31-4-0:/var/node/leodis$ cat views/layouts/main.hbs
    <html>
    <head>
    <title>Platform Tech Test</title>
    </head>
    <body>
      <header>
        <h1>Welcome to the University of Leodis</h1>
        <nav>
          <ul>
            <li><a href="/">Home</a></li>
            <li><a href="/courses">Courses</a></li>
            <li><a href="/mail">Mail</a></li>
            <li><a href="/vle">VLE</a></li>
          </ul>
        </nav>
      </header>

      {{{body}}}
    </body>
    </html>

### 5.14 Map the website

A manual examination of the site provides this initial site map will enable verification of continued functionality of the site during quality assurance

| URL | Content |
| --- | --- |
| ${REMOTE_FQDN}/home | Text |
| ${REMOTE_FQDN}/courses | Links to french and computing |
| ${REMOTE_FQDN}/courses/french | Text |
| ${REMOTE_FQDN}/courses/computing | Text |
| ${REMOTE_FQDN}/mail | Text |
| ${REMOTE_FQDN}/vle | Authentication form to POST to /vle/ with a hidden form element called next set to /admin/ |

## 6 Solution design considerations

Although there are several considerations for the Apache webserver, it is proxying all requests to the Node web server.  The assignment specifies Apache configuration management.  Consider reviewing the option to promote Node to listen directly to port 80 without Apache as a gateway.

### Apache web server

The version of Apache installed is 2.2.4; the most recent release is 2.4.20 and the most recent in the 2.2 series is 2.2.31.  The inclusion of non-public information such as staff email on the a public web server, along with the legacy version of the web server and use of HTTP instead of HTTPS, indicate that a vulnerability scanner (Zed Attack Proxy, BurpSuite or similar OWASP standard) should be used to help identify risks in the web tier and mitigation strategies.

Consider enhancements to the current Apache configuration to implement log management strategies (log rotation, archiving, connecting log location to alternative storage), custom error page functionality and other native features.

### Monitoring and notification

Consider quality assurance measures to demonstrate the continuity of existing functionality.  These may include liaison with staff, compliance with existing practices and integration with existing processes for quality assurance (functionality testing), operational support (monitoring and notification) and change management.  

An agentless solution (Nagios, Icinga or similar) provisioned in the target network would mean fewest changes to the target server.  Installing an agent has it's own risks and maintenance overhead, but improves the quality of information in the monitoring system.
I have selected an agent-based, externally hosted solution from DataDog to provide a balance between monitoring quality and solution footprint that integrates quickly with Ubuntu, Apache and Github.

### State management systems

State management systems that provide a mechanism for managing Apache httpd include 
* [Puppet](https://github.com/puppetlabs/puppetlabs-apache)
* [Chef](https://github.com/chef-cookbooks/httpd)
* [Ansible](https://github.com/geerlingguy/ansible-role-apache)
* [Saltstack](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.apache.html)

Of these, Puppet is preferred as the Apache httpd module can scale from managing a single machine to many, has a small installation footprint, requires no extra infrastructure, is actively supported by Puppet Labs and many contributors.  PuppetLabs Forge contains a module for management of the Apache web server.  The quality of Puppet modules from the PuppetLabs Forge is as variable as can be expected from public contributions.  The Apache module is provided and maintained by PuppetLabs and can be considered suitable for this assignment.

Puppet commonly utilises one or more Puppet Masters to manage the state of a number of slave machines.  FOr the purposes of this exercise, Puppet will be run on the target machien and no Puppet Master will be required.

Chef is of comparable maturity and sophistication to Puppet but introduces a requirement for an extra machine to manage a master, which manages the web server state.  The provision of additional infrastructure would introduce complexity to the solution. 

Ansible similarly requires a master server and uses SSH to manage the web server state.

Saltstack similarly uses SSH to connect to web servers but installation of agents to managed servers is preferred.  Minimising the footprint of the solution is preferred.

## 7 Solution documentation

Bootstrapping will take the form of running a provided Bash script to check for and if necessary install required utilities, a version of Puppet that provides the modules subcommand, the PuppetLabs Apache module and manifests (along with any Puppet files, Puppet templates and Hiera data) to manage the system state.

Consideration will be given to ensuring that Puppet regularly performs any state correction required.

### 7.1 Identifying flaws in the current Apache web server configuration

An initial scan with [Zed Attack Proxy](https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project) reported [several risks](zap-report.html)

A more thorough scan with [Nikto](https://github.com/sullo/nikto) reported [several risks](nikto-report.txt)

A scan of the Node server with [NodeJsScan](https://github.com/ajinabraham/NodeJsScan) was outside the scope of this assignment. 

### 7.2 Preparing web servers for state management

    ubuntu@target ~ $ wget https://raw.githubusercontent.com/infinity-technical/platform-engineering/master/prepare/setup.sh
    ubuntu@target ~ $ bash setup.sh

### 7.3 Managing web servers with Puppet

## 8 Solution resources

Code, examples and other non-documentary information will be published here
