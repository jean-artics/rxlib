-----------------------------------------------------------------------
--                       Reflex Run Time                             --
--                                                                   --
--              Copyright (C) 2012-2017, Artics                      --
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

package Rxrt.Params is

   Max_Tasks : Integer := 100;

   Max_Tasks_List : Integer := 1000;
   
   User_Tasks_Count : Positive := 3;
   
  subtype Task_Id is Integer range 1..Max_Tasks;

  subtype Task_List_Id is Integer range 1..Max_Tasks_List;
  
  First_Task_Id       : constant Task_Id := Task_Id'First;
  First_Task_List_Id  : constant Task_List_Id := Task_List_Id'First;
  
  No_Task_Id      : constant Task_Id      := First_Task_Id;
  No_Task_List_Id : constant Task_List_Id := First_Task_List_Id;
  
  Tasks_Initial   : constant := 100;
  Tasks_Increment : constant := 10;
  Lists_Initial   : constant := 100;
  Lists_Increment : constant := 10;
  
end Rxrt.Params;
