         ctl-opt dftactgrp(*no) alloc(*teraspace) option(*nodebugio:*nounref)
                 main(main) actgrp('WEBSRV11') bnddir('WEBSRVUTL');
      //------------------------------------------------------------------//
      //                                                                  //
      // Webservice Customer JSON-Format with JSON_ARRAYAGG               //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 05.2020 *                                                 //
      //------------------------------------------------------------------//
      // Prototypes                                                       //
      //------------------------------------------------------------------//

      /copy websrvutl/qcpysrc,websrvutl
      /copy websrvutl/qcpysrc,sqloptions

      //------------------------------------------------------------------//
      // File Arrays                                                      //
      //------------------------------------------------------------------//

         dcl-ds  DsCustomer  extname('CUSTOMER') qualified alias end-ds;

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

           clear GblJson;                             // JSON-Data
           clear DsData;                              // Input-Data

           getInput();                                // Get Input

           monitor;
             DsData.Id = %dec(getKeyValue('Id'):9:0); // Customer-Id
            on-error;
           endmon;

           if DsData.Id <> *zero;
              crtJson01(DsData);                      // Create JSON-Data
            else;
              crtJson02(DsData);                      // Create JSON-Data
           endif;

           writeStdout(%addr(GblJson_Data):GblJson_Len);

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
             from myapp.customer;

         end-proc;
      //------------------------------------------------------------------// 
