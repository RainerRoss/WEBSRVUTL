# WEBSRVUTL
Webservice Utilities running on IBM i for providing Webservices and running Webapplications

## Description

The Library WEBSRVUTL with der Service Programm WERSRVUTL gives RPG-Programmers an easy way to provide webservices powered by IBM i.

## ReadyToClickExamples

Providing JSON www.myhofi.com/myapp/websrv02.pgm?id=1
```
{
    "success": true,
    "errmsg": "",
    "items": [
        {
            "id": 1,
            "name": "MINERALÖL-TANKSTELLE",
            "country": "DE",
            "zip": "12559",
            "city": "BERLIN",
            "street": "GOETHESTR. 8",
            "sales": 535647.59,
            "credit": 5000.00,
            "balance": 1650.00,
            "date": "2015-02-06"
        }
    ]
}
```

Providing XML www.myhofi.com/myapp/websrv01.pgm?id=1
```
<data>
	<item>
		<id>1</id>
		<name>MINERALÖL-TANKSTELLE</name>
		<country>DE</country>
		<zip>12559</zip>
		<city>BERLIN</city>
		<street>GOETHESTR. 8</street>
		<sales>535647.59</sales>
		<credit>5000.00</credit>
		<balance>1650.00</balance>
		<date>2015-02-06</date>
	</item>
</data>
```

## Software Prerequisites

License Programs:

* 5770SS1 Option 3 – Extended Base Directory Support
* 5770SS1 Option 12 – Host Servers
* 5770SS1 Option 30 – Qshell
* 5770SS1 Option 33 – PASE
* 5770SS1 Option 34 – Digital Certificate Manager
* 5770SS1 Option 39 – Components for Unicode
* 5770TC1 - TCP/IP	
* 5770JV1 - Java
* 5770DG1 – HTTP-Server: Apache 2.4.12

Non-License Software (open source)

* YAJL from Scott Klement (create and parse JSON) Download [here](http://www.scottklement.com/yajl/)

## How to install

* Create a library  `CRTLIB LIB(WEBSRVUTL) TEXT('Webservice Utilities')`
* Create a source physical file `CRTSRCPF FILE(WEBSRVUTL/QCLPSRC)`
* Create a source physical file `CRTSRCPF FILE(WEBSRVUTL/QCPYSRC)`
* Create a source physical file `CRTSRCPF FILE(WEBSRVUTL/QMODSRC)`
* copy the files from github to your SRCPF's
* Compile the CL-Program `CRTBNDCL PGM(WEBSRVUTL/WEBSRVUTLC) SRCFILE(WEBSRVUTL/QCLPSRC)`
* `CALL PGM(WEBSRVUTL/WEBSRVUTLC)` this creates the Binding Directory and the Service Program

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

 
