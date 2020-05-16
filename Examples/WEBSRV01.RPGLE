         ctl-opt dftactgrp(*no) alloc(*teraspace) option(*nodebugio:*nounref)
                 actgrp('WEBSRV01') bnddir('WEBSRVUTL':'YAJL') decedit('0.');
      //------------------------------------------------------------------//
      //                                                                  //
      // Web Service Customer in JSON                                     //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 05.2020 *                                                 //
      //------------------------------------------------------------------//
      // Files                                                            //
      //------------------------------------------------------------------//

         dcl-f   customer    disk    keyed usage(*input);

      //------------------------------------------------------------------//
      // Prototypes                                                       //
      //------------------------------------------------------------------//

      /include websrvutl/qcpysrc,websrvutl            // Webservice Utilities
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

         dcl-s   LocErrmsg   varchar(500);

         dcl-s   LocId       like(Id);                // Id

           reset TbData;

           getInput();                                // Get Input

           monitor;
             LocId = %dec(getKeyValue('Id'):10:0);    // Get Id
            on-error;
             LocId = *zero;
           endmon;

           yajl_genopen(*on);
            crtjson(LocId);
            yajl_writeStdout(200:LocErrMsg);
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
            yajl_addbool('success':TbData.Success);
            yajl_addchar('errmsg' :%trim(TbData.Errmsg));
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
