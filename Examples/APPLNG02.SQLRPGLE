         ctl-opt dftactgrp(*no) alloc(*teraspace) option(*nodebugio:*nounref)
                 main(main) actgrp('APPLNG') bnddir('WEBSRVUTL');
      //------------------------------------------------------------------//
      //                                                                  //
      // AppLanguage - Insert                                             //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 02.2020 *                                                 //
      //------------------------------------------------------------------//
      // Prototypes                                                       //
      //------------------------------------------------------------------//

      /copy websrvutl/qcpysrc,websrvutl
      /copy websrvutl/qcpysrc,sqloptions

      //------------------------------------------------------------------//
      // Array Files                                                      //
      //------------------------------------------------------------------//

         dcl-ds  DsAppLng    extname('APPLNG00') qualified alias end-ds;

      //------------------------------------------------------------------//
      // Array Input-Data                                                 //
      //------------------------------------------------------------------//

         dcl-ds  DsData      qualified;
                  Id         like(DsAppLng.Id);
                  Language   like(DsAppLng.Language);
         end-ds;

      //------------------------------------------------------------------//
      // Variables                                                        //
      //------------------------------------------------------------------//

         dcl-s   GblJson     SQLType(CLOB:50000) ccsid(*utf8);

      //------------------------------------------------------------------//
      // Array Status                                                     //
      //------------------------------------------------------------------//

         dcl-ds  DsStatus    qualified;
                  Success    varchar(05) inz('true');
                  Errmsg     char(256);
                  ErrorId    uns(10) inz(0);
         end-ds;

      //------------------------------------------------------------------//
      // Main                                                             //
      //------------------------------------------------------------------//
         dcl-proc main;

           reset DsStatus;                            // Status

           DsData  = parseInput();                    // Parse Input

           crtJson(DsData);

           writeStdout(%addr(GblJson_Data):GblJson_Len);

         end-proc;
      //------------------------------------------------------------------//
      // Parse Input                                                      //
      //------------------------------------------------------------------//
         dcl-proc parseInput;
         dcl-pi *n           likeds(PsData)  rtnparm;
         end-pi;

         dcl-ds  PsData      likeds(DsData)  inz;
         dcl-ds  PsInput     likeds(WbInput) inz;

         dcl-s   LocJson     sqltype(CLOB:10000) ccsid(*utf8);

           PsInput = getInput(JSON);                  // Get HTTP-Input

           if PsInput.Data_p <> *null and PsInput.DataLen > *zero;
              memcpy(%addr(LocJson_data):PsInput.Data_p:PsInput.DataLen);
              LocJson_len = PsInput.DataLen;

              exec sql
               select *
                into :PsData
                from json_table (:LocJson, '$'
                 columns(
                  id        int      path '$.id'       default 0  on empty,
                  language  char(02) path '$.language' default '' on empty
                 )
                );
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

           clear GblJson;                             // JSON-Data

           if DsStatus.Errmsg = *blanks;
              insertData(PiData);
            else;
              DsStatus.Success = 'false';
           endif;

           exec sql
            values JSON_OBJECT(
              'success' value trim(:DsStatus.Success) Format JSON,
              'errmsg'  value trim(:DsStatus.Errmsg),
              'errorid' value :DsStatus.ErrorId
            ) into :GblJson;

         end-proc;
      //------------------------------------------------------------------//
      // Insert Data                                                      //
      //------------------------------------------------------------------//
         dcl-proc insertData;
         dcl-pi *n;
                 PiData      likeds(DsData) const;
         end-pi;

           exec sql
            insert into APPLNG00
             (Id, Language, CreateDate, CreateUser)
             values (
              Default, :PiData.Language, current_timestamp, current_user
             )
              with nc;

           if sqlcode < *zero;
              DsStatus.Success = 'false';
              DsStatus.Errmsg  = 'SQL-Error: ' + %char(sqlcode);
           endif;

         end-proc;
      //------------------------------------------------------------------// 
