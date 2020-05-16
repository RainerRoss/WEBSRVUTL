      //------------------------------------------------------------------//
      // QSYGETPH - Get Profile Handle                                    //
      //------------------------------------------------------------------//

         dcl-pr getPrfHdl    extpgm('QSYGETPH');
                 InUser      like(GblUser)     const; // User
                 InPassword  like(GblPassword) const; // Password
                 InHandle    like(GblHandle);         // Profilehandle
                 OutApierr   like(DsApierr)    const; // API-Error
                 InPwdlen    like(GblPwdlen)   const; // Password-Length
                 InCcsid     like(GblCCSID)    const; // CCSID
         end-pr;

      //------------------------------------------------------------------//
      // QSYRLSPH - Release Profile Handle                                //
      //------------------------------------------------------------------//

         dcl-pr rlsPrfHdl    extpgm('QSYRLSPH');
                 InHandle    like(GblHandle)  const;  // Profilehandle
                 OutApierr   like(DsApierr)   const;  // API-Error
         end-pr;

      //------------------------------------------------------------------//
      // QWTSETP - Set Profile Handle                                     //
      //------------------------------------------------------------------//

         dcl-pr setPrfHdl    extpgm('QWTSETP');
                 InHandle    like(GblHandle)  const;  // Profilehandle
                 OutApierr   like(DsApierr)   const;  // API-Error
         end-pr;

      //------------------------------------------------------------------//
      // Variables                                                        //
      //------------------------------------------------------------------//

         dcl-s   GblOk       ind;                     // ok
         dcl-s   GblUser     char(10);                // User
         dcl-s   GblPassword char(128);               // Password
         dcl-s   GblHandle   char(12);                // Profilehandle
         dcl-s   GblPwdlen   int(10);                 // Password-Length
         dcl-s   GblCCSID    int(10);                 // CCSID

      //------------------------------------------------------------------// 
