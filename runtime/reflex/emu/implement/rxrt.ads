   

-----------------------------------------------------------------------
--                       Reflex Run Time                             --
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

package Rxrt is
   
   type Access_Procedure is access procedure;
   type Access_Boolean   is access all Boolean;
   pragma Convention (C, Access_Procedure);
   pragma Convention (C, Access_Boolean);
   
   
   type Task_Kind_Type is
     (Periodic_Task,
      Conditionnal_Task,
      Unconditionnal_Task,
      System_Task);
   
   type String_Ptr is access all String;
   
   type Task_Description_Record is record
      Name : String_Ptr;
      -- The task name
      
      Inputs : Access_Procedure;
      -- The inputs of the synchronous machine
      
      Outputs : Access_Procedure;
      -- The outputs of the synchronous machine
      
      Data_Register : Access_Procedure;
      -- Initialization of the synchronous machine
      
      Initialize : Access_Procedure;
      -- Initialization of the synchronous machine
      
      Main : Access_Procedure;
      -- The cyclic Main procedure of the synchronous machine
      
      Task_Kind : Task_Kind_Type;
      
      Period : Duration;
      -- Period of the task
      
      Run_Condition : Access_Boolean;
      -- Condition to run task
      
   end record;
   -- pragma Convention (C, Task_Description_Record);
   
   type Task_Description_Ptr is access all Task_Description_Record;
   
   No_Task_Description : constant Task_Description_Record := 
     (Name          => null,
      Inputs        => null,
      Outputs       => null,
      Data_Register => null,
      Initialize    => null,
      Main          => null,
      Task_Kind     => Periodic_Task,
      Period        => 0.1,
      Run_Condition => null);
 
   -- The table of tasks describing all applications tasks
   
   type Application_Tasks_Array is array
     (Positive range <>) of Task_Description_Record;
   
   type Application_Tasks_Ptr is access Application_Tasks_Array;
   --  pragma Convention (C, Application_Tasks_Ptr);
   
   procedure Set_Applications_Tasks (Tasks : Application_Tasks_Ptr);
   pragma Export (Ada, Set_Applications_Tasks, "Rxrt_Set_Applications_Tasks");
   
private
   Application_Tasks : Application_Tasks_Ptr := null;
      
   Tick_Unit : constant Duration;
   pragma Import (Ada, Tick_Unit,  "Rx_Tick_Unit");
   
   The_Tick : Duration;
   pragma Import (Ada, The_Tick,  "Rx_The_Tick");
   
   procedure Initialize_Clock (Tick : Duration := Tick_Unit);
   pragma Import (Ada, Initialize_Clock, "Rx_Initialize_Clock");
   -- This procedure is called and the run time initialization instant
   
   procedure Update_Clock (Tick : Duration := The_Tick);
   pragma Import (Ada, Update_Clock, "Rx_Update_Clock");
   -- Must be called by the run time during the pre porcessing phase to update
   -- the global clock of the run time
   
end Rxrt;
