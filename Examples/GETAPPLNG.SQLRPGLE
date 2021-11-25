         ctl-opt dftactgrp(*no) alloc(*teraspace) option(*nodebugio:*nounref)
                 main(main) actgrp('GETAPPLNG') bnddir('WEBSRVUTL');
      //------------------------------------------------------------------//
      //                                                                  //
      // Get Application-Languages                                        //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 06.2021 *                                                 //
      //------------------------------------------------------------------//
      // Prototypes                                                       //
      //------------------------------------------------------------------//

      /copy websrvutl/qcpysrc,websrvutl
      /copy websrvutl/qcpysrc,sqloptions

      //------------------------------------------------------------------//
      // Variables                                                        //
      //------------------------------------------------------------------//

         dcl-s   GblJson     SQLType(CLOB:100000) ccsid(*utf8);

      //------------------------------------------------------------------//
      // Main                                                             //
      //------------------------------------------------------------------//
         dcl-proc main;

           crtJson();

           writeStdout(%addr(GblJson_Data):GblJson_Len);

         end-proc;
      //------------------------------------------------------------------//
      // Create JSON-Data                                                 //
      //------------------------------------------------------------------//
         dcl-proc crtJson;

           clear GblJson;                             // JSON-Data

           exec sql
            select JSON_OBJECT(
             'data' value
               JSON_ARRAYAGG(
                JSON_OBJECT(
                  'id'       value Id,
                  'language' value Language
                ) order by Language
               )
             )
              into :GblJson
              from APPLNG00
             where Active = 1;

         end-proc;
      //------------------------------------------------------------------// 
