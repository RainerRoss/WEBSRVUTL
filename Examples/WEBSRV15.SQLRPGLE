         ctl-opt dftactgrp(*no) alloc(*teraspace) stgmdl(*teraspace)
                 main(main) actgrp('WEBSRV15') bnddir('WEBSRVUTL');
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

         dcl-s   GblJson     SQLType(CLOB:16000000) ccsid(*utf8); // 16 MB

      //------------------------------------------------------------------//
      // Main                                                             //
      //------------------------------------------------------------------//
         dcl-proc main;

           clear GblJson;                             // JSON-Data
           clear DsData;                              // Input-Data

           DsData = parseInput();                     // Parse Input

           crtJson(DsData);                           // Create JSON-Data

           writeStdout(%addr(GblJson_Data):GblJson_Len);

         end-proc;
      //------------------------------------------------------------------//
      // Parse Input                                                      //
      //------------------------------------------------------------------//
         dcl-proc parseInput;
         dcl-pi *n           likeds(PsData) rtnparm;
         end-pi;

         dcl-ds  PsData      likeds(DsData)  inz;
         dcl-ds  PsInput     likeds(WbInput) inz;

         dcl-s   LocJson     sqltype(CLOB:10000) ccsid(*utf8);

           PsInput = getInput(JSON);                  // Get HTTP-Input

           if PsInput.Data_p <> *null and PsInput.DataLen > *zero;
              memcpy(%addr(LocJson_data):PsInput.Data_p:PsInput.DataLen);
              LocJson_len = PsInput.DataLen;

              exec sql
               select x.*
                into :PsData
                from json_table (:LocJson, '$'
                 columns(
                    id    integer  path '$.id' default 0 on empty
                 )
                ) as x;

              sqlcode = sqlcode;                      // Debug
           endif;

           return PsData;

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
             'items' value
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
