
------------------------------------------------------------------------------
--                            Ada for Automation                            --
--                                                                          --
--                   Copyright (C) 2012-2016, Stephane LOS                  --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

package body A4A.Library.Conversion is
   
   procedure Bytes_To_Word
     (LSB_Byte : in Byte;
      MSB_Byte : in Byte;
      Word_out : out Word) is
   begin
      Word_out :=
        Shift_Left (Value => Word (MSB_Byte), Amount => 8) or Word (LSB_Byte);
   end Bytes_To_Word;

   procedure Word_To_Bytes
     (Word_in  : in Word;
      LSB_Byte : out Byte;
      MSB_Byte : out Byte) is
   begin
      LSB_Byte := Byte (Word_in and 16#00ff#);
      MSB_Byte :=
        Byte (Shift_Right (Value => Word_in and 16#ff00#, Amount => 8));
   end Word_To_Bytes;

   procedure Words_To_DWord (LSW_Word  : in Word;
                             MSW_Word  : in Word;
                             DWord_out : out DWord) is
   begin
      DWord_out :=
        Shift_Left (Value => DWord (MSW_Word), Amount => 16)
        or DWord (LSW_Word);
   end Words_To_DWord;

   procedure DWord_To_Words (DWord_in  : in DWord;
                             LSW_Word  : out Word;
                             MSW_Word  : out Word) is
   begin
      LSW_Word := Word (DWord_in and 16#0000ffff#);
      MSW_Word :=
        Word (Shift_Right (Value => DWord_in and 16#ffff0000#, Amount => 16));
   end DWord_To_Words;

   procedure Byte_To_Booleans (Byte_in : in Byte;
                               Boolean_out00 : out Boolean;
                               Boolean_out01 : out Boolean;
                               Boolean_out02 : out Boolean;
                               Boolean_out03 : out Boolean;
                               Boolean_out04 : out Boolean;
                               Boolean_out05 : out Boolean;
                               Boolean_out06 : out Boolean;
                               Boolean_out07 : out Boolean
                              ) is
   begin
      Boolean_out00 := (Byte_in and 16#01#) /= 16#00#;
      Boolean_out01 := (Byte_in and 16#02#) /= 16#00#;
      Boolean_out02 := (Byte_in and 16#04#) /= 16#00#;
      Boolean_out03 := (Byte_in and 16#08#) /= 16#00#;
      Boolean_out04 := (Byte_in and 16#10#) /= 16#00#;
      Boolean_out05 := (Byte_in and 16#20#) /= 16#00#;
      Boolean_out06 := (Byte_in and 16#40#) /= 16#00#;
      Boolean_out07 := (Byte_in and 16#80#) /= 16#00#;
   end Byte_To_Booleans;

   procedure Booleans_To_Byte (
                               Boolean_in00 : in Boolean := False;
                               Boolean_in01 : in Boolean := False;
                               Boolean_in02 : in Boolean := False;
                               Boolean_in03 : in Boolean := False;
                               Boolean_in04 : in Boolean := False;
                               Boolean_in05 : in Boolean := False;
                               Boolean_in06 : in Boolean := False;
                               Boolean_in07 : in Boolean := False;
                               Byte_out : out Byte
                              ) is
   begin
      Byte_out := 16#00#;
      if Boolean_in00 then
         Byte_out := Byte_out or 16#01#;
      end if;
      if Boolean_in01 then
         Byte_out := Byte_out or 16#02#;
      end if;
      if Boolean_in02 then
         Byte_out := Byte_out or 16#04#;
      end if;
      if Boolean_in03 then
         Byte_out := Byte_out or 16#08#;
      end if;
      if Boolean_in04 then
         Byte_out := Byte_out or 16#10#;
      end if;
      if Boolean_in05 then
         Byte_out := Byte_out or 16#20#;
      end if;
      if Boolean_in06 then
         Byte_out := Byte_out or 16#40#;
      end if;
      if Boolean_in07 then
         Byte_out := Byte_out or 16#80#;
      end if;
   end Booleans_To_Byte;

   procedure Word_To_Booleans (Word_in : in Word;
                               Boolean_out00 : out Boolean;
                               Boolean_out01 : out Boolean;
                               Boolean_out02 : out Boolean;
                               Boolean_out03 : out Boolean;
                               Boolean_out04 : out Boolean;
                               Boolean_out05 : out Boolean;
                               Boolean_out06 : out Boolean;
                               Boolean_out07 : out Boolean;

                               Boolean_out08 : out Boolean;
                               Boolean_out09 : out Boolean;
                               Boolean_out10 : out Boolean;
                               Boolean_out11 : out Boolean;
                               Boolean_out12 : out Boolean;
                               Boolean_out13 : out Boolean;
                               Boolean_out14 : out Boolean;
                               Boolean_out15 : out Boolean
                              ) is
   begin
      Boolean_out00 := (Word_in and 16#0001#) /= 16#0000#;
      Boolean_out01 := (Word_in and 16#0002#) /= 16#0000#;
      Boolean_out02 := (Word_in and 16#0004#) /= 16#0000#;
      Boolean_out03 := (Word_in and 16#0008#) /= 16#0000#;
      Boolean_out04 := (Word_in and 16#0010#) /= 16#0000#;
      Boolean_out05 := (Word_in and 16#0020#) /= 16#0000#;
      Boolean_out06 := (Word_in and 16#0040#) /= 16#0000#;
      Boolean_out07 := (Word_in and 16#0080#) /= 16#0000#;

      Boolean_out08 := (Word_in and 16#0100#) /= 16#0000#;
      Boolean_out09 := (Word_in and 16#0200#) /= 16#0000#;
      Boolean_out10 := (Word_in and 16#0400#) /= 16#0000#;
      Boolean_out11 := (Word_in and 16#0800#) /= 16#0000#;
      Boolean_out12 := (Word_in and 16#1000#) /= 16#0000#;
      Boolean_out13 := (Word_in and 16#2000#) /= 16#0000#;
      Boolean_out14 := (Word_in and 16#4000#) /= 16#0000#;
      Boolean_out15 := (Word_in and 16#8000#) /= 16#0000#;
   end Word_To_Booleans;

   procedure Booleans_To_Word (
                               Boolean_in00 : in Boolean := False;
                               Boolean_in01 : in Boolean := False;
                               Boolean_in02 : in Boolean := False;
                               Boolean_in03 : in Boolean := False;
                               Boolean_in04 : in Boolean := False;
                               Boolean_in05 : in Boolean := False;
                               Boolean_in06 : in Boolean := False;
                               Boolean_in07 : in Boolean := False;

                               Boolean_in08 : in Boolean := False;
                               Boolean_in09 : in Boolean := False;
                               Boolean_in10 : in Boolean := False;
                               Boolean_in11 : in Boolean := False;
                               Boolean_in12 : in Boolean := False;
                               Boolean_in13 : in Boolean := False;
                               Boolean_in14 : in Boolean := False;
                               Boolean_in15 : in Boolean := False;
                               Word_out : out Word
                              ) is
   begin
      Word_out := 16#0000#;
      if Boolean_in00 then
         Word_out := Word_out or 16#0001#;
      end if;
      if Boolean_in01 then
         Word_out := Word_out or 16#0002#;
      end if;
      if Boolean_in02 then
         Word_out := Word_out or 16#0004#;
      end if;
      if Boolean_in03 then
         Word_out := Word_out or 16#0008#;
      end if;
      if Boolean_in04 then
         Word_out := Word_out or 16#0010#;
      end if;
      if Boolean_in05 then
         Word_out := Word_out or 16#0020#;
      end if;
      if Boolean_in06 then
         Word_out := Word_out or 16#0040#;
      end if;
      if Boolean_in07 then
         Word_out := Word_out or 16#0080#;
      end if;

      if Boolean_in08 then
         Word_out := Word_out or 16#0100#;
      end if;
      if Boolean_in09 then
         Word_out := Word_out or 16#0200#;
      end if;
      if Boolean_in10 then
         Word_out := Word_out or 16#0400#;
      end if;
      if Boolean_in11 then
         Word_out := Word_out or 16#0800#;
      end if;
      if Boolean_in12 then
         Word_out := Word_out or 16#1000#;
      end if;
      if Boolean_in13 then
         Word_out := Word_out or 16#2000#;
      end if;
      if Boolean_in14 then
         Word_out := Word_out or 16#4000#;
      end if;
      if Boolean_in15 then
         Word_out := Word_out or 16#8000#;
      end if;
   end Booleans_To_Word;

   procedure DWord_To_Booleans (DWord_in : in DWord;
                                Boolean_out00 : out Boolean;
                                Boolean_out01 : out Boolean;
                                Boolean_out02 : out Boolean;
                                Boolean_out03 : out Boolean;
                                Boolean_out04 : out Boolean;
                                Boolean_out05 : out Boolean;
                                Boolean_out06 : out Boolean;
                                Boolean_out07 : out Boolean;

                                Boolean_out08 : out Boolean;
                                Boolean_out09 : out Boolean;
                                Boolean_out10 : out Boolean;
                                Boolean_out11 : out Boolean;
                                Boolean_out12 : out Boolean;
                                Boolean_out13 : out Boolean;
                                Boolean_out14 : out Boolean;
                                Boolean_out15 : out Boolean;

                                Boolean_out16 : out Boolean;
                                Boolean_out17 : out Boolean;
                                Boolean_out18 : out Boolean;
                                Boolean_out19 : out Boolean;
                                Boolean_out20 : out Boolean;
                                Boolean_out21 : out Boolean;
                                Boolean_out22 : out Boolean;
                                Boolean_out23 : out Boolean;

                                Boolean_out24 : out Boolean;
                                Boolean_out25 : out Boolean;
                                Boolean_out26 : out Boolean;
                                Boolean_out27 : out Boolean;
                                Boolean_out28 : out Boolean;
                                Boolean_out29 : out Boolean;
                                Boolean_out30 : out Boolean;
                                Boolean_out31 : out Boolean
                               ) is
   begin
      Boolean_out00 := (DWord_in and 16#00000001#) /= 16#00000000#;
      Boolean_out01 := (DWord_in and 16#00000002#) /= 16#00000000#;
      Boolean_out02 := (DWord_in and 16#00000004#) /= 16#00000000#;
      Boolean_out03 := (DWord_in and 16#00000008#) /= 16#00000000#;
      Boolean_out04 := (DWord_in and 16#00000010#) /= 16#00000000#;
      Boolean_out05 := (DWord_in and 16#00000020#) /= 16#00000000#;
      Boolean_out06 := (DWord_in and 16#00000040#) /= 16#00000000#;
      Boolean_out07 := (DWord_in and 16#00000080#) /= 16#00000000#;

      Boolean_out08 := (DWord_in and 16#00000100#) /= 16#00000000#;
      Boolean_out09 := (DWord_in and 16#00000200#) /= 16#00000000#;
      Boolean_out10 := (DWord_in and 16#00000400#) /= 16#00000000#;
      Boolean_out11 := (DWord_in and 16#00000800#) /= 16#00000000#;
      Boolean_out12 := (DWord_in and 16#00001000#) /= 16#00000000#;
      Boolean_out13 := (DWord_in and 16#00002000#) /= 16#00000000#;
      Boolean_out14 := (DWord_in and 16#00004000#) /= 16#00000000#;
      Boolean_out15 := (DWord_in and 16#00008000#) /= 16#00000000#;

      Boolean_out16 := (DWord_in and 16#00010000#) /= 16#00000000#;
      Boolean_out17 := (DWord_in and 16#00020000#) /= 16#00000000#;
      Boolean_out18 := (DWord_in and 16#00040000#) /= 16#00000000#;
      Boolean_out19 := (DWord_in and 16#00080000#) /= 16#00000000#;
      Boolean_out20 := (DWord_in and 16#00100000#) /= 16#00000000#;
      Boolean_out21 := (DWord_in and 16#00200000#) /= 16#00000000#;
      Boolean_out22 := (DWord_in and 16#00400000#) /= 16#00000000#;
      Boolean_out23 := (DWord_in and 16#00800000#) /= 16#00000000#;

      Boolean_out24 := (DWord_in and 16#01000000#) /= 16#00000000#;
      Boolean_out25 := (DWord_in and 16#02000000#) /= 16#00000000#;
      Boolean_out26 := (DWord_in and 16#04000000#) /= 16#00000000#;
      Boolean_out27 := (DWord_in and 16#08000000#) /= 16#00000000#;
      Boolean_out28 := (DWord_in and 16#10000000#) /= 16#00000000#;
      Boolean_out29 := (DWord_in and 16#20000000#) /= 16#00000000#;
      Boolean_out30 := (DWord_in and 16#40000000#) /= 16#00000000#;
      Boolean_out31 := (DWord_in and 16#80000000#) /= 16#00000000#;
   end DWord_To_Booleans;

   procedure Booleans_To_DWord (
                                Boolean_in00 : in Boolean := False;
                                Boolean_in01 : in Boolean := False;
                                Boolean_in02 : in Boolean := False;
                                Boolean_in03 : in Boolean := False;
                                Boolean_in04 : in Boolean := False;
                                Boolean_in05 : in Boolean := False;
                                Boolean_in06 : in Boolean := False;
                                Boolean_in07 : in Boolean := False;

                                Boolean_in08 : in Boolean := False;
                                Boolean_in09 : in Boolean := False;
                                Boolean_in10 : in Boolean := False;
                                Boolean_in11 : in Boolean := False;
                                Boolean_in12 : in Boolean := False;
                                Boolean_in13 : in Boolean := False;
                                Boolean_in14 : in Boolean := False;
                                Boolean_in15 : in Boolean := False;

                                Boolean_in16 : in Boolean := False;
                                Boolean_in17 : in Boolean := False;
                                Boolean_in18 : in Boolean := False;
                                Boolean_in19 : in Boolean := False;
                                Boolean_in20 : in Boolean := False;
                                Boolean_in21 : in Boolean := False;
                                Boolean_in22 : in Boolean := False;
                                Boolean_in23 : in Boolean := False;

                                Boolean_in24 : in Boolean := False;
                                Boolean_in25 : in Boolean := False;
                                Boolean_in26 : in Boolean := False;
                                Boolean_in27 : in Boolean := False;
                                Boolean_in28 : in Boolean := False;
                                Boolean_in29 : in Boolean := False;
                                Boolean_in30 : in Boolean := False;
                                Boolean_in31 : in Boolean := False;
                                DWord_out : out DWord
                               ) is
   begin
      DWord_out := 16#00000000#;
      if Boolean_in00 then
         DWord_out := DWord_out or 16#00000001#;
      end if;
      if Boolean_in01 then
         DWord_out := DWord_out or 16#00000002#;
      end if;
      if Boolean_in02 then
         DWord_out := DWord_out or 16#00000004#;
      end if;
      if Boolean_in03 then
         DWord_out := DWord_out or 16#00000008#;
      end if;
      if Boolean_in04 then
         DWord_out := DWord_out or 16#00000010#;
      end if;
      if Boolean_in05 then
         DWord_out := DWord_out or 16#00000020#;
      end if;
      if Boolean_in06 then
         DWord_out := DWord_out or 16#00000040#;
      end if;
      if Boolean_in07 then
         DWord_out := DWord_out or 16#00000080#;
      end if;

      if Boolean_in08 then
         DWord_out := DWord_out or 16#00000100#;
      end if;
      if Boolean_in09 then
         DWord_out := DWord_out or 16#00000200#;
      end if;
      if Boolean_in10 then
         DWord_out := DWord_out or 16#00000400#;
      end if;
      if Boolean_in11 then
         DWord_out := DWord_out or 16#00000800#;
      end if;
      if Boolean_in12 then
         DWord_out := DWord_out or 16#00001000#;
      end if;
      if Boolean_in13 then
         DWord_out := DWord_out or 16#00002000#;
      end if;
      if Boolean_in14 then
         DWord_out := DWord_out or 16#00004000#;
      end if;
      if Boolean_in15 then
         DWord_out := DWord_out or 16#00008000#;
      end if;

      if Boolean_in16 then
         DWord_out := DWord_out or 16#00010000#;
      end if;
      if Boolean_in17 then
         DWord_out := DWord_out or 16#00020000#;
      end if;
      if Boolean_in18 then
         DWord_out := DWord_out or 16#00040000#;
      end if;
      if Boolean_in19 then
         DWord_out := DWord_out or 16#00080000#;
      end if;
      if Boolean_in20 then
         DWord_out := DWord_out or 16#00100000#;
      end if;
      if Boolean_in21 then
         DWord_out := DWord_out or 16#00200000#;
      end if;
      if Boolean_in22 then
         DWord_out := DWord_out or 16#00400000#;
      end if;
      if Boolean_in23 then
         DWord_out := DWord_out or 16#00800000#;
      end if;

      if Boolean_in24 then
         DWord_out := DWord_out or 16#01000000#;
      end if;
      if Boolean_in25 then
         DWord_out := DWord_out or 16#02000000#;
      end if;
      if Boolean_in26 then
         DWord_out := DWord_out or 16#04000000#;
      end if;
      if Boolean_in27 then
         DWord_out := DWord_out or 16#08000000#;
      end if;
      if Boolean_in28 then
         DWord_out := DWord_out or 16#10000000#;
      end if;
      if Boolean_in29 then
         DWord_out := DWord_out or 16#20000000#;
      end if;
      if Boolean_in30 then
         DWord_out := DWord_out or 16#40000000#;
      end if;
      if Boolean_in31 then
         DWord_out := DWord_out or 16#80000000#;
      end if;
   end Booleans_To_DWord;

end A4A.Library.Conversion;
