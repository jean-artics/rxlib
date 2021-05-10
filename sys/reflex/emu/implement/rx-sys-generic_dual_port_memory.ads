-----------------------------------------------------------------------
--                         Reflex Library                            --
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

generic
   type Inputs_Type is private;
   type Outputs_Type is private;

package Rx.Sys.Generic_Dual_Port_Memory is

   protected type Inputs_Dual_Port_Memory_Area is

      procedure Set_Data (Data_In : in Inputs_Type);

      function Get_Data return Inputs_Type;

   private
      Data : Inputs_Type;
   end Inputs_Dual_Port_Memory_Area;

   protected type Outputs_Dual_Port_Memory_Area is

      procedure Set_Data (Data_In : in Outputs_Type);

      function Get_Data return Outputs_Type;

   private
      Data : Outputs_Type;
   end Outputs_Dual_Port_Memory_Area;

   type Dual_Port_Memory is record
      Inputs  : Inputs_Dual_Port_Memory_Area;
      Outputs : Outputs_Dual_Port_Memory_Area;
   end record;

   type Dual_Port_Memory_Access is access all Dual_Port_Memory;

end Rx.Sys.Generic_Dual_Port_Memory;
