           ctl-opt nomain alloc(*teraspace);                                      
      //------------------------------------------------------------------//    
      //                                                                  //    
      // Webservice Utilities V1.3                                        //    
      //                                                                  //    
      //-----------------                                                 //    
      // R.Ross 08.2017 *                                                 //    
      //------------------------------------------------------------------//    
      // Prototypes                                                       //    
      //------------------------------------------------------------------//    
                                                                                
      /include websrvutl/qcpysrc,websrvutl                                      
      /include websrvutl/qcpysrc,memcpy                                         
      /include websrvutl/qcpysrc,apierr                                         
                                                                                
      //------------------------------------------------------------------//    
      // Get Input from HTTP-Server                                       //    
      //------------------------------------------------------------------//    
         dcl-proc getInput export;                                              
                                                                                
         dcl-s   LocQrystr   like(GblQrystr);         // Query-String           
         dcl-s   LocMethod   varchar(20);             // Request-Method         
         dcl-s   LocContlen  uns(10);                 // Content-Length         
         dcl-s   LocBuffer_p pointer;                 // Buffer-Pointer         
         dcl-s   LocAvail    int(10);                 // Available Length       
                                                                                
           clear DsKeyVal;                            // Array KeyValues        
           clear KeyCounter;                          // Key-Counter            
                                                                                
           LocMethod  = %str(getenv('REQUEST_METHOD':DsApierr));                
           LocContlen = %dec(%str(getenv('CONTENT_LENGTH':DsApierr)):10:0);     
                                                                                
           select;                                                              
            when LocMethod = 'GET';                    // GET Request           
              LocQrystr = %str(getenv('QUERY_STRING':DsApierr));                
            when LocMethod = 'POST' and LocContlen > 0;// POST Request          
              LocBuffer_p = %alloc(LocContlen);                                 
              readStdin(LocBuffer_p:LocContlen:LocAvail:DsApierr);              
              if LocAvail > *zero;                     // Bytes available       
                 LocQrystr = %str(LocBuffer_p:LocAvail);                        
              endif;                                                            
           endsl;                                                               
                                                                                
           if LocQrystr <> *blanks;                                             
              parseQueryString(LocQrystr);                                      
           endif;                                                               
                                                                                
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
         dcl-s   LocLen      uns(10);                 // Length                 
                                                                                
           LocPos = %scan('=':PiData);                // Scan Separator '='     
                                                                                
           if LocPos > *zero and LocPos < %len(PiData); // Separator found      
              KeyCounter += 1;                                                  
              DsKeyVal(KeyCounter).Key = %subst(PiData:1:LocPos - 1);           
                                                                                
              cvtstr(%addr(DsKeyVal(KeyCounter).Key:*data):                     
                     %len(DsKeyVal(KeyCounter).Key):lower); // Convert low      
                                                                                
              LocValue = %subst(PiData:LocPos + 1:%len(PiData) - LocPos);       
                                                                                
              if %len(LocValue) > *zero;                                        
                 DsKeyVal(KeyCounter).Length = %len(LocValue); // ValueLength   
                 DsKeyVal(KeyCounter).Value  = %alloc(%len(LocValue));          
                 memcpy(DsKeyVal(KeyCounter).Value:%addr(LocValue:*data):       
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
                                                                                
              LocPos = %lookup(LocKey:DsKeyVal(*).Key:1:KeyCounter);            
                                                                                
              if LocPos > *zero;                      // Key found              
                 if DsKeyVal(LocPos).Length > *zero;                            
                    LocValue = %str(DsKeyVal(LocPos).Value:                     
                                    DsKeyVal(LocPos).Length);                   
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
                 PiCtlblock  like(dsctlblk) const;                              
                 PiSrcstring pointer        value;                              
                 PiTrgstring pointer        value;                              
                 PiSrclen    int(10)        const;                              
                 PiError     like(DsApierr) const;                              
         end-pr;                                                                
                                                                                
         dcl-ds  DsCtlblk    qualified align;         // ControlBlock           
                  Reqtype    int(10)  inz(1);                                   
                  CCSID      int(10)  inz(0);                                   
                  Case       int(10)  inz(0);                                   
                  *N         char(10) inz(*allx'00');                           
         end-ds;                                                                
                                                                                
           if PiStr_p <> *null and PiLen > *zero;     // Data available         
              DsCtlblk.Case = PiCase;                 // Case 0=up/1=low        
              cvtCase(DsCtlblk:PiStr_p:PiStr_p:PiLen:DsApierr); // convert      
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
