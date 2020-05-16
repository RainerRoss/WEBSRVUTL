         ctl-opt dftactgrp(*no) alloc(*teraspace) option(*nodebugio:*nounref)
                 main(main) actgrp('HELLOWORLD') bnddir('WEBSRVUTL');
      //------------------------------------------------------------------//
      //                                                                  //
      // Hello World                                                      //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 05.2020 *                                                 //
      //------------------------------------------------------------------//
      // Prototypes                                                       //
      //------------------------------------------------------------------//

      /include websrvutl/qcpysrc,websrvutl

      //------------------------------------------------------------------//
      // Main                                                             //
      //------------------------------------------------------------------//
         dcl-proc main;

         dcl-s   LocText     varchar(50) ccsid(*utf8);

           LocText = 'Hello IBMi World';

           writeStdout(%addr(LocText:*data):%len(LocText):TEXT);

         end-proc;
      //------------------------------------------------------------------// 
