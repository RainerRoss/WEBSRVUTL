         ctl-opt dftactgrp(*no) alloc(*teraspace) option(*nodebugio:*nounref)
                 actgrp('WEBSRV01') bnddir('WEBSRVUTL':'YAJL')  DecEdit('0.')
                 Main(Main);
      //------------------------------------------------------------------//
      //                                                                  //
      // Webservice Kunden im JSON-Format                                 //
      //                                                                  //
      //-----------------                                                 //
      // R.Ross 12.2016 *                                                 //
      //------------------------------------------------------------------//
      // Dateidefinitionen                                                //
      //------------------------------------------------------------------//

      //------------------------------------------------------------------//
      // Prototypen                                                       //
      //------------------------------------------------------------------//

      /include websrvutl/qcpysrc,websrvutl                                     // Webservice Utilities
      /include websrvutl/qcpysrc,apierr                                        // API-Error
      /include yajl/qrpglesrc,yajl_h                                           // JSON Utilities

      //------------------------------------------------------------------//
      // Table Data                                                       //
      //------------------------------------------------------------------//
         DCL-S   GblErrmsg   VarChar(500);

         DCL-C   GblStatusOk Const(200);                                       //Status OK

         DCL-DS  RefDSkndstap ExtName('KNDSTAP') Template End-DS;
      //------------------------------------------------------------------//
      // Procedure - Main                                                 //
      //------------------------------------------------------------------//
         dcl-proc main;

         dcl-s   LocKndnr    Like(KndNr);                                      // Kunde

           getInput();                                                         // Get Input

           monitor;
             LocKndnr = %dec(getKeyValue('Id'):9:0);                           // Get Kunden-Nr.
           on-error;
             Clear LocKndnr;
           endmon;

           yajl_genopen(*on);                                                  // Pretty-Code
              crtjson(LocKndnr);
              yajl_writeStdout(GblStatusOk: GblErrMsg);
           yajl_genclose();

           return;
         end-proc;
      //------------------------------------------------------------------//
      // Procedure JSON-Daten erstellen                                   //
      //------------------------------------------------------------------//
         dcl-proc crtjson;
         dcl-pi *N;
                 PiKndnr     like(kndnr) const;                                // Kunde
         end-pi;

           yajl_beginobj();
             yajl_addbool('success': *On);
             yajl_addchar('errmsg' :%trim(GblErrMsg));

             yajl_beginarray('items');                                         // Array Items
               readkunden(PiKndnr);                                            // Read Kunden
             yajl_endarray();
           yajl_endobj();

           return;

         end-proc;
      //------------------------------------------------------------------//
      // Procedure - Read Kunden                                          //
      //------------------------------------------------------------------//
         dcl-proc readkunden;
         dcl-pi *n;
                 PiKndnr     like(kndnr) const;                               // Kunde
         end-pi;

         DCL-S  LocErrMsg    Char(132);

         DCL-DS  DSSQLCsr;
           CsrId     Like(KndNr);
           CsrName   Like(Name);
           CsrLand   Like(Land);
           CsrPLZ    Like(PLZ);
           CsrOrt    Like(Ort);
           CsrStr    Like(Str);
           CsrUmsatz Like(Umsatz);
           CsrKredit Like(Kredit);
           CSrSaldo  LIke(Saldo);
           CsrAendatum Like(AenDatum);
         END-DS;

         Exec SQL Declare Csr Cursor For
            Select KndNr, Name, Land, PLZ, Ort, STR, Umsatz,  Kredit,
                   SAldo, Aendatum
              from KndStap
              Where  KndNr = Case When :PIKndNr > 0
                                  Then :PIKndNr
                                  Else KndNr
                                  End
              Order By KndNr;

          Exec SQL Close Csr;
          Exec SQL Open Csr;

          DoU 1=0;
             Exec SQL Fetch Next From Csr into :DSSQLCsr;
             If SQLCODE = 100;
                Leave;
             ElseIf SQLCODE < *Zeros;
                Exec SQL  Get Diagnostics Condition 1
                                          :LocErrMsg = MESSAGE_TEXT;
                Leave;
             ENDIF;

             yajl_beginobj();
               yajl_addnum ('id'       :%char(CsrId));
               yajl_addchar('name'     :%trim(Csrname));
               yajl_addchar('land'     :%trim(Csrland));
               yajl_addchar('plz'      :%trim(Csrplz));
               yajl_addchar('ort'      :%trim(Csrort));
               yajl_addchar('str'      :%trim(Csrstr));
               yajl_addnum ('umsatz'   :%char(Csrumsatz));
               yajl_addnum ('kredit'   :%char(Csrkredit));
               yajl_addnum ('saldo'    :%char(Csrsaldo));
               yajl_addchar('aendatum' :%char(Csraendatum));
             yajl_endobj();

           EndDo;

           Exec SQL Close Csr;
           return;
         end-proc;
      //------------------------------------------------------------------// 
