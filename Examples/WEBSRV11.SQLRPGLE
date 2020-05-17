         ctl-opt dftactgrp(*no) alloc(*teraspace) stgmdl(*teraspace)
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
      // Array Status                                                     //
      //------------------------------------------------------------------//

         dcl-ds  DsStatus    qualified;
                  Success    varchar(05) inz('true');
                  ErrorMsg   char(256);
                  ErrorId    uns(10) inz(0);
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

         dcl-s   GblJson     SQLType(CLOB:16000000) ccsid(*utf8); // 16 MB

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

           crtJson(DsData);                           // Create JSON-Data

           writeStdout(%addr(GblJson_Data):GblJson_Len);

         end-proc;
      //------------------------------------------------------------------//
      // Create JSON-Data                                                 //
      //------------------------------------------------------------------//
         dcl-proc crtJson;
         dcl-pi *n;
                 PiData      likeds(DsData) const;
         end-pi;

           exec sql
            select JSON_OBJECT(
             'success'  value trim(:DsStatus.Success) Format JSON,
             'errormsg' value trim(:DsStatus.ErrorMsg),
             'errorid'  value :DsStatus.ErrorId,
             'items'    value
               JSON_ARRAYAGG(
                JSON_OBJECT(
                 'id'      value id,
                 'name'    value trim(name),
                 'country' value trim(country),
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
             from customer
            where Id = Case
                        When :PiData.Id > 0 Then :PiData.Id
                        Else Id
                       End;

         end-proc;
      //------------------------------------------------------------------// 
