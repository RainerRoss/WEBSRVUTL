SELECT x.* FROM
	XMLTABLE('data/item' PASSING
	xmlparse(Document SYSTOOLS.HTTPGETCLOB('http://172.16.0.100:8014/myapp/websrv02.pgm?id=1',''))
	COLUMNS
		Id         Integer      path 'id',
		Name       varchar(40)  path 'name',
		Country    varchar(2)   path 'country',
		City       varchar(40)  path 'city',
		Street     varchar(40)  path 'street', 
		Sales      dec(15, 2)   path 'sales',
		Credit     dec(15, 2)   path 'credit',
		Balance    dec(15, 2)   path 'balance',
		Date       varchar(10)  path 'date'

  )
 as x;
