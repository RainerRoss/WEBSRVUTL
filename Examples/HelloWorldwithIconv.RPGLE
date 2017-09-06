         ctl-opt dftactgrp(*no) alloc(*teraspace) option(*nodebugio:*nounref)
                 main(main) actgrp('HELLOWORLD') bnddir('WEBSRVUTL');
      //------------------------------------------------------------------//
      //                                                                  //
      // Hello World with iconv                                           //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 08.2017 *                                                 //
      //------------------------------------------------------------------//
      // Prototypes                                                       //
      //------------------------------------------------------------------//

      /include websrvutl/qcpysrc,websrvutl
      /include websrvutl/qcpysrc,iconv
      /include websrvutl/qcpysrc,apierr

      //------------------------------------------------------------------//
      // Main                                                             //
      //------------------------------------------------------------------//
         dcl-proc main;

         dcl-s   LocHeader   like(GblHeader);         // HTTP-Header
         dcl-s   LocText     varchar(20);             // Text

           LocHeader = getHeader(TEXT);               // Get HTTP-Header
           LocText   = 'Hello World';                 // Text

      // Determine your Source CCSID US = 37, DE = 1141

           LocText = cvtData(%addr(LocText:*data):%len(LocText):1208:37);

           wrtStdout(%addr(LocHeader:*data):%len(LocHeader):DsApierr);
           wrtStdout(%addr(LocText:*data):%len(LocText):DsApierr);

         end-proc;
      //------------------------------------------------------------------//
      // Convert Data between CCSID's                                     //
      //------------------------------------------------------------------//
         dcl-proc cvtData;
         dcl-pi *n           varchar(10000) rtnparm;  // Result
                 piSrc_p     pointer const;           // Source-Pointer
                 piLength    uns(10) const;           // Length
                 piTrgCcsid  uns(10) const;           // Target-CCSID
                 piSrcCcsid  uns(10) const;           // Source-CCSID
         end-pi;

         dcl-s   LocTarget   char(1000000);           // Target
         dcl-s   LocTrg_p    pointer inz(%addr(LocTarget));
         dcl-s   LocTrglen   uns(10) inz(%size(LocTarget));


           dssrcccsid.tq_ccsid = piSrcCcsid;          // Source-CCSID
           dstrgccsid.tq_ccsid = piTrgccsid;          // Target-CCSID
           dsconv              = *allx'00';

           DsConv = iconv_open(DsTrgccsid:DsSrcccsid);        // Open
           iconv(DsConv:piSrc_p:piLength:LocTrg_p:LocTrglen); // Convert
           iconv_close(DsConv);                               // Close

           return %subst(LocTarget:1:%size(LocTarget) - LocTrglen);

         end-proc;
      //------------------------------------------------------------------// 
