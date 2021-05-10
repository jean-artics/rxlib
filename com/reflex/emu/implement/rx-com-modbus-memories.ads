-----------------------------------------------------------------------
--                       Reflex Library - Timers                     --
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

with System;

with Rx.Com.Protocols; use Rx.Com.Protocols.IP_Address_Strings;
with Rx.Com.Protocols.LibModbus; use Rx.Com.Protocols.LibModbus;
with Rx.Sys.Lock_Mechanisms; use Rx.Sys.Lock_Mechanisms;

generic
   Coils_Number           : Positive;
   Input_Bits_Number      : Positive;
   Input_Registers_Number : Positive;
   Registers_Number       : Positive;
   
package Rx.Com.Modbus.Memories is

   use Rx.Com.Protocols;
   
   function Get_Coils_Number           return Positive;
   function Get_Input_Bits_Number      return Positive;
   function Get_Input_Registers_Number return Positive;
   function Get_Registers_Number       return Positive;
   
    procedure Inputs_Bits_Write
     (Inputs : in Bool_Array;
      Offset : in Natural);

   procedure Inputs_Bit_Write
     (Input  : in Boolean;
      Offset : in Natural);

   procedure Inputs_Bit_Read
     (Input  : out Boolean;
      Offset : in Natural);

   procedure Coils_Read
     (Outputs : out Bool_Array;
      Offset  : in Natural);

   procedure Coil_Read
     (Output  : out Boolean;
      Offset  : in Natural);

   procedure Coils_Write
     (Inputs : in Bool_Array;
      Offset : in Natural);

   procedure Coil_Write
     (Input  : in Boolean;
      Offset : in Natural);

   procedure Inputs_Registers_Write
     (Inputs : in Word_Array;
      Offset : in Natural);

   procedure Registers_Read
     (Outputs : out Word_Array;
      Offset  : in Natural);

   procedure Registers_Write
     (Inputs : in Word_Array;
      Offset : in Natural);
   
   function Get_Mapping return LibModbus.Modbus_Mapping_Type;
   
   Input_Bits_RW_Lock      : Simple_RW_Lock_Mechanism;
   Coils_RW_Lock           : Simple_RW_Lock_Mechanism;
   Input_Registers_RW_Lock : Simple_RW_Lock_Mechanism;
   Registers_RW_Lock       : Simple_RW_Lock_Mechanism;
   
private
   Coils           : aliased Byte_Array := (0..Coils_Number - 1 => 0);
   Input_Bits      : aliased Byte_Array := (0..Input_Bits_Number - 1 => 0);
   Input_Registers : aliased Word_Array := (0..Input_Registers_Number - 1 => 0);
   Registers       : aliased Word_Array := (0..Registers_Number - 1 => 0);

   My_Mapping : aliased LibModbus.Modbus_Mapping_Type :=
     (Nb_Bits             => Coils'Length,
      Nb_Input_Bits       => Input_Bits'Length,
      Nb_Input_Registers  => Input_Registers'Length,
      Nb_Registers        => Registers'Length,
      Tab_Bits            => Coils'Address,
      Tab_Input_Bits      => Input_Bits'Address,
      Tab_Input_Registers => Input_Registers'Address,
      Tab_Registers       => Registers'Address);

end Rx.Com.Modbus.Memories;
