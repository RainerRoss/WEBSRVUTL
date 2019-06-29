         ctl-opt dftactgrp(*no) alloc(*teraspace) option(*nodebugio:*nounref)
                 main(main) actgrp('WEBSRV15') bnddir('WEBSRVUTL');
      //------------------------------------------------------------------//
      //                                                                  //
      // Webservice Customer JSON-Format with JSON_ARRAYAGG               //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 07.2019 *                                                 //
      //------------------------------------------------------------------//
      // Prototypes                                                       //
      //------------------------------------------------------------------//

      /include websrvutl/qcpysrc,websrvutl
      /include websrvutl/qcpysrc,apierr
      /include websrvutl/qcpysrc,memcpy
      /copy websrvutl/qcpysrc,sqloptions

      //------------------------------------------------------------------//
      // File Arrays                                                      //
      //------------------------------------------------------------------//

         dcl-ds  DsCustomer  extname('CUSTOMER') qualified alias end-ds;

      //------------------------------------------------------------------//
      // Array Input from HTTP-Server                                     //
      //------------------------------------------------------------------//

         dcl-ds  DsInput     qualified inz;           // Array Input
                  Data_p     pointer;                 // Data-Pointer
                  DataLen    int(10);                 // Data-Length
                  UTF8       ind;                     // UTF8 *on/*off
                  Method     varchar(128);            // Request-Method
                  ContType   varchar(128);            // Content-Type
                  AuthType   varchar(256);            // Authorization-Type
                  RmtUser    varchar(256);            // Remote-User
         end-ds;

      //------------------------------------------------------------------//
      // Array Input-Data                                                 //
      //------------------------------------------------------------------//

         dcl-ds  DsData      qualified;
                  Id         like(DsCustomer.Id);
         end-ds;

      //------------------------------------------------------------------//
      // Variables                                                        //
      //------------------------------------------------------------------//

         dcl-s   GblJson     SQLType(CLOB:1000000) ccsid(*utf8);

      //------------------------------------------------------------------//
      // Main                                                             //
      //------------------------------------------------------------------//
         dcl-proc main;

         dcl-s   LocHeader   like(GblHeader);         // HTTP-Header

           LocHeader = getHeader();                   // Get HTTP-Header

           clear GblJson;                             // JSON-Data
           clear DsData;                              // Input-Data

           DsInput = getJSONInput();                  // Get JSON Input

           if DsInput.Data_p <> *null and DsInput.DataLen > *zero;
              parseJSON(DsInput);                     // Parse JSON
           endif;

           if DsData.Id <> *zero;
              crtJson01(DsData);                      // Create JSON-Data
            else;
              crtJson02();                            // Create JSON-Data
           endif;

           wrtStdout(%addr(LocHeader:*data):%len(LocHeader):DsApierr);

           if GblJson_Len > *zero;
              wrtStdout(%addr(GblJson_Data):GblJson_Len:DsApierr);
           endif;

         end-proc;
      //------------------------------------------------------------------//
      // Create JSON-Data - one Customer                                  //
      //------------------------------------------------------------------//
         dcl-proc crtJson01;
         dcl-pi *n;
                 PiData      likeds(DsData) const;
         end-pi;

           exec sql
            select JSON_OBJECT(
             'items' value
               JSON_ARRAYAGG(
                JSON_OBJECT(
                 'id'      value id,
                 'country' value trim(country),
                 'name'    value trim(name),
                 'zip'     value trim(zip),
                 'city'    value trim(city),
                 'street'  value trim(street),
                 'sales'   value sales,
                 'credit'  value credit,
                 'balance' value balance,
                 'date'    value date
                )
               )
             )
               into :GblJson
             from myapp.customer
            where Id = :DsData.Id;

         end-proc;
      //------------------------------------------------------------------//
      // Create JSON-Data - all Customers                                 //
      //------------------------------------------------------------------//
         dcl-proc crtJson02;

           exec sql
            select JSON_OBJECT(
             'items' value
               JSON_ARRAYAGG(
                JSON_OBJECT(
                 'id'      value id,
                 'country' value trim(country),
                 'name'    value trim(name),
                 'zip'     value trim(zip),
                 'city'    value trim(city),
                 'street'  value trim(street),
                 'sales'   value sales,
                 'credit'  value credit,
                 'balance' value balance,
                 'date'    value date
                )
               )
             )
               into :GblJson
             from myapp.customer;

         end-proc;
      //------------------------------------------------------------------//
      // Get JSON Input from HTTP-Server                                  //
      //------------------------------------------------------------------//
         dcl-proc getJSONInput export;
         dcl-pi *n           likeds(DsInput) rtnparm; // Array Input

         end-pi;

         dcl-ds  PsInput     likeds(DsInput) inz;     // Array Input
         dcl-s   LocContlen  int(10);                 // ContentLength

           PsInput.Method = %str(getenv('REQUEST_METHOD':DsApierr));
           LocContlen     = %dec(%str(getenv('CONTENT_LENGTH':DsApierr)):10:0);

           PsInput.Datalen = LocContlen;

           monitor;
             PsInput.ContType = %str(getenv('CONTENT_TYPE':DsApierr));
            on-error;
           endmon;

           if PsInput.Method = 'POST' and LocContlen > *zero and
              PsInput.ContType <> *blanks;
              if %scan('application/json':PsInput.ContType) > *zero or
                 %scan('application/xml' :PsInput.ContType) > *zero;
                 PsInput.UTF8   = *on;                // UTF8-Data
                 PsInput.Data_p = %alloc(LocContlen);
                 readStdin(PsInput.Data_p:LocContlen:LocContlen:DsApierr);
              endif;
           endif;

           monitor;                                   // Authorization-Type
             PsInput.AuthType = %str(getenv('AUTH_TYPE':DsApierr));
            on-error;
           endmon;

           monitor;                                   // Remote-User
             PsInput.RmtUser  = %str(getenv('REMOTE_USER':DsApierr));
            on-error;
           endmon;

           return PsInput;

         end-proc;
      //------------------------------------------------------------------//
      // Parse JSON-Data                                                  //
      //------------------------------------------------------------------//
         dcl-proc parseJSON;
         dcl-pi  *n;
                 PiInput     likeds(DsInput) const;
         end-pi;

         dcl-s   LocJson     sqltype(CLOB:10000) ccsid(*utf8);
         dcl-s   LocId       int(10);

           memcpy(%addr(LocJson_data):PiInput.Data_p:PiInput.DataLen);

           LocJson_len = PiInput.DataLen;

           exec sql
            select id
             into :DsData.Id
             from json_table (:LocJson, '$'
              columns(
                 id      integer       path '$.id'
              )
             );

           sqlcode = sqlcode;                         // for Debug

         end-proc;
      //------------------------------------------------------------------// 
