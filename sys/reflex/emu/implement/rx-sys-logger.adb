
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

with Ada.Calendar.Formatting;

package body Rx.Sys.Logger is

   protected body Logger_Type is
      
      ---------------
      -- Get_Level --
      ---------------
      
      function Get_Level return Log_Level_Type is
      begin
         return The_Log_Level;
      end Get_Level;
      
      ---------------
      -- Set_Level --
      ---------------
      
      procedure Set_Level (Log_Level : Log_Level_Type) is
      begin
         The_Log_Level := Log_Level;
      end Set_Level;
      
      ---------
      -- Put --
      ---------
      
      procedure Put
        (Who  : in String;
         What : in String;
         Log_Level : in Log_Level_Type := Level_Error) is

         Log_Time : constant Ada.Calendar.Time := Ada.Calendar.Clock;
         Log_Item : Log_String;
      begin
         if Log_Level > The_Log_Level then
            return;
         end if;

         Log_Item := new String'
           (Ada.Calendar.Formatting.Image
              (Date                  => Log_Time,
               Include_Time_Fraction => True) 
            & " => " & Who & " : " & What);

         -- Time_Zone             => The_Time_Offset)

         Log_List.Append (Log_Item);
      end Put;
      
      ---------------
      -- Get_First --
      ---------------
      
      function Get_First return String is
      begin
         return Log_List.First_Element.all;
      end Get_First;
      
      ------------------
      -- Delete_First --
      ------------------
      
      procedure Delete_First is 
         Log_Item : Log_String;
      begin
         Log_Item := Log_List.First_Element;
         Free_Log_String (Log_Item);
         Log_List.Delete_First;
      end Delete_First;
      
      --------------
      -- Is_Empty --
      --------------
      
      function Is_Empty return Boolean is
      begin
         return Log_List.Is_Empty;
      end Is_Empty;

   end Logger_Type;

end Rx.Sys.Logger;
