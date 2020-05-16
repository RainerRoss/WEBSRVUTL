         ctl-opt dftactgrp(*no) alloc(*teraspace) option(*nodebugio:*nounref)
                 main(main) actgrp('WEBSRV02') bnddir('WEBSRVUTL');
      //------------------------------------------------------------------//
      //                                                                  //
      // Webservice Customer in XML-Format                                //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 05.2020 *                                                 //
      //------------------------------------------------------------------//
      // Prototypen                                                       //
      //------------------------------------------------------------------//

      /copy websrvutl/qcpysrc,websrvutl
      /copy websrvutl/qcpysrc,sqloptions

      //------------------------------------------------------------------//
      // Arrays                                                           //
      //------------------------------------------------------------------//

         dcl-ds  customer    ext template end-ds;

      //------------------------------------------------------------------//
      // Variables                                                        //
      //------------------------------------------------------------------//

         dcl-s   GblXml      SQLType(CLOB:1000000) ccsid(*utf8);

      //------------------------------------------------------------------//
      // Main                                                             //
      //------------------------------------------------------------------//
         dcl-proc main;

         dcl-s   LocId       like(Id);                // Id

           getInput();                                // Get Input

           clear GblXml;

           monitor;
             LocId = %dec(getKeyValue('Id'):10:0);    // Get Id
            on-error;
             LocId = *zero;
           endmon;

           crtXml(LocID);                             // Create XML-Data

           writeStdout(%addr(GblXml_Data):GblXml_Len:XML);

         end-proc;
      //------------------------------------------------------------------//
      // Create XML-Data                                                  //
      //------------------------------------------------------------------//
         dcl-proc crtXml;
         dcl-pi *n;
                 PiId        like(Id) const;
         end-pi;

           exec sql
             select
              xmlserialize(
               xmlgroup(
                 id              as "id",
                 trim(name)      as "name",
                 trim(country)   as "country",
                 trim(zip)       as "zip",
                 trim(city)      as "city",
                 trim(street)    as "street",
                 sales           as "sales",
                 credit          as "credit",
                 balance         as "balance",
                 date            as "date"
                 option row         "customer"
                 root               "data"
               ) as clob(1M)
               including xmldeclaration) as xml_document
               into :GblXml
              from(
               select * from customer
                where Id = Case
                            When :PiId > 0 Then :PiId
                            Else Id
                           End
              ) x;

         end-proc;
      //------------------------------------------------------------------// 
