# WEBSRVUTL
Webservice Utilities running on IBM i for providing Webservices and running Webapplications

## Description

The Library WEBSRVUTL gives RPG-Programmers an easy way to provide webservices powered by IBM i.

ReadyToClickExample providing JSON: www.myhofi.com/myapp/websrv01.pgm?id=1

## How to install

* Create a library:  `CRTLIB LIB(WEBSRVUTL) TEXT('Webservice Utilities')`
* Create a source physical file: CRTSRCPF FILE(WEBSRVUTL/QCLPSRC)
* Create a source physical file: CRTSRCPF FILE(WEBSRVUTL/QCPYSRC)
* Create a source physical file: CRTSRCPF FILE(WEBSRVUTL/QMODSRC)
* copy the files from github to your SRCPF's
* CRTBNDCL PGM(WEBSRVUTL/WEBSRVUTLC) SRCFILE(WEBSRVUTL/QCLPSRC)
* CALL PGM(WEBSRVUTL/WEBSRVUTLC) this creates the Binding Directory and the Service Program

## Create the HTTP-Server

* Open your browser and start the HTTP-Admin: http://yourIBMip:2001/HTTPAdmin
* Create a new HTTP-Server
```
Server name:        MYSERVER
Server description: My new Webserver
Server root:        /www/myserver
Document root:      /www/myserver/htdocs
IP address:         All IP addresses
Port:               8010
Log directory:      /www/myserver/logs
Access log file:    access_log
Error log file:     error_log
Log maintenance     7 days
```

 
