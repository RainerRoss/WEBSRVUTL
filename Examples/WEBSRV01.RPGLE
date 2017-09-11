         ctl-opt dftactgrp(*no) alloc(*teraspace) option(*nodebugio:*nounref)
                 actgrp('WEBSRV01') bnddir('WEBSRVUTL':'YAJL') decedit('0.');
      //------------------------------------------------------------------//
      //                                                                  //
      // Web Service Customer in JSON                                     //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 09.2017 *                                                 //
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
      // Variables                                                        //
      //------------------------------------------------------------------//

         dcl-s   GblErrmsg   varchar(500);
         dcl-c   GblStatusOk Const(200);

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
         dcl-s   LocId       like(Id);                // Id

           getInput();                                // Get Input

           monitor;
             LocId = %dec(getKeyValue('Id'):10:0);    // Get Id
            on-error;
             LocId = *zero;
           endmon;

           yajl_genopen(*on);
            crtjson(LocId);
            yajl_writeStdout(GblStatusOk:GblErrMsg);
           yajl_genclose();

         end-proc;
      //------------------------------------------------------------------//
      // Create JSON-Data                                                 //
      //------------------------------------------------------------------//
         dcl-proc crtjson;
         dcl-pi *n;
                 PiId        like(Id) const;          // Id
         end-pi;

           yajl_beginobj();
            yajl_addbool('success':*on);
            yajl_addchar('errmsg' :%trim(GblErrMsg));

            yajl_beginarray('items');                 // Items
             readCustomer(PiId);                      // Read Customer
            yajl_endarray();

           yajl_endobj();

         end-proc;
      //------------------------------------------------------------------//
      // Read Customer                                                    //
      //------------------------------------------------------------------//
         dcl-proc readCustomer;
         dcl-pi *n;
                 PiId        like(Id) const;          // Id
         end-pi;

           select;
            when PiId > *zero;                        // Id > *zero
              chain (PiId) customerr;                 // Read one customer
              if %found(customer);
                 crtitem();
              endif;
            other;                                    // Id = *zero
              setll *start customer;                  // Read all customers
              dou %eof(customer);
                read customerr;
                if not %eof(customer);
                   crtitem();
                endif;
              enddo;
           endsl;

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
