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
