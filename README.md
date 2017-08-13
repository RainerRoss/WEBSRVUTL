# WEBSRVUTL
Webservice Utilities running on IBM i for providing Webservices and running Webapplications based on AJAX-Requests

## Description

The Library WEBSRVUTL with the Service Program WERSRVUTL gives RPG-Programmers a fast and easy way to provide webservices powered by IBM i

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

Webapplication with AJAX-Request to the JSON-Webservice www.myhofi.com/devhtm/websrv03.html

![capture20170813131922025](https://user-images.githubusercontent.com/10383523/29249116-26fb77dc-802a-11e7-8545-9011d20df3f0.png)

* The AJAX-Request is powered by the JavaScript UI-Library www.webix.com
```
webix.ajax().post("/myapp/websrv01.pgm", {id:0},
   function(text, data) {
   }
);
```

## Software Prerequisites

License Programs

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

* YAJL from Scott Klement (create and parse JSON) - Download [here](http://www.scottklement.com/yajl/)

## How to install

* Create a library  `CRTLIB LIB(WEBSRVUTL) TEXT('Webservice Utilities')`
* Create a source physical file `CRTSRCPF FILE(WEBSRVUTL/QCLPSRC)`
* Create a source physical file `CRTSRCPF FILE(WEBSRVUTL/QCPYSRC)`
* Create a source physical file `CRTSRCPF FILE(WEBSRVUTL/QMODSRC)`
* copy the files from github to your SRCPF's
* Compile the CL-Program `CRTBNDCL PGM(WEBSRVUTL/WEBSRVUTLC) SRCFILE(WEBSRVUTL/QCLPSRC)`
* `CALL PGM(WEBSRVUTL/WEBSRVUTLC)` this creates the Binding Directory and the Service Program

## Start and stop the HTTP-Server ADMIN Instance

* Start HTTP-Admin  `STRTCPSVR SERVER(*HTTP) HTTPSVR(*ADMIN)`
* Stop HTTP-Admin `ENDTCPSVR SERVER(*HTTP) HTTPSVR(*ADMIN)`

## Create a new HTTP-Server Instance `MYSERVER`

* Open your browser and start the HTTP-Admin: http://yourIP:2001/HTTPAdmin
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

 
