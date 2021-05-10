-----------------------------------------------------------------------
--                          Reflex Library                           --
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

package body Rx.Sys.Dual_Port_Memory is

   protected body Bool_Dual_Port_Memory_Area is

      procedure Set_Data
        (Data_In : in Bool_Array;
         Offset  : in Natural) is
	 
         Offset2 : Natural := Offset;
      begin
         --  Data (Offset .. Offset + Data_In'Length - 1) := Data_In;
         Data (Offset2 .. Offset2 + Data_In'Length - 1) := Data_In;
      end Set_Data;

      function Get_Data
        (Offset  : in Natural;
         Number  : in Natural) return Bool_Array is
      begin
         return Data (Offset .. Offset + Number - 1);
      end Get_Data;

   end Bool_Dual_Port_Memory_Area;

   protected body Word_Dual_Port_Memory_Area is

      procedure Set_Data
        (Data_In : in Word_Array;
         Offset  : in Natural) is
         Offset2 : Natural := Offset;
      begin
         --  Data (Offset .. Offset + Data_In'Length - 1) := Data_In;
         Data (Offset2 .. Offset2 + Data_In'Length - 1) := Data_In;
      end Set_Data;

      function Get_Data
        (Offset  : in Natural;
         Number  : in Natural) return Word_Array is
      begin
         return Data (Offset .. Offset + Number - 1);
      end Get_Data;

   end Word_Dual_Port_Memory_Area;

end Rx.Sys.Dual_Port_Memory;
