         ctl-opt dftactgrp(*no) alloc(*teraspace) option(*nodebugio:*nounref)
                 actgrp('WEBSRV01') bnddir('WEBSRVUTL':'YAJL') decedit('0.');
      //------------------------------------------------------------------//
      //                                                                  //
      // Web Service Customer in JSON                                     //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 08.2017 *                                                 //
      //------------------------------------------------------------------//
      // Files                                                            //
      //------------------------------------------------------------------//

         dcl-f   customer    disk    keyed usage(*input);

      //------------------------------------------------------------------//
      // Prototypes                                                       //
      //------------------------------------------------------------------//

      /include websrvutl/qcpysrc,websrvutl            // Webservice Utilities
      /include websrvutl/qcpysrc,apierr               // API-Error
      /include yajl/qrpglesrc,yajl_h                  // JSON Utilities

      //------------------------------------------------------------------//
      // Table Data                                                       //
      //------------------------------------------------------------------//

         dcl-ds  TbData      qualified;               // DataTable
                  Success    ind inz(*on);            // Success
                  Errmsg     char(80);                // ErrorMessage
         end-ds;

      //------------------------------------------------------------------//
      // Processing                                                       //
      //------------------------------------------------------------------//

           main();                                    // Main

           *inlr = *on;
      //------------------------------------------------------------------//
      // Main                                                             //
      //------------------------------------------------------------------//
         dcl-proc main;

         dcl-s   LocJson_p   pointer;                 // JSON-Pointer
         dcl-s   LocHeader   varchar(256);            // HTTP-Header
         dcl-s   LocLen      uns(10);                 // Length
         dcl-s   LocId       like(id);                // Id

           reset TbData;                              // JSON-Table

           LocHeader = getheader(JSON);               // Get HTTP-Header

           getInput();                                // Get Input

           monitor;
             LocId = %dec(getKeyValue('Id'):10:0);    // Get Id
            on-error;
             LocId = *zero;
           endmon;

           LocLen = crtjson(LocJson_p:LocId);

           wrtStdout(%addr(LocHeader:*data):%len(LocHeader):DsApierr);
           wrtStdout(LocJson_p:LocLen:DsApierr);      // Send HTTP-Data

         end-proc;
      //------------------------------------------------------------------//
      // Procedure JSON-Daten erstellen                                   //
      //------------------------------------------------------------------//
         dcl-proc crtjson export;
         dcl-pi *n           like(LocLen);            // JSON-Length
                 PiJson_p    pointer;                 // JSON-Pointer
                 PiId        like(Id) const;          // Id
         end-pi;

         dcl-s   LocLen      int(10);                 // Data-Length
         dcl-s   LocRc       int(10);                 // ReturnCode
         dcl-s   LocBuf      pointer;                 // Buffer
         dcl-s   LocBuflen   uns(10);                 // Buffer-Length

           dealloc(n) PiJson_p;                       // JSON-Pointer

           yajl_genopen(*on);                         // Pretty-Code

           yajl_beginobj();
           yajl_addbool('success':TbData.Success);
           yajl_addchar('errmsg' :%trim(TbData.Errmsg));

           readCustomer(PiId);                        // Read Customer

           yajl_endobj();

           LocRc = yajl_getBuf(LocBuf:LocBuflen);     // Get JSON Buffer

           if LocBuf <> *null and LocBuflen > *zero;
              PiJson_p = %alloc(LocBuflen * 2);       // Alloc Pointer
              LocRc = yajl_copybuf(1208:PiJson_p:LocBuflen * 2:LocLen);
           endif;

           yajl_genclose();

           return LocLen;                             // JSON-Length

         end-proc;
      //------------------------------------------------------------------//
      // Read Customer                                                    //
      //------------------------------------------------------------------//
         dcl-proc readCustomer;
         dcl-pi *n;
                 PiId        like(Id) const;          // Id
         end-pi;

           yajl_beginarray('items');                  // Items

           select;
            when PiId > *zero;                        // Id > *zero
              chain (PiId) customerr;                 // Read customer
              if %found(customer);
                 crtitem();
              endif;
            other;                                    // Kunde = *zero
              setll *start customer;                   // alle Kunden lesen
              dou %eof(customer);
                read customerr;
                if not %eof(customer);
                   crtitem();
                endif;
              enddo;
           endsl;

           yajl_endarray();

         end-proc;
      //------------------------------------------------------------------//
      // Create Item                                                      //
      //------------------------------------------------------------------//
         dcl-proc crtitem;

           yajl_beginobj();
            yajl_addnum ('id'       :%char(id));
            yajl_addchar('name'     :%trim(name));
            yajl_addchar('country'  :%trim(country));
            yajl_addchar('zip'      :%trim(zip));
            yajl_addchar('city'     :%trim(city));
            yajl_addchar('street'   :%trim(street));
            yajl_addnum ('sales'    :%char(sales));
            yajl_addnum ('credit'   :%char(credit));
            yajl_addnum ('balance'  :%char(balance));
            yajl_addchar('date'     :%char(date));
           yajl_endobj();

         end-proc;
      //------------------------------------------------------------------// 
