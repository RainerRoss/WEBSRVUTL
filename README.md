# WEBSRVUTL
Webservice Utilities running on IBM i for providing Webservices and running Webapplications

## Description

The Library WEBSRVUTL gives RPG-Programmers an easy way to provide webservices powered by IBM i.

ReadyToClickExample providing JSON: www.myhofi.com/myapp/websrv01.pgm?id=1

## How to install

* CRTLIB LIB(WEBSRVUTL) TEXT('Webservice Utilities')
* CRTSRCPF FILE(WEBSRVUTL/QCLPSRC)
* CRTSRCPF FILE(WEBSRVUTL/QCPYSRC)
* CRTSRCPF FILE(WEBSRVUTL/QMODSRC)
* copy the files from github to your SRCPF's
* CRTBNDCL PGM(WEBSRVUTL/WEBSRVUTLC) SRCFILE(WEBSRVUTL/QCLPSRC)
* CALL PGM(WEBSRVUTL/WEBSRVUTLC) this creates the Binding Directory and the Service Program

## Create the HTTP-Server

* Open your browser and start the HTTP-Admin: http://yourIBMip:2001/HTTPAdmin
* Create a new HTTP-Server

Server name:        MYSERVER

Server description: My new Webserver

Server root:        /www/myserver

Document root:      /www/myserver/htdocs

IP address:         All IP addresses


 
