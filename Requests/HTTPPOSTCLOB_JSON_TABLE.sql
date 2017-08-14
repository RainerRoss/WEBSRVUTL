Select x.*
  from JSON_TABLE(
     SYSTOOLS.HTTPPOSTCLOB('http://www.myhofi.com/myapp/websrv01.pgm','','id=1'), 
     '$'
     Columns(
        nested '$.items[*]' columns (
            "Id"        integer        path 'lax $.id',
            "Name"      varchar(40)    path 'lax $.name',
            "Country"   varchar(2)     path 'lax $.country',
            "City"      varchar(40)    path 'lax $.city',
            "Street"    varchar(40)    path 'lax $.street', 
            "Sales"     dec(15, 2)     path 'lax $.sales',
            "Credit"    dec(15, 2)     path 'lax $.credit',
            "Balance"   dec(15, 2)     path 'lax $.balance',
            "Date"      varchar(10)    path 'lax $.date'
        )
    )
  ) x; 
