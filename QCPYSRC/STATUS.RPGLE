      //------------------------------------------------------------------//
      // Array Status                                                     //
      //------------------------------------------------------------------//

         dcl-ds  DsStatus    qualified;               // Status
                  Success    varchar(05) inz('true'); // Success
                  ErrorMsg   char(256);               // ErrorMessage
                  ErrorId    int(10);                 // ErrorId
         end-ds;

      //------------------------------------------------------------------// 
