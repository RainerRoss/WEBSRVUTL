      //------------------------------------------------------------------//
      // Open-Directory                                                   //
      //------------------------------------------------------------------//

         dcl-pr opendir      pointer extproc(*dclcase);
                 dirname     pointer value options(*string);
         end-pr;

      //------------------------------------------------------------------//
      // Read-Directory                                                   //
      //------------------------------------------------------------------//

         dcl-pr readdir      pointer extproc(*dclcase);
                 dirname     pointer value options(*string);
         end-pr;

      //------------------------------------------------------------------//
      // Close-Directory                                                  //
      //------------------------------------------------------------------//

         dcl-pr closedir     int(10) extproc(*dclcase);
                 dirname     pointer value options(*string);
         end-pr;

      //------------------------------------------------------------------//
      // Make-Directory                                                   //
      //------------------------------------------------------------------//

         dcl-pr mkdir        int(10) extproc(*dclcase);
                 path        pointer value options(*string);
                 mode        uns(10) value;
         end-pr;

      //------------------------------------------------------------------//
      // Remove-Directory                                                 //
      //------------------------------------------------------------------//

         dcl-pr rmdir        int(10) extproc(*dclcase);
                 path        pointer value options(*string);
         end-pr;

      //------------------------------------------------------------------//
      // Check Access to Path or File                                     //
      //------------------------------------------------------------------//

         dcl-pr access       int(10) extproc(*dclcase);
                 path        pointer value options(*string);
                 mode        int(10) value;
         end-pr;

      //------------------------------------------------------------------//
      // Create a file name for a temporary stream file                   //
      //------------------------------------------------------------------//

         dcl-pr crttmpstmf   pointer extproc('_C_IFS_tmpnam');
                 sfstring    char(39) options(*omit);
         end-pr;

      //------------------------------------------------------------------//
      // Open-File                                                        //
      //------------------------------------------------------------------//

         dcl-pr open         int(10) extproc(*dclcase);
                 filname     pointer value options(*string);
                 openflags   int(10) value;
                 mode        uns(10) value options(*nopass);
                 fileccsid   uns(10) value options(*nopass);
                 dataccsid   uns(10) value options(*nopass);
         end-pr;

      //------------------------------------------------------------------//
      // Read-File                                                        //
      //------------------------------------------------------------------//

         dcl-pr read         int(10) extproc(*dclcase);
                 filedesc    int(10) value;
                 filebuffer  pointer value;
                 filebyte    uns(10) value;
         end-pr;

      //------------------------------------------------------------------//
      // Rename-File                                                      //
      //------------------------------------------------------------------//

         dcl-pr rename       int(10) extproc('Qp0lRenameKeep');
                 oldname     pointer value options(*string);
                 newname     pointer value options(*string);
         end-pr;

      //------------------------------------------------------------------//
      // Write-File                                                       //
      //------------------------------------------------------------------//

         dcl-pr write        int(10) extproc(*dclcase);
                 filedesc    int(10) value;
                 filebuffer  pointer value;
                 filebyte    uns(10) value;
         end-pr;

      //------------------------------------------------------------------//
      // Close-File                                                       //
      //------------------------------------------------------------------//

         dcl-pr close        int(10) extproc(*dclcase);
                 filedesc    int(10) value;
         end-pr;

      //------------------------------------------------------------------//
      // Unlink-File                                                      //
      //------------------------------------------------------------------//

         dcl-pr unlink       int(10) extproc(*dclcase);
                 filename    pointer value options(*string);
         end-pr;

      //------------------------------------------------------------------//
      // Array Directory Data                                             //
      //------------------------------------------------------------------//

         dcl-s   GblDirent_p  pointer;                // DirectoryEntryPtr

         dcl-ds  DsDirent    qualified based(GblDirent_p);
                  Reserv1  char(16);
                  Reserv2  uns(10);
                  Fileno   uns(10);
                  Rreclen   uns(10);
                  Reserv3  int(10);
                  Reserv4  char(08);
                  NlsInfo  char(12);
                  NlsCcsid int(10)  overlay(NlsInfo:01);
                  NlsEntry char(02) overlay(NlsInfo:05);
                  NlsLang  char(03) overlay(NlsInfo:07);
                  NlsReser char(03) overlay(NlsInfo:10);
                  Namelen  uns(10);
                  Name     char(640);
         end-ds;

      //------------------------------------------------------------------//
      // Constants IFS Parameter                                          //
      //------------------------------------------------------------------//

         dcl-c   GblRdonly    1;                      // Read Only
         dcl-c   GblWronly    2;                      // Write Only
         dcl-c   GblRdwr      4;                      // Read & Write
         dcl-c   GblCreat     8;                      // Create File
         dcl-c   GblExcl      16;                     // Exclusive Create
         dcl-c   GblCcsid     32;                     // Assign CCSID
         dcl-c   GblTrunc     64;                     // Truncate File
         dcl-c   GblAppend    256;                    // Append File
         dcl-c   GblWritesync 1024;                   // Synchronus write
         dcl-c   GblReadsync  4096;                   // Synchronus read
         dcl-c   GblCodepage  8388608;                // Assign a Code Page
         dcl-c   GblTextdata  16777216;               // Open in TextMode
         dcl-c   GblTextcreat 33554432;               // TextTranslation
         dcl-c   GblLargefile 536870912;              // File > 2GB

      //------------------------------------------------------------------//
      // Constants IFS Authority                                          //
      //  user      owner   group   other                                 //
      //  access    R W X   R W X   R W X                                 //
      //------------------------------------------------------------------//

         dcl-c   GblIrusr    256;
         dcl-c   GblIwusr    128;
         dcl-c   GblIxusr    64;
         dcl-c   GblIrwxu    448;

         dcl-c   GblIrgrp    32;
         dcl-c   GblIwgrp    16;
         dcl-c   GblIxgrp    8;
         dcl-c   GblIrwxg    56;

         dcl-c   GblIroth    4;
         dcl-c   GblIwoth    2;
         dcl-c   GblIxoth    1;
         dcl-c   GblIrwxo    7;

      //------------------------------------------------------------------//
      // Constants IFS access() mode                                      //
      //------------------------------------------------------------------//

         dcl-c  F_Ok         const(0);                // File Exists
         dcl-c  R_Ok         const(4);                // Read Access
         dcl-c  W_Ok         const(2);                // Write Access
         dcl-c  X_Ok         const(1);                // Execute or Search

      //------------------------------------------------------------------//
      // Variables                                                        //
      //------------------------------------------------------------------//

         dcl-s   GblFlags    int(10);                 // Flags
         dcl-s   GblAuth     int(10);                 // Authority
         dcl-s   GblFd       int(10);                 // FileDescriptor
         dcl-s   GblByte     uns(10);                 // Bytes

         dcl-s   GblDir_p    pointer;                 // DirectoryPointer
         dcl-s   GblDir      varchar(512);            // Directory
         dcl-s   GblFile     varchar(512);            // File
         dcl-s   GblStmf     varchar(1024);           // Streamfile

      //------------------------------------------------------------------// 
