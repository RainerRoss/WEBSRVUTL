      //------------------------------------------------------------------//
      // iconv_open                                                       //
      //------------------------------------------------------------------//

         dcl-pr iconv_open   likeds(dsiconv) extproc('QtqIconvOpen');
                 ##trgcode   likeds(dstqopen) const;
                 ##srccode   likeds(dstqopen) const;
         end-pr;

      //------------------------------------------------------------------//
      // iconv                                                            //
      //------------------------------------------------------------------//

         dcl-pr iconv        extproc(*dclcase);
                 ic_hconv    like(dsiconv) value;
                 p_inbuf     pointer const;
                 in_length   uns(10) const;
                 p_outbuf    pointer const;
                 out_length  uns(10) const;
         end-pr;

      //------------------------------------------------------------------//
      // iconv_close                                                      //
      //------------------------------------------------------------------//

         dcl-pr iconv_close  extproc(*dclcase);
                 ic_hconv    like(dsiconv) value;
         end-pr;

      //------------------------------------------------------------------//
      // Arrays iconv                                                     //
      //------------------------------------------------------------------//

         dcl-ds  dsiconv     template qualified inz;
                  ic_rtnval  int(10);
                  ic_cd      int(10) dim(12);
         end-ds;

         dcl-ds  dstqopen    template qualified;
                  tq_ccsid   int(10) inz(0);
                  tq_convalt int(10) inz(0);
                  tq_subsalt int(10) inz(0);
                  tq_shftalt int(10) inz(1);
                  tq_inplen  int(10) inz(0);
                  tq_erropt  int(10) inz(0);
                  tq_reserv  char(8) inz(*allx'00');
         end-ds;

         dcl-ds  dsconv      likeds(dsiconv)  inz(*likeds);
         dcl-ds  dssrcccsid  likeds(dstqopen) inz(*likeds);
         dcl-ds  dstrgccsid  likeds(dstqopen) inz(*likeds);

      //------------------------------------------------------------------// 
