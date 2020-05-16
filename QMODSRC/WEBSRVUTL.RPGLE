         ctl-opt nomain alloc(*teraspace);
      //------------------------------------------------------------------//
      //                                                                  //
      // Webservice Utilities V1.5                                        //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 05.2020 *                                                 //
      //------------------------------------------------------------------//
      // Prototypes                                                       //
      //------------------------------------------------------------------//

      /include websrvutl/qcpysrc,websrvutl

      //------------------------------------------------------------------//
      // Get Input from HTTP-Server                                       //
      //------------------------------------------------------------------//
         dcl-proc getInput export;
         dcl-pi *n           likeds(WbInput);         // Array Input
                 PiType      like(LocType) const options(*nopass);
         end-pi;

         dcl-ds  PsInput     likeds(WbInput) inz;     // Array Input

         dcl-s   LocType     uns(3);                  // Type JSON/XML/Text
         dcl-s   LocQrystr   like(GblQrystr);         // Query-String
         dcl-s   LocMethod   varchar(20);             // Request-Method
         dcl-s   LocContType like(GblContType);       // Content-Type
         dcl-s   LocContlen  int(10);                 // Content-Length
         dcl-s   LocBuffer_p pointer;                 // Buffer-Pointer
         dcl-s   LocAvail    int(10);                 // Available Length

           clear WbKeyVal;                            // Array KeyValues
           clear WbKeyCount;                          // Key-Counter

           LocMethod  = %str(getenv('REQUEST_METHOD':DsApierr));
           LocContlen = %int(%str(getenv('CONTENT_LENGTH':DsApierr)));

           PsInput.Method = LocMethod;                // Request-Method

           monitor;                                   // Content-Type
             LocContType = %str(getenv('CONTENT_TYPE':DsApierr));
             if LocContType <> *blanks;
                cvtstr(%addr(LocContType:*data):%len(LocContType):lower);
                PsInput.ContType = LocContType;
             endif;
            on-error;
           endmon;

           if %parms = *zero;                         // no Parameter = TEXT
              LocType = TEXT;                         // Default Type TEXT
            else;
              LocType = PiType;                       // Type TEXT/JSON/XML
           endif;

           select;
            when LocMethod = 'GET';                     // GET Request
              LocQrystr = %str(getenv('QUERY_STRING':DsApierr));
            when LocMethod = 'POST' and LocContlen > 0; // POST Request
              select;
               when LocType = Text;                     // Text
                 LocBuffer_p = %alloc(LocContlen);
                 readStdin(LocBuffer_p:LocContlen:LocAvail:DsApierr);
                 LocQrystr = %str(LocBuffer_p:LocAvail);
               when %parms = 1 and (PiType = JSON or PiType = XML);
                 select;
                  when PiType = JSON;                   // JSON
                    if %scan('application/json':LocContType) > *zero or
                       %scan('text/json':LocContType)        > *zero;
                       PsInput.Data_p  = %alloc(LocContlen);
                       readStdin(PsInput.Data_p:LocContlen:LocAvail:DsApierr);
                       PsInput.DataLen = LocAvail;
                       PsInput.UTF8    = *on;
                    endif;
                  when PiType = XML;                    // XML
                    if %scan('application/xml':LocContType) > *zero or
                       %scan('text/xml':LocContType)        > *zero;
                       PsInput.Data_p  = %alloc(LocContlen);
                       readStdin(PsInput.Data_p:LocContlen:LocAvail:DsApierr);
                       PsInput.DataLen = LocAvail;
                       PsInput.UTF8    = *on;
                    endif;
                 endsl;
              endsl;
           endsl;

           if LocQrystr <> *blanks;
              parseQueryString(LocQrystr);
           endif;

           monitor;                                   // Authorization-Type
             PsInput.AuthType = %str(getenv('AUTH_TYPE':DsApierr));
            on-error;
           endmon;

           monitor;                                   // Remote-User
             PsInput.RmtUser  = %str(getenv('REMOTE_USER':DsApierr));
            on-error;
           endmon;

           return PsInput;

         end-proc;
      //------------------------------------------------------------------//
      // Parse Query-String                                               //
      // Keys and Values are separated with '&'                           //
      // Example: id=5&name=Ross&city=Munich                              //
      //------------------------------------------------------------------//
         dcl-proc parseQueryString;
         dcl-pi *n;
                 PiQrystr    like(GblQrystr) const options(*varsize);
         end-pi;

         dcl-s   LocQrystr   like(GblQrystr);         // QueryString
         dcl-s   LocPos1     uns(10);                 // Position 1
         dcl-s   LocPos2     uns(10);                 // Position 2
         dcl-s   LocData     like(GblQrystr);         // Data
         dcl-s   LocLen      uns(10);                 // Length

           LocQrystr = PiQrystr + '&';                // QueryString + '&'
           LocLen = %len(LocQrystr);                  // QueryString Length

           dou LocPos2 = *zero or LocPos2 = LocLen;
             LocPos2 = %scan('&':LocQrystr:LocPos1 + 1);
             if LocPos2 > *zero and LocPos2 <= LocLen;
                LocData = %subst(LocQrystr:LocPos1 + 1:LocPos2 - LocPos1 - 1);
                if LocData <> *blanks;
                   sepKeyValue(LocData);
                endif;
                LocPos1 = LocPos2;
             endif;
           enddo;

         end-proc;
      //------------------------------------------------------------------//
      // Separate Key and Value                                           //
      // Example:  id=5 -> Key = id  Value = 5                            //
      //------------------------------------------------------------------//
         dcl-proc sepKeyValue;
         dcl-pi *n;
                 PiData      like(GblQrystr) const options(*varsize);
         end-pi;

         dcl-s   LocPos      uns(10);                 // Position
         dcl-s   LocValue    like(GblQrystr);         // Value

           LocPos = %scan('=':PiData);                // Scan Separator '='

           if LocPos > *zero and LocPos < %len(PiData); // Separator found
              WbKeyCount += 1;
              WbKeyVal(WbKeyCount).Key = %subst(PiData:1:LocPos - 1);

              cvtstr(%addr(WbKeyVal(WbKeyCount).Key:*data):
                     %len(WbKeyVal(WbKeyCount).Key):lower); // Convert low

              LocValue = %subst(PiData:LocPos + 1:%len(PiData) - LocPos);

              if %len(LocValue) > *zero;
                 WbKeyVal(WbKeyCount).Length = %len(LocValue); // ValueLength
                 WbKeyVal(WbKeyCount).Value  = %alloc(%len(LocValue));
                 memcpy(WbKeyVal(WbKeyCount).Value:%addr(LocValue:*data):
                        %len(LocValue));
              endif;
           endif;

         end-proc;
      //------------------------------------------------------------------//
      // Get Key Value                                                    //
      //------------------------------------------------------------------//
         dcl-proc getKeyValue export;
         dcl-pi *n           like(GblQrystr) rtnparm; // Value
                 PiKey       like(GblKey) const options(*varsize);
         end-pi;

         dcl-s   LocKey      like(GblKey);            // Key
         dcl-s   LocValue    like(GblQrystr);         // Value
         dcl-s   LocPos      uns(10);                 // Position

           if %len(PiKey) > *zero;
              LocKey = PiKey;
              cvtstr(%addr(LocKey:*data):%len(LocKey):lower); // Convert low

              LocPos = %lookup(LocKey:WbKeyVal(*).Key:1:WbKeyCount);

              if LocPos > *zero;                      // Key found
                 if WbKeyVal(LocPos).Length > *zero;
                    LocValue = %str(WbKeyVal(LocPos).Value:
                                    WbKeyVal(LocPos).Length);
                 endif;
              endif;
          endif;

          return LocValue;                            // Value

         end-proc;
      //------------------------------------------------------------------//
      // Convert String up/low - 0 = upper / 1 = lower                    //
      //------------------------------------------------------------------//
         dcl-proc cvtstr;
         dcl-pi *n;
                 PiStr_p     pointer const;           // String Pointer
                 PiLen       uns(10) const;           // String Length
                 PiCase      uns(05) const;           // Case 0=up/1=low
         end-pi;

         dcl-pr cvtCase      extproc('QlgConvertCase');
                 PiCtlblock  like(PsCtlblk) const;
                 PiSrcstring pointer        value;
                 PiTrgstring pointer        value;
                 PiSrclen    int(10)        const;
                 PiError     like(DsApierr) const;
         end-pr;

         dcl-ds  PsCtlblk    qualified align;         // ControlBlock
                  Reqtype    int(10)  inz(1);
                  CCSID      int(10)  inz(0);
                  Case       int(10)  inz(0);
                  *N         char(10) inz(*allx'00');
         end-ds;

           if PiStr_p <> *null and PiLen > *zero;     // Data available
              PsCtlblk.Case = PiCase;                 // Case 0=up/1=low
              cvtCase(PsCtlblk:PiStr_p:PiStr_p:PiLen:DsApierr); // convert
           endif;

         end-proc;
      //------------------------------------------------------------------//
      // Get HTTP-Header for HTTP-Version 1.1                             //
      //------------------------------------------------------------------//
         dcl-proc getHeader export;
         dcl-pi *n           like(GblHeader);         // Header
                 PiType      uns(3) const options(*nopass);
         end-pi;

         dcl-s   LocHeader   like(GblHeader);         // HTTP-Header

           if %parms = 1;
              select;
               when PiType = json;                    // JSON
                 LocHeader =
                  'status: 200 OK' + crlf +
                  'Content-type: application/json; charset=utf-8' + crlf +
                   crlf;
               when PiType = xml;                     // XML
                 LocHeader =
                  'status: 200 OK' + crlf +
                  'Content-type: application/xml; charset=utf-8' + crlf +
                   crlf;
               when PiType = text;                    // HTML
                 LocHeader =
                  'status: 200 OK' + crlf +
                  'Content-type: text/html; charset=utf-8' + crlf +
                   crlf;
              endsl;
            else;                                     // default = JSON
                 LocHeader =
                  'status: 200 OK' + crlf +
                  'Content-type: application/json; charset=utf-8' + crlf +
                   crlf;
           endif;

           return LocHeader;                          // HTTP-Header

         end-proc;
      //------------------------------------------------------------------//
      // Write Standard Output to HTTP-Server                             //
      //------------------------------------------------------------------//
         dcl-proc writeStdOut export;
         dcl-pi *n;
                 PiData_p    pointer const;
                 PiLength    int(10) const;
                 PiType      uns(03) const options(*nopass);
         end-pi;

         dcl-s   LocHeader   like(GblHeader);         // HTTP-Header

           if %parms = 3;
              LocHeader = getHeader(PiType);          // Get HTTP-Header
            else;
              LocHeader = getHeader(JSON);            // Default = JSON
           endif;

      // write Header to HTTP-Server

           wrtStdout(%addr(LocHeader:*data):%len(LocHeader):DsApierr);

      // write Data   to HTTP-Server

           if PiData_p <> *null and PiLength > *zero;
              wrtStdout(PiData_p:PiLength:DsApierr);
           endif;

         end-proc;
      //------------------------------------------------------------------//
      // Encode Data to BASE64                                            //
      //------------------------------------------------------------------//
         dcl-proc encBase64 export;
         dcl-pi *n           varchar(100000) rtnparm; // Encoded String
                 PiString_p  pointer const;           // String Pointer
                 PiLength    int(10) const;           // String Length
         end-pi;

         dcl-s   LocBase64   char(1000000);           // Base64-String
         dcl-s   LocEnclen   int(10);                 // EncodedLength

           LocEnclen = encBase64Bin(%addr(LocBase64):PiString_p:PiLength);

           if LocEnclen > *zero;                       // Encoded Length
              return %subst(LocBase64:1:LocEnclen - 1);// without last null
            else;
              return *blanks;
           endif;

         end-proc;
      //------------------------------------------------------------------// 
