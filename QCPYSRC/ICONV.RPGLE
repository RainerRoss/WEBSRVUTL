      //------------------------------------------------------------------//
      // iconv_open                                                       //
      //------------------------------------------------------------------//

         dcl-pr iconv_open   likeds(DsIconv) extproc('QtqIconvOpen');
                 PiTrgcode   likeds(DsTqopen) const;
                 PiSrccode   likeds(DsTqopen) const;
         end-pr;

      //------------------------------------------------------------------//
      // iconv                                                            //
      //------------------------------------------------------------------//

         dcl-pr iconv        extproc(*dclcase);
                 ic_hconv    like(DsIconv) value;
                 p_inbuf     pointer const;
                 in_length   uns(10) const;
                 p_outbuf    pointer const;
                 out_length  uns(10) const;
         end-pr;

      //------------------------------------------------------------------//
      // iconv_close                                                      //
      //------------------------------------------------------------------//

         dcl-pr iconv_close  extproc(*dclcase);
                 ic_hconv    like(DsIconv) value;
         end-pr;

      //------------------------------------------------------------------//
      // Arrays iconv                                                     //
      //------------------------------------------------------------------//

         dcl-ds  DsIconv     template qualified inz;
                  ic_rtnval  int(10);
                  ic_cd      int(10) dim(12);
         end-ds;

         dcl-ds  DsTqopen    template qualified;
                  tq_ccsid   int(10) inz(0);
                  tq_convalt int(10) inz(0);
                  tq_subsalt int(10) inz(0);
                  tq_shftalt int(10) inz(1);
                  tq_inplen  int(10) inz(0);
                  tq_erropt  int(10) inz(0);
                  tq_reserv  char(8) inz(*allx'00');
         end-ds;

         dcl-ds  DsConv      likeds(DsIconv)  inz(*likeds);
         dcl-ds  DsSrcCcsid  likeds(DsTqopen) inz(*likeds);
         dcl-ds  DsTrgCcsid  likeds(DsTqopen) inz(*likeds);

      //------------------------------------------------------------------// 
