      //------------------------------------------------------------------//
      // Create UserSpace                                                 //
      //------------------------------------------------------------------//

         dcl-pr crtusrspc    extpgm('QUSCRTUS');
                 userspace   like(DsUsrspc)  const;
                 extattr     like(GblExtatt) const;
                 initsize    like(GblInisiz) const;
                 initvalue   like(GblInival) const;
                 pubauth     like(GblPubaut) const;
                 description like(GblUsrtxt) const;
                 replace     like(GblReplac) const options(*nopass);
                 qusec       like(DsApierr)  options(*nopass);
                 domain      like(GblDomain) options(*nopass);
         end-pr;

         dcl-ds DsUsrspc     qualified;               // UserSpace
                 Obj         char(10)  pos(01);       // Object
                 Lib         char(10)  pos(11);       // Library
         end-ds;

         dcl-s   GblExtatt   char(10);                // Extented Attribute
         dcl-s   GblInisiz   uns(10);                 // Init Size
         dcl-s   GblInival   char(01) inz(x'00');     // Init Value
         dcl-s   GblPubaut   char(10);                // Public Authority
         dcl-s   GblUsrtxt   char(50);                // UserSpace Descript
         dcl-s   GblReplac   char(10);                // Replace
         dcl-s   GblDomain   char(10);                // Domain

      //------------------------------------------------------------------//
      // Change UserSpace Attribute                                       //
      //------------------------------------------------------------------//

         dcl-pr chgusrspc    extpgm('QUSCUSAT');
                 rtnlib      like(GblRtnlib) const;
                 userspace   like(DsUsrspc)  const;
                 chgattr     like(DsChgatt)  const;
                 qusec       like(DsApierr)  options(*nopass);
         end-pr;

         dcl-ds DsChgatt;                             // ChangeAttribute
                 nbrattr     int(10) inz(1);          // Number Attributes
                 keyattr     int(10) inz(3);          // Key Attribute
                 sizattr     int(10) inz(1);          // Size Attribute
                 datattr     char(1) inz('1');        // Data Attribute
         end-ds;

         dcl-s   GblRtnlib    char(10);               // ReturnLib

      //------------------------------------------------------------------//
      // Retrieve UserSpace                                               //
      //------------------------------------------------------------------//

         dcl-pr rtvusrspc    extpgm('QUSRTVUS');
                 userspace   like(DsUsrspc)  const;
                 startpos    like(GblStart)  const;
                 datalength  like(GblDatlen) const;
                 data        like(GblData)   const options(*varsize);
                 qusec       like(DsApierr)  const options(*nopass);
         end-pr;

         dcl-s   GblStart     int(10);                // StartData
         dcl-s   GblDatlen    int(10);                // DataLength
         dcl-s   GblData      varchar(32767);         // Data

      //------------------------------------------------------------------//
      // Retrieve UserSpace Attributes                                    //
      //------------------------------------------------------------------//

         dcl-pr rtvusratr    extpgm('QUSRUSAT');
                 rcvvariable like(GblRcvvar) options(*varsize);
                 rcvvarlen   like(GblVarlen) const;
                 format      like(GblSpcfmt) const;
                 userspace   like(DsUsrspc)  const;
                 qusec       like(DsApierr)  const options(*nopass);
         end-pr;

         dcl-s   GblRcvvar   char(32767);             // ReceiveVariable
         dcl-s   GblVarlen   int(10);                 // VariableLength
         dcl-s   GblSpcfmt   char(08);                // Format

      //------------------------------------------------------------------//
      // Delete UserSpace                                                 //
      //------------------------------------------------------------------//

         dcl-pr dltusrspc    extpgm('QUSDLTUS');
                 userspace   like(DsUsrspc) const;
                 qusec       like(DsApierr) options(*nopass);
         end-pr;

      //------------------------------------------------------------------//
      // Get UserSpace Pointer                                            //
      //------------------------------------------------------------------//

         dcl-pr rtvusrptr    extpgm('QUSPTRUS');
                 userspace   like(DsUsrspc) const;
                 usrspc_p    pointer;
                 qusec       like(DsApierr) options(*nopass);
         end-pr;

      //------------------------------------------------------------------// 
