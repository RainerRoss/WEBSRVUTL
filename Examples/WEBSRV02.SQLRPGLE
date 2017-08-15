         ctl-opt dftactgrp(*no) alloc(*teraspace) option(*nodebugio:*nounref)
                 actgrp('WEBSRV02') bnddir('WEBSRVUTL');
      //------------------------------------------------------------------//
      //                                                                  //
      // Web Service Customer in XML                                      //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 08.2017 *                                                 //
      //------------------------------------------------------------------//
      // Prototypes                                                       //
      //------------------------------------------------------------------//

      /include websrvutl/qcpysrc,websrvutl
      /include websrvutl/qcpysrc,apierr

      //------------------------------------------------------------------//
      // Arrays                                                           //
      //------------------------------------------------------------------//

         dcl-ds  customer    ext template end-ds;

      //------------------------------------------------------------------//
      // Variables                                                        //
      //------------------------------------------------------------------//

         dcl-s   xmlData     varchar(1000000) ccsid(*utf8);

      //------------------------------------------------------------------//
      // Processing                                                       //
      //------------------------------------------------------------------//

           exec sql set option datfmt=*iso, timfmt=*iso, commit=*none,
                               decmpt=*period, closqlcsr=*endactgrp;

           main();                                    // Main

           *inlr = *on;
      //------------------------------------------------------------------//
      // Main                                                             //
      //------------------------------------------------------------------//
         dcl-proc main;

         dcl-s   LocHeader   like(GblHeader);         // HTTP-Header
         dcl-s   LocId       like(Id);                // Id

           LocHeader = getHeader(XML);                // Get HTTP-Header

           getInput();                                // Get Input

           monitor;
             LocId = %dec(getKeyValue('Id'):10:0);    // Get Id
            on-error;
             LocId = *zero;
           endmon;

           if LocId <> *zero;
              xmlData = crtxml01(LocId);              // Create XML-Data
            else;
              xmlData = crtxml02();                   // Create XML-Data
           endif;

           wrtStdout(%addr(LocHeader:*data):%len(LocHeader):DsApierr);
           wrtStdout(%addr(xmlData:*data):%len(xmlData):DsApierr);

         end-proc;
      //------------------------------------------------------------------//
      // Create XML-Data for one Customer                                 //
      //------------------------------------------------------------------//
         dcl-proc crtxml01 export;
         dcl-pi *n           like(xmlData) rtnparm;
                 piId        like(Id) const;
         end-pi;

         dcl-s   LocClob     SQLType(CLOB:1000000) ccsid(*utf8);
         dcl-s   LocData     like(xmlData);           // Data

           clear LocClob;

           exec sql
             select
              xmlserialize(
               xmlgroup(
                  id                  as "id",
                  trim(name)          as "name",
                  trim(country)       as "country",
                  trim(zip)           as "zip",
                  trim(city)          as "city",
                  trim(street)        as "street",
                  sales               as "sales",
                  credit              as "credit",
                  balance             as "balance",
                  date                as "date"
                  option row "item"
                  root       "data")  as clob(1M)
               including xmldeclaration) as xml_document
               into :LocClob
              from(
               select * from customer
                where Id = :piId
              ) x;

           if sqlcode >= *zero and LocClob_len > *zero;
              LocData = %subst(LocClob_data:1:LocClob_len);
           endif;

           return LocData;                            // Data

         end-proc;
      //------------------------------------------------------------------//
      // Create XML-Data for all Customers                                //
      //------------------------------------------------------------------//
         dcl-proc crtxml02 export;
         dcl-pi *n           like(xmlData) rtnparm;
         end-pi;

         dcl-s   LocClob     SQLType(CLOB:1000000) ccsid(*utf8);
         dcl-s   LocData     like(xmlData);           // Data

           clear LocClob;

           exec sql
             select
              xmlserialize(
               xmlgroup(
                  id                  as "id",
                  trim(name)          as "name",
                  trim(country)       as "country",
                  trim(zip)           as "zip",
                  trim(city)          as "city",
                  trim(street)        as "street",
                  sales               as "sales",
                  credit              as "credit",
                  balance             as "balance",
                  date                as "date"
                  option row "item"
                  root       "data")  as clob(1M)
               including xmldeclaration) as xml_document
               into :LocClob
              from(
               select * from customer
              ) x;

           if sqlcode >= *zero and LocClob_len > *zero;
              LocData = %subst(LocClob_data:1:LocClob_len);
           endif;

           return LocData;                            // Data

         end-proc;
      //------------------------------------------------------------------// 
