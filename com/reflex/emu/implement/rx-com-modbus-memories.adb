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

with Interfaces.C; use Interfaces.C;
with Rx.Sys.Log;

package body Rx.Com.Modbus.Memories is
   
   ----------------------
   -- Get_Coils_Number --
   ----------------------
   
   function Get_Coils_Number return Positive is
   begin
      return Coils_Number;
   end Get_Coils_Number;
   
   ---------------------------
   -- Get_Input_Bits_Number --
   ---------------------------
   
   function Get_Input_Bits_Number return Positive is
   begin
      return Input_Bits_Number;
   end Get_Input_Bits_Number;
   
   --------------------------------
   -- Get_Input_Registers_Number --
   --------------------------------
   
   function Get_Input_Registers_Number return Positive is
   begin
      return Input_Registers_Number;
   end Get_Input_Registers_Number;
   
   --------------------------
   -- Get_Registers_Number --
   --------------------------
   
   function Get_Registers_Number return Positive is
   begin
      return Registers_Number;
   end Get_Registers_Number;
   
  
   -----------------------
   -- Inputs_Bits_Write --
   -----------------------
   
   procedure Inputs_Bits_Write
     (Inputs : in Bool_Array;
      Offset : in Natural) is
   begin
      if Offset < Input_Bits_Number then
	 
	 Input_Bits_RW_Lock.Write_Lock;
	 
	 for Index in Inputs'Range loop
	    if Inputs (Index) then
	       Input_Bits (Offset + Index - Inputs'First) := LibModbus.C_TRUE;
	       
	    else
	       Input_Bits (Offset + Index - Inputs'First) := LibModbus.C_FALSE;
	    end if;
	 end loop;
      
	 Input_Bits_RW_Lock.Write_Unlock;
      end if;
   end Inputs_Bits_Write;
   
   -----------------------
   -- Inputs_Bits_Write --
   -----------------------
   
   procedure Inputs_Bits_Write
     (Inputs : in Bool_Array;
      Count  : in Natural;
      Offset : in Natural) is
   begin
      if Offset < Input_Bits_Number then
	 
	 Input_Bits_RW_Lock.Write_Lock;
	 
	 for Index in Inputs'Range loop
	    if Inputs (Index) then
	       Input_Bits (Offset + Index - Inputs'First) := LibModbus.C_TRUE;
	       
	    else
	       Input_Bits (Offset + Index - Inputs'First) := LibModbus.C_FALSE;
	    end if;
	 end loop;
      
	 Input_Bits_RW_Lock.Write_Unlock;
      end if;
   end Inputs_Bits_Write;
   
   ----------------------
   -- Inputs_Bit_Write --
   ----------------------
   
   procedure Inputs_Bit_Write
     (Input  : in Boolean;
      Offset : in Natural) is
   begin
      if Offset < Input_Bits_Number then
	 
	 Input_Bits_RW_Lock.Write_Lock;
	 
	 if Input then
	    Input_Bits (Offset) := LibModbus.C_TRUE;
	    
	 else
	    Input_Bits (Offset) := LibModbus.C_FALSE;
	 end if;
	 
	 Input_Bits_RW_Lock.Write_Unlock;
      end if;
   end Inputs_Bit_Write;
   
   ---------------------
   -- Inputs_Bit_Read --
   ---------------------
   
   procedure Inputs_Bit_Read
     (Input  : out Boolean;
      Offset : in Natural) is
   begin
      if Offset < Input_Bits_Number then
	 
	 Input_Bits_RW_Lock.Read_Lock;
	 
	 if Input_Bits (Offset) = LibModbus.C_FALSE then
	    Input := False;
	    
	 else
	    Input := True;
	 end if;
	 
	 Input_Bits_RW_Lock.Read_Unlock;
      end if;
   end Inputs_Bit_Read;
   
   ----------------
   -- Coils_Read --
   ----------------
   
   procedure Coils_Read
     (Outputs : out Bool_Array;
      Offset  : in Natural) is
   begin
      if Offset < Coils_Number then
	 
	 Coils_RW_Lock.Read_Lock;
	 
	 for Index in Outputs'Range loop
	    if Coils (Offset + Index - Outputs'First) = LibModbus.C_FALSE then
	       Outputs (Index) := False;
	       
	    else
	       Outputs (Index) := True;
	    end if;
	 end loop;
	 
	 Coils_RW_Lock.Read_Unlock;
      end if;
   end Coils_Read;
   
   ---------------
   -- Coil_Read --
   ---------------
   
   procedure Coil_Read
     (Output : out Boolean;
      Offset : in Natural) is
   begin
      if Offset < Coils_Number then
	 
	 Coils_RW_Lock.Read_Lock;
	 
	 if Coils (Offset) = LibModbus.C_FALSE then
	    Output := False;
	 else
	    Output := True;
	 end if;
	 
	 Coils_RW_Lock.Read_Unlock;
      end if;
   end Coil_Read;
   
   -----------------
   -- Coils_Write --
   -----------------
   
   procedure Coils_Write
     (Inputs : in Bool_Array;
      Offset : in Natural) is
   begin
      if Offset < Coils_Number then
	 
	 Coils_RW_Lock.Write_Lock;
	 
	 for Index in Inputs'Range loop
	    if Inputs (Index) then
	       Coils (Offset + Index - Inputs'First) := LibModbus.C_TRUE;
	    else
	       Coils (Offset + Index - Inputs'First) := LibModbus.C_FALSE;
	    end if;
	 end loop;
	 
	 Coils_RW_Lock.Write_Unlock;
      end if;
   end Coils_Write;

   ----------------
   -- Coil_Write --
   ----------------
   
   procedure Coil_Write
     (Input  : in Boolean;
      Offset : in Natural) is
   begin
      if Offset < Coils_Number then
	 
	 Coils_RW_Lock.Write_Lock;
	 if Input then
	    Coils (Offset) := LibModbus.C_TRUE;
	 else
	    Coils (Offset) := LibModbus.C_FALSE;
	 end if;
	 Coils_RW_Lock.Write_Unlock;
      end if;
   end Coil_Write;

   ----------------------------
   -- Inputs_Registers_Write --
   ----------------------------
   
   procedure Inputs_Registers_Write
     (Inputs : in Word_Array;
      Offset : in Natural) is
   begin
      if Offset < Input_Registers_Number then
	 
	 Input_Registers_RW_Lock.Write_Lock;
	 Input_Registers (Offset .. Offset + Inputs'Length - 1) := Inputs;
	 Input_Registers_RW_Lock.Write_Unlock;
      end if;
   end Inputs_Registers_Write;
   
   --------------------
   -- Registers_Read --
   --------------------
   
   procedure Registers_Read
     (Outputs : out Word_Array;
      Offset  : in Natural) is
   begin
      if Offset < Registers_Number then
	 
	 Registers_RW_Lock.Read_Lock;
	 Outputs := Registers (Offset .. Offset + Outputs'Length - 1);
	 Registers_RW_Lock.Read_Unlock;
      end if;
   end Registers_Read;
   
   ---------------------
   -- Registers_Write --
   ---------------------
   
   procedure Registers_Write
     (Inputs : in Word_Array;
      Offset : in Natural) is
   begin
      if Offset < Registers_Number then
	 
	 Registers_RW_Lock.Write_Lock;
	 Registers (Offset .. Offset + Inputs'Length - 1) := Inputs;
	 Registers_RW_Lock.Write_Unlock;
      end if;
   end Registers_Write;
   
   -----------------
   -- Get_Mapping --
   -----------------
   
   function Get_Mapping return LibModbus.Modbus_Mapping_Type is
   begin
      return My_Mapping;
   end Get_Mapping;
   
end Rx.Com.Modbus.Memories;
