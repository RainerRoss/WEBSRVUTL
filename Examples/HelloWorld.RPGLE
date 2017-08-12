         ctl-opt dftactgrp(*no) alloc(*teraspace) option(*nodebugio:*nounref)
                 main(main) actgrp('HELLOWORLD') bnddir('WEBSRVUTL');
      //------------------------------------------------------------------//
      //                                                                  //
      // Hello World                                                      //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 08.2017 *                                                 //
      //------------------------------------------------------------------//
      // Prototypen                                                       //
      //------------------------------------------------------------------//

      /include websrvutl/qcpysrc,websrvutl
      /include websrvutl/qcpysrc,apierr

      //------------------------------------------------------------------//
      // Main                                                             //
      //------------------------------------------------------------------//
         dcl-proc main;

         dcl-s   LocHeader   like(GblHeader);         // HTTP-Header
         dcl-s   LocText     varchar(20) ccsid(*utf8);// Text

           LocHeader = getHeader(TEXT);               // Get HTTP-Header
           LocText   = 'Hello World';                 // Text

           wrtStdout(%addr(LocHeader:*data):%len(LocHeader):DsApierr);
           wrtStdout(%addr(LocText:*data):%len(LocText):DsApierr);

         end-proc;
      //------------------------------------------------------------------// 
