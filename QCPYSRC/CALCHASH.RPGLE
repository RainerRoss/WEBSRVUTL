      //------------------------------------------------------------------//
      // Calculate Hash                                                   //
      //------------------------------------------------------------------//

         dcl-pr calcHash     extproc('Qc3CalculateHash');
                 PiData      pointer         value;
                 PiDatlen    int(10)         const;
                 PiDatfmt    like(GblDatfmt) const;
                 PiAlgdes    like(GblAlgdes) const;
                 PiAlgfmt    like(GblAlgdes) const;
                 PiCrypsp    like(GblCrypsp) const;
                 PiCrypdv    like(GblCrypdv) const options(*omit);
                 PiHash      like(GblHash)   options(*varsize:*omit);
                 PiApierr    like(DsApierr)  options(*varsize);
         end-pr;

         dcl-s   GblDatfmt   char(08) inz('DATA0100');// DataFormat
         dcl-s   GblAlgdes   char(16);                // AlgorithmDesc
         dcl-s   GblAlgfmt   char(08) inz('ALGD0500');// AlgorithmFormat
         dcl-s   GblCrypsp   char(01);                // CryptoServiceProv
         dcl-s   GblCrypdv   char(01);                // CryptoDeviceName
         dcl-s   GblHash     char(64);                // HashValue

         dcl-ds  Algd0500_t  qualified based(template);
                  HashAlg    int(10);
         end-ds;

         dcl-ds  DsAlg       likeds(algd0500_t);      // Array Algorithm

      //------------------------------------------------------------------//
      // QDXLATE                                                          //
      //------------------------------------------------------------------//

         dcl-pr qdcxlate     extpgm;
                 PiLen       packed(05)    const;
                 PiData      char(32000)   options(*varsize);
                 PiTable     char(10)      const;
         end-pr;

      //------------------------------------------------------------------//
      // CVTHC - Convert Character to Hex                                 //
      //------------------------------------------------------------------//

         dcl-pr cvthc        extproc(*dclcase);
                 PiHex       char(128) options(*varsize);
                 PiChr       char(128) options(*varsize);
                 PiLen       int(10)   value;
         end-pr;

      //------------------------------------------------------------------//
      // Constants                                                        //
      //------------------------------------------------------------------//

         dcl-c   MD5         const(1);                // Hash-MD5    32 Byte
         dcl-c   SHA1        const(2);                // Hash-SHA1   40 Byte
         dcl-c   SHA256      const(3);                // Hash-SHA256 64 Byte
         dcl-c   SHA384      const(4);                // Hash-SHA384 96 Byte
         dcl-c   SHA512      const(5);                // Hash-SHA512 128Byte

         dcl-c   UpChar      const('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
         dcl-c   LowChar     const('abcdefghijklmnopqrstuvwxyz');

      //------------------------------------------------------------------// 
