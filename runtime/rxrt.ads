
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

with System; use System;

package Rxrt is
   
   type Access_Procedure is access procedure;
   type Access_Boolean   is access all Boolean;
   pragma Convention (C, Access_Procedure);
   pragma Convention (C, Access_Boolean);
   
   type Task_Kind_Type is
     (Periodic_Task,
      Conditionnal_Task,
      Unconditionnal_Task);
   
   Max_Tasks : Integer := 100;
   
   subtype Task_Id is Integer range 1..Max_Tasks;
   
   type String_Ptr is access all String;
   
   type Task_Description_Record is record
      Name : String_Ptr;
      -- The task name
      
      Inputs : System.Address;
      -- The inputs of the synchronous machine
      
      Outputs : System.Address;
      -- The outputs of the synchronous machine
      
      Data_Register : System.Address;
      -- Initialization of the synchronous machine
      
      Initialize : System.Address;
      -- Initialization of the synchronous machine
      
      Main : System.Address;
      -- The cyclic Main procedure of the synchronous machine
      
      Task_Kind : Task_Kind_Type;
      
      Period : Duration;
      -- Period of the task
      
      Run_Condition : Access_Boolean;
      -- Condition to run task
      
   end record;
   pragma Convention (C, Task_Description_Record);
   
   type Task_Description_Ptr is access all Task_Description_Record;
   
   No_Task_Description : constant Task_Description_Record := 
     (Name          => null,
      Inputs        => System.Null_Address,
      Outputs       => System.Null_Address,
      Data_Register => System.Null_Address,
      Initialize    => System.Null_Address,
      Main          => System.Null_Address,
      Task_Kind     => Periodic_Task,
      Period        => 0.1,
      Run_Condition => null);
 
   -- The table of tasks describing all applications tasks
   
   type Application_Tasks_Array is array
     (Positive range <>) of Task_Description_Record;
   
   type Application_Tasks_Ptr is access all Application_Tasks_Array;
   
   procedure Set_Applications_Tasks (Tasks : Application_Tasks_Ptr);
   pragma Import (Ada, Set_Applications_Tasks, "Rxrt_Set_Applications_Tasks");
   
   procedure Initialize_Run_Time;
   -- Do the initioalizzation of all modules of the reflex run time. 
   
   procedure Initialize_Application;
   pragma Import (Ada, Initialize_Application, "Rxrt_Initialize_Application");
   -- Call to initialize the application. The application tasks are created 
   -- here
   
   procedure Run;
   pragma Import (Ada, Run, "Rxrt_Run");
   -- Start the reflex approgram
   
private
   
   procedure Do_Run_Time_Initialize;
   pragma Import (Ada, Do_Run_Time_Initialize, "Rxrt_Initialize_Run_Time");
   
end Rxrt;
