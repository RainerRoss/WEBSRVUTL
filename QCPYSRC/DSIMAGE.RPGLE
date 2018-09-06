      //------------------------------------------------------------------//
      // Array Image-Data                                                 //
      //------------------------------------------------------------------//

         dcl-ds  DsImage     qualified;
                  Dir        like(GblDir);            // Directory
                  File       like(GblFile);           // File
                  Data_p     pointer;                 // Data Pointer
                  Data_Len   uns(10);                 // Data Length
                  Dec_p      pointer;                 // Decoded Pointer
                  Dec_Len    uns(10);                 // Decoded Length
         end-ds;

      //------------------------------------------------------------------// 
