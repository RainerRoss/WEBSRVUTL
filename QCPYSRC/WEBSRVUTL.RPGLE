      //------------------------------------------------------------------//
      // QtmhRdStin - Read Standard Input from HTTP-Server                //
      //------------------------------------------------------------------//

         dcl-pr readStdIn    extproc('QtmhRdStin');
                 PiData      pointer        value;
                 PiDatalen   int(10)        const;
                 PiAvail     int(10)        const;
                 PiError     like(DsApierr) const;
         end-pr;

      //------------------------------------------------------------------//
      // QtmhWrStout - Write Standard Output to HTTP-Server               //
      //------------------------------------------------------------------//

         dcl-pr wrtStdOut    extproc('QtmhWrStout');
                 PiData      pointer        value;
                 PiDatalen   int(10)        const;
                 PiError     like(DsApierr) const;
         end-pr;

      //------------------------------------------------------------------//
      // Get Environment from HTTP-Server                                 //
      //------------------------------------------------------------------//

         dcl-pr getenv       pointer        extproc(*dclcase);
                 PiEnvvar    pointer        value options(*string);
                 PiError     like(DsApierr) const options(*nopass);
         end-pr;

      //------------------------------------------------------------------//
      // Get Input from HTTP-Server - Type JSON/XML/TEXT                  //
      //------------------------------------------------------------------//

         dcl-pr getInput     likeds(WbInput);
                 PiType      uns(03) const options(*nopass);// JSON/XML/TEXT
         end-pr;

      //------------------------------------------------------------------//
      // Write Standard Output to HTTP-Server                             //
      //------------------------------------------------------------------//

         dcl-pr writeStdOut;
                 PiData_p    pointer const;
                 PiLength    int(10) const;
                 PiType      uns(03) const options(*nopass);
         end-pr;

      //------------------------------------------------------------------//
      // GetKeyValue                                                      //
      //------------------------------------------------------------------//

         dcl-pr getKeyValue  like(GblQrystr) rtnparm;
                 PiKey       like(GblKey)    const options(*varsize);
         end-pr;

      //------------------------------------------------------------------//
      // Get HTTP-Header - Type JSON/XML/TEXT                             //
      //------------------------------------------------------------------//

         dcl-pr getHeader    like(GblHeader);
                 PiType      uns(3) const options(*nopass);
         end-pr;

      //------------------------------------------------------------------//
      // MemCopy                                                          //
      //------------------------------------------------------------------//

         dcl-pr memcpy       extproc(*dclcase);
                 target      pointer value;
                 source      pointer value;
                 length      uns(10) value;
         end-pr;

      //------------------------------------------------------------------//
      // BASE64 - Encode String - SRVPGM(QSYSDIR/QAXIS10HT)               //
      //------------------------------------------------------------------//

         dcl-pr encBase64Bin int(10) extproc('apr_base64_encode_binary');
                 PiEnc_p     pointer value;           // Encoded-Pointer
                 PiSrc_p     pointer value;           // Source-Pointer
                 PiSrclen    int(10) value;           // Source-Length
         end-pr;

      //------------------------------------------------------------------//
      // BASE64 - Decode String - SRVPGM(QSYSDIR/QAXIS10HT)               //
      //------------------------------------------------------------------//

         dcl-pr decBase64Bin int(10) extproc('apr_base64_decode_binary');
                 PiDec_p     pointer value;           // Decoded-Pointer
                 PiEnc_p     pointer value;           // Encoded-Pointer
         end-pr;

      //------------------------------------------------------------------//
      // Encode Data to BASE64                                            //
      //------------------------------------------------------------------//

         dcl-pr encBase64    varchar(100000) rtnparm; // Encoded String
                 PiString_p  pointer const;           // String Pointer
                 PiLength    int(10) const;           // String Length
         end-pr;

      //------------------------------------------------------------------//
      // Array Key Values from Query-String                               //
      //------------------------------------------------------------------//

         dcl-s   WbKeyCount  uns(10);

         dcl-ds  WbKeyVal    qualified dim(1000) inz;
                  Key        like(GblKey);
                  Value      pointer;
                  Length     uns(10);
         end-ds;

         dcl-s   GblKey      varchar(128);            // Key

      //------------------------------------------------------------------//
      // Array Input from HTTP-Server                                     //
      //------------------------------------------------------------------//

         dcl-ds  WbInput     qualified inz;           // Array Input
                  Data_p     pointer;                 // Data-Pointer
                  DataLen    int(10);                 // Data-Length
                  UTF8       ind;                     // UTF8 *on/*off
                  Method     like(GblMethod);         // Request-Method
                  ContType   like(GblContType);       // Content-Type
                  AuthType   like(GblAuthType);       // Authorization-Type
                  RmtUser    like(GblRmtUser);        // Remote-User
         end-ds;

      //------------------------------------------------------------------//
      // Array API-Error                                                  //
      //------------------------------------------------------------------//

         dcl-ds  DsApierr    qualified inz;                // API-Error
                  BytesProv  int(10) inz(%size(DsApierr)); // Bytes Provided
                  BytesAvail int(10);                      // Bytes Avail
                  MsgId      char(07);                     // ErrorMessageId
                  *n         char(01);
                  ErrData    char(256);                    // ErrorData
         end-ds;

      //------------------------------------------------------------------//
      // Constants                                                        //
      //------------------------------------------------------------------//

         dcl-c   CRLF        x'0D25';                 // CRLF

         dcl-c   JSON        1;                       // JSON
         dcl-c   XML         2;                       // XML
         dcl-c   TEXT        3;                       // TEXT

         dcl-c   Lower       1;                       // Lower
         dcl-c   Upper       0;                       // Upper

      //------------------------------------------------------------------//
      // Variables                                                        //
      //------------------------------------------------------------------//

         dcl-s   GblQrystr   varchar(1000000);        // Query-String
         dcl-s   GblHeader   varchar(256);            // HTTP-Header
         dcl-s   GblMethod   varchar(20);             // Request-Method
         dcl-s   GblContType varchar(128);            // Content-Type
         dcl-s   GblAuthType varchar(128);            // Authorization-Type
         dcl-s   GblRmtUser  varchar(128);            // Remote-User

      //------------------------------------------------------------------// 
