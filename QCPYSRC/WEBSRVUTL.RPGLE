      //------------------------------------------------------------------//    
      // QtmhRdStin - Read Standard Input from HTTP-Server                //    
      //------------------------------------------------------------------//    
                                                                                
         dcl-pr readStdin    extproc('QtmhRdStin');                             
                 tmhdata     pointer        value;                              
                 tmhdatalen  int(10)        const;                              
                 tmhavail    int(10)        const;                              
                 tmherror    like(DsApierr) const;                              
         end-pr;                                                                
                                                                                
      //------------------------------------------------------------------//    
      // QtmhWrStout - Write Standard Output to HTTP-Server               //    
      //------------------------------------------------------------------//    
                                                                                
         dcl-pr wrtStdout    extproc('QtmhWrStout');                            
                 tmhdata     pointer        value;                              
                 tmhdatalen  int(10)        const;                              
                 tmherror    like(DsApierr) const;                              
         end-pr;                                                                
                                                                                
      //------------------------------------------------------------------//    
      // Get Environment from HTTP-Server                                 //    
      //------------------------------------------------------------------//    
                                                                                
         dcl-pr getenv       pointer extproc(*dclcase);                         
                 pienvvar    pointer value options(*string);                    
                 pierror     like(DsApierr) const;                              
         end-pr;                                                                
                                                                                
      //------------------------------------------------------------------//    
      // Get Input from HTTP-Server                                       //    
      //------------------------------------------------------------------//    
                                                                                
         dcl-pr getInput end-pr;                                                
                                                                                
      //------------------------------------------------------------------//    
      // GetKeyValue                                                      //    
      //------------------------------------------------------------------//    
                                                                                
         dcl-pr getKeyValue  like(GblQrystr) rtnparm; // Return Variable        
                 PiKey       like(GblKey)    const options(*varsize);           
         end-pr;                                                                
                                                                                
      //------------------------------------------------------------------//    
      // Get HTTP-Header - Type JSON/XML/TEXT                             //    
      //------------------------------------------------------------------//    
                                                                                
         dcl-pr getHeader    like(GblHeader);                                   
                 PiType      uns(3) const options(*nopass);// Type              
         end-pr;                                                                
                                                                                
      //------------------------------------------------------------------//    
      // Array Key Values from Query-String                               //    
      //------------------------------------------------------------------//    
                                                                                
         dcl-s   KeyCounter  uns(10);                                           
                                                                                
         dcl-ds  DsKeyVal    qualified dim(5000) inz;                            
                  Key        like(GblKey);                                      
                  Value      pointer;                                           
                  Length     uns(10);                                           
         end-ds;                                                                
                                                                                
         dcl-s   GblKey      varchar(128);            // Key                    
                                                                                
      //------------------------------------------------------------------//    
      // Constants                                                        //    
      //------------------------------------------------------------------//    
                                                                                
         dcl-c   crlf        x'0D25';                 // CRLF                   
                                                                                
         dcl-c   json        1;                       // JSON                   
         dcl-c   xml         2;                       // XML                    
         dcl-c   text        3;                       // TEXT                   
                                                                                
         dcl-c   lower       1;                       // Lower                  
         dcl-c   upper       0;                       // Upper                  
                                                                                
      //------------------------------------------------------------------//    
      // Variables                                                        //    
      //------------------------------------------------------------------//    
                                                                                
         dcl-s   GblQrystr   varchar(1000000);        // Query-String           
         dcl-s   GblHeader   varchar(256);            // HTTP-Header            
                                                                                
      //------------------------------------------------------------------//     
