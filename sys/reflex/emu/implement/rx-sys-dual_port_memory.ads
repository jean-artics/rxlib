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

with Rx.Com; use Rx.Com;

package Rx.Sys.Dual_Port_Memory is

   protected type Bool_Dual_Port_Memory_Area (First, Last : Natural) is

      procedure Set_Data
        (Data_In : in Bool_Array;
         Offset  : in Natural);

      function Get_Data
        (Offset  : in Natural;
         Number  : in Natural) return Bool_Array;

   private
      Data : Bool_Array (First .. Last) := (others => False);
   end Bool_Dual_Port_Memory_Area;

   type Bool_Dual_Port_Memory (First, Last : Natural) is
      record
         Inputs : Bool_Dual_Port_Memory_Area
           (First => First,
            Last  => Last);

         Outputs : Bool_Dual_Port_Memory_Area
           (First => First,
            Last  => Last);
      end record;

   type Bool_Dual_Port_Memory_Access is access all Bool_Dual_Port_Memory;

   protected type Word_Dual_Port_Memory_Area (First, Last : Natural) is

      procedure Set_Data
        (Data_In : in Word_Array;
         Offset  : in Natural);
      function Get_Data
        (Offset  : in Natural;
         Number  : in Natural) return Word_Array;

   private
      Data : Word_Array (First .. Last) := (others => 0);
   end Word_Dual_Port_Memory_Area;

   type Word_Dual_Port_Memory (First, Last : Natural) is
      record
         Inputs : Word_Dual_Port_Memory_Area
           (First => First,
            Last  => Last);

         Outputs : Word_Dual_Port_Memory_Area
           (First => First,
            Last  => Last);
      end record;

   type Word_Dual_Port_Memory_Access is access all Word_Dual_Port_Memory;

end Rx.Sys.Dual_Port_Memory;
