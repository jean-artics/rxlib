-----------------------------------------------------------------------
--                       Reflex Library                              --
--                                                                   --
--              Copyright (C) 2012-2014, Artics                      --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this library; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-- As a special exception, if other files instantiate generics from  --
-- this unit, or you link this unit with other files to produce an   --
-- executable, this  unit  does not  by itself cause  the resulting  --
-- executable to be covered by the GNU General Public License. This  --
-- exception does not however invalidate any other reasons why the   --
-- executable file  might be covered by the  GNU Public License.     --
-----------------------------------------------------------------------

with Interfaces;

with Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Calendar.Time_Zones; use Ada.Calendar.Time_Zones;

with Ada.Unchecked_Conversion;

package Rx.Com is
   
   --------------------------------------------------------------------
   --  Elementary types
   --------------------------------------------------------------------

   type Byte is new Interfaces.Unsigned_8;
   --  8-bit unsigned integer

   type Word is new Interfaces.Unsigned_16;
   --  16-bit unsigned integer

   type DWord is new Interfaces.Unsigned_32;
   --  32-bit unsigned integer

   type LWord is new Interfaces.Unsigned_64;
   --  64-bit unsigned integer

   type SInt is new Interfaces.Integer_8;
   --  8-bit signed integer

   type Int is new Interfaces.Integer_16;
   --  16-bit signed integer

   type DInt is new Interfaces.Integer_32;
   --  32-bit signed integer

   type LInt is new Interfaces.Integer_64;
   --  64-bit signed integer

   --------------------------------------------------------------------
   --  Elementary functions
   --------------------------------------------------------------------

   function SHL
     (Value  : Byte;
      Amount : Natural) return Byte renames Shift_Left;
   --  <summary>Shift Left Byte</summary>

   function SHR
     (Value  : Byte;
      Amount : Natural) return Byte renames Shift_Right;
   --  <summary>Shift Right Byte</summary>

   function SHL
     (Value  : Word;
      Amount : Natural) return Word renames Shift_Left;
   --  <summary>Shift Left Word</summary>

   function SHR
     (Value  : Word;
      Amount : Natural) return Word renames Shift_Right;
   --  <summary>Shift Right Word</summary>

   function SHL
     (Value  : DWord;
      Amount : Natural) return DWord renames Shift_Left;
   --  <summary>Shift Left DWord</summary>

   function SHR
     (Value  : DWord;
      Amount : Natural) return DWord renames Shift_Right;
   --  <summary>Shift Right DWord</summary>

   function ROL
     (Value  : Byte;
      Amount : Natural) return Byte renames Rotate_Left;
   --  <summary>Rotate Left Byte</summary>

   function ROR
     (Value  : Byte;
      Amount : Natural) return Byte renames Rotate_Right;
   --  <summary>Rotate Right Byte</summary>

   function ROL
     (Value  : Word;
      Amount : Natural) return Word renames Rotate_Left;
   --  <summary>Rotate Left Word</summary>

   function ROR
     (Value  : Word;
      Amount : Natural) return Word renames Rotate_Right;
   --  <summary>Rotate Right Word</summary>

   function ROL
     (Value  : DWord;
      Amount : Natural) return DWord renames Rotate_Left;
   --  <summary>Rotate Left DWord</summary>

   function ROR
     (Value  : DWord;
      Amount : Natural) return DWord renames Rotate_Right;
   --  <summary>Rotate Right DWord</summary>

   --------------------------------------------------------------------
   --  Unconstrained Arrays of Elementary types
   --------------------------------------------------------------------

   type Bool_Array is array (Integer range <>) of aliased Boolean;

   type Byte_Array is array (Integer range <>) of aliased Byte;
   for Byte_Array'Component_Size use Byte'Size;
   pragma Convention (C, Byte_Array);
   type Byte_Array_Access is access all Byte_Array;

   type Word_Array is array (Integer range <>) of aliased Word;
   for Word_Array'Component_Size use Word'Size;
   pragma Convention (C, Word_Array);
   type Word_Array_Access is access all Word_Array;

   --------------------------------------------------------------------
   --  Instanciation of Generic Text_IO package for each Elementary type
   --------------------------------------------------------------------

   package Byte_Text_IO is
     new Ada.Text_IO.Modular_IO (Byte);

   package Word_Text_IO is
     new Ada.Text_IO.Modular_IO (Word);

   package DWord_Text_IO is
     new Ada.Text_IO.Modular_IO (DWord);

   package SInt_Text_IO is
     new Ada.Text_IO.Integer_IO (SInt);

   package Int_Text_IO is
     new Ada.Text_IO.Integer_IO (Int);

   package DInt_Text_IO is
     new Ada.Text_IO.Integer_IO (DInt);

   --------------------------------------------------------------------
   --  Unchecked Conversions - Use with caution of course ;-)
   --------------------------------------------------------------------

   function SInt_To_Byte is new Ada.Unchecked_Conversion
     (Source => SInt,
      Target => Byte);

   function Byte_To_SInt is new Ada.Unchecked_Conversion
     (Source => Byte,
      Target => SInt);

   function Int_To_Word is new Ada.Unchecked_Conversion
     (Source => Int,
      Target => Word);

   function Word_To_Int is new Ada.Unchecked_Conversion
     (Source => Word,
      Target => Int);

   function DInt_To_DWord is new Ada.Unchecked_Conversion
     (Source => DInt,
      Target => DWord);

   function DWord_To_DInt is new Ada.Unchecked_Conversion
     (Source => DWord,
      Target => DInt);

   function Float_To_DWord is new Ada.Unchecked_Conversion
     (Source => Float,
      Target => DWord);

   function DWord_To_Float is new Ada.Unchecked_Conversion
     (Source => DWord,
      Target => Float);

   function LInt_To_LWord is new Ada.Unchecked_Conversion
     (Source => LInt,
      Target => LWord);

   function LWord_To_LInt is new Ada.Unchecked_Conversion
     (Source => LWord,
      Target => LInt);

   --------------------------------------------------------------------
   --  Global variables
   --------------------------------------------------------------------

   CRLF : constant String := (CR, LF);

   The_Time_Offset : Time_Offset := UTC_Time_Offset;
   
end Rx.Com;
