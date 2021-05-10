
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

package body Rx.Sys.Generic_Dual_Port_Memory is

   protected body Inputs_Dual_Port_Memory_Area is

      procedure Set_Data  (Data_In : in Inputs_Type) is
      begin
         Data := Data_In;
      end Set_Data;

      function Get_Data return Inputs_Type is
      begin
         return Data;
      end Get_Data;

   end Inputs_Dual_Port_Memory_Area;

   protected body Outputs_Dual_Port_Memory_Area is

      procedure Set_Data  (Data_In : in Outputs_Type) is
      begin
         Data := Data_In;
      end Set_Data;

      function Get_Data return Outputs_Type is
      begin
         return Data;
      end Get_Data;

   end Outputs_Dual_Port_Memory_Area;

end Rx.Sys.Generic_Dual_Port_Memory;
