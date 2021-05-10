
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

--  This package provides functions to convert :
--  - Bytes_To_Word,
--  - Word_To_Bytes,
--  - and many other.

package A4A.Library.Conversions is
   
   procedure Bytes_To_Word
     (LSB_Byte : in Byte;
      MSB_Byte : in Byte;
      Word_out : out Word);
   
   procedure Word_To_Bytes
     (Word_in  : in Word;
      LSB_Byte : out Byte;
      MSB_Byte : out Byte);
   
   procedure Words_To_DWord
     (LSW_Word  : in Word;
      MSW_Word  : in Word;
      DWord_out : out DWord);
   
   procedure DWord_To_Words
     (DWord_in  : in DWord;
      LSW_Word  : out Word;
      MSW_Word  : out Word);
   
   procedure Byte_To_Booleans
     (Byte_in : in Byte;
      Boolean_out00 : out Boolean;
      Boolean_out01 : out Boolean;
      Boolean_out02 : out Boolean;
      Boolean_out03 : out Boolean;
      Boolean_out04 : out Boolean;
      Boolean_out05 : out Boolean;
      Boolean_out06 : out Boolean;
      Boolean_out07 : out Boolean);

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
                              );

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
                              );

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
                              );

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
                               );

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
                               );

end A4A.Library.Conversion;
