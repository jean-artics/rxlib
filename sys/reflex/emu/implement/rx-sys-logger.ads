
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

with Ada.Unchecked_Deallocation;
with Ada.Containers.Doubly_Linked_Lists;

package Rx.Sys.Logger is

   type Log_Level_Type is
     (Level_Error,
      Level_Warning,
      Level_Info,
      Level_Verbose);

   type Log_Data is private;

   protected type Logger_Type is

      function Get_Level return Log_Level_Type;

      procedure Set_Level (Log_Level : in Log_Level_Type);

      procedure Put
        (Who       : in String;
         What      : in String;
         Log_Level : in Log_Level_Type := Level_Error);

      function Get_First return String;

      procedure Delete_First;

      function Is_Empty return Boolean;

   private

      The_Log_Level : Log_Level_Type := Level_Error;
      Log_List      : Log_Data;
   end Logger_Type;

private

   type Log_String is access String;

   procedure Free_Log_String is new Ada.Unchecked_Deallocation
     (Object => String, Name => Log_String);

   package Log_Items is new Ada.Containers.Doubly_Linked_Lists
     (Element_Type => Log_String);
   use type Log_Items.Cursor;

   type Log_Data is new Log_Items.List with null record;

end Rx.Sys.Logger;
