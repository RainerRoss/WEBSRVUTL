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
