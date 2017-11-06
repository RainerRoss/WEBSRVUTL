         ctl-opt dftactgrp(*no) alloc(*teraspace) option(*nodebugio:*nounref)
                 main(main) actgrp('WEBSRVJSON') bnddir('WEBSRVUTL':'YAJL');
      //------------------------------------------------------------------//
      //                                                                  //
      // Webservice JSON-Format                                           //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 11.2017 *                                                 //
      //------------------------------------------------------------------//
      // Prototypes                                                       //
      //------------------------------------------------------------------//

      /include websrvutl/qcpysrc,websrvutl                                     s
      /include websrvutl/qcpysrc,memcpy
      /include websrvutl/qcpysrc,apierr
      /include yajl/qrpglesrc,yajl_h

      //------------------------------------------------------------------//
      // Array Input-Data                                                 //
      //------------------------------------------------------------------//

         dcl-ds  DsData      qualified;
                  Id         int(10);
                  Name       varchar(50);
         end-ds;

      //------------------------------------------------------------------//
      // Table Data                                                       //
      //------------------------------------------------------------------//

         dcl-ds  TbData      qualified;               // DataTable
                  Success    ind inz(*on);            // Success
                  Errmsg     char(80);                // ErrorMessage
         end-ds;

      //------------------------------------------------------------------//
      // Main                                                             //
      //------------------------------------------------------------------//
         dcl-proc main;

         dcl-c   LocStatusOk Const(200);
         dcl-s   LocErrmsg   varchar(500);
         dcl-s   LocJson     sqltype(CLOB:10000) ccsid(*utf8);

         dcl-s   LocContlen  uns(10);                 // ContentLength
         dcl-s   LocAvail    int(10);                 // Available Length
         dcl-s   LocConttype varchar(128);            // ContentType
         dcl-s   LocMethod   varchar(128);            // Request-Method
         dcl-s   LocBuffer_p pointer inz;             // Buffer-Pointer

           exec sql set option datfmt=*iso, timfmt=*iso, commit=*none,
                               closqlcsr=*endactgrp;

           reset TbData;                              // JSON-Table
           clear DsData;                              // Input-Data

           LocMethod  = %str(getenv('REQUEST_METHOD':dsapierr));
           LocContlen = %dec(%str(getenv('CONTENT_LENGTH':DsApierr)):10:0);

           if LocMethod = 'POST' and LocContlen > *zero;
              monitor;
               LocConttype = %str(getenv('CONTENT_TYPE':DsApierr));
               on-error;
              endmon;
              LocBuffer_p = %alloc(LocContlen);
              readStdin(LocBuffer_p:LocContlen:LocAvail:DsApierr);

              if LocAvail > *zero;                    // Bytes available
                if %scan('application/json':LocContType) > *zero;
                   memcpy(%addr(LocJson_data):LocBuffer_p:LocAvail);
                   LocJson_len = LocAvail;
                 endif;
              endif;
           endif;

           if LocJson_len > *zero;
              exec sql
               select x.*
                into :DsData
                from json_table (:LocJson, '$'
                 columns(
                  userid     int          path '$.id',
                  name       varchar(50)  path '$.name'
                 )
                ) as x;
           endif;

           yajl_genopen(*on);
            crtjson();
            yajl_writeStdout(LocStatusOk:LocErrMsg);
           yajl_genclose();

         end-proc;
      //------------------------------------------------------------------//
      // Create JSON-Data                                                 //
      //------------------------------------------------------------------//
         dcl-proc crtJson;

           yajl_beginobj();
            yajl_addbool('success':TbData.Success);
            yajl_addchar('errmsg' :%trim(TbData.Errmsg));
           yajl_endobj();

         end-proc;
      //------------------------------------------------------------------// 
