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

with Interfaces.C.Strings; use Interfaces.C.Strings;
with Rxrt.Table;
with Rxrt.Params; use Rxrt.Params;

package Rxrt.Tasks is
   
   --  type Access_Procedure is access procedure;
   
   type Task_State is 
     (Initial,
      Ready,
      Stopped,
      Suspended,
      Stepping,
      Running,
      Aborted);
   pragma Convention (C, Task_State);
   -- The different states of a synchronous task
   
   procedure Initialize;
   -- Initialize Taks module
   
   procedure Create_Tasks;
   -- Create all synchronous tasks.
   
   procedure Initialize_Tasks;
   -- Initialize all tasks
   
   procedure Create_Task
     (Tdescr : Task_Description_Record);
   
   procedure Initialize_Task (T : Task_Id);
   -- Initialize the synchronous task
   
   procedure Cycle (T : Task_Id);
   -- To do one cycle off the synchronous task
  
   function Task_Name (T : Task_Id) return String;
   -- Return the name of the task 
   
   function Task_Id_From_Name (Name : String) return Task_Id;
   -- Return the corresponding Id of Task
   
   function Task_Inputs (T : Task_Id) return Access_Procedure;
   procedure Set_Task_Inputs
     (T : Task_Id;
      P : Access_Procedure);
   
   function Task_Outputs (T : Task_Id) return Access_Procedure;
   procedure Set_Task_Outputs
     (T : Task_Id;
      P : Access_Procedure);
  
   function Task_Data_Register (T : Task_Id) return Access_Procedure;
   procedure Set_Task_Data_Register
     (T : Task_Id;
      P : Access_Procedure);
  
   function Task_Init (T : Task_Id) return Access_Procedure;
   procedure Set_Task_Init
     (T : Task_Id;
      P : Access_Procedure);
  
   function Task_Entry (T : Task_Id) return Access_Procedure;
   procedure Set_Task_Entry
     (T : Task_Id;
      P : Access_Procedure);
  
   function Run_Condition (T : Task_Id) return Access_Boolean;
   procedure Set_Run_Condition
     (T : Task_Id;
      C : Access_Boolean);
   
   function Period (T : Task_Id) return Duration;
   procedure Set_Period
     (T  : Task_Id;
      Dt : Duration);
   
   -- Period ellasped between two cycles
   function Elapse_Time (T : Task_Id) return Duration;
   procedure Set_Elapse_Time
     (T  : Task_Id;
      Dt : Duration);
   -- Logic global time from the start of the machine
   
   function Start_Time (T : Task_Id) return Duration;
   procedure Set_Start_Time
     (T    : Task_Id;
      Clck : Duration);
   -- The last Instant time the task has ruun
   
   function State (T : Task_Id) return Task_State;
   procedure Set_State 
     (T : Task_Id;
      S : Task_State);
   -- Current task state
   
   function Task_Kind (T : Task_Id) return Task_Kind_Type;
   procedure Set_Task_Kind 
     (T : Task_Id;
      K : Task_Kind_Type);
   -- The kind of the task
   
   function In_List (Tsk : Task_Id) return Boolean;
   -- Return True if Tsk is in a list
   
   function List_Link (Tsk : Task_Id) return Task_List_Id;
   -- Return The list to were the task is linked
   
   procedure Set_List_Link
     (Tsk : Task_Id;
      L   : Task_List_Id);
   -- Task is linked in list L
   
   procedure Update_Running_Tasks;
   
   procedure Reset_Running_Tasks;
   
   procedure Run_Tasks;
   
private
   
   Running_Tasks_List : Task_List_Id;
   
   First_Valid_Task_Id : Task_Id;
  
   Last_Task_Id : Task_Id := No_Task_Id;
   
   type Task_Record is record
      Name : String_Ptr;
      -- The task name
      
      List_Link : Task_List_Id;
      --  List to wicht the task belongs
      
      Parent : Task_Id;
      -- Parent of this task
      
      Run_Condition : Access_Boolean;
      -- Period ellasped between two cycles
      
      Period : Duration;
      -- Period ellasped between two cycles
      
      Elapse_Time : Duration;
      -- Logic global time from the start of the machine
      
      Start_Time : Duration;
      -- Logic global time from the start of the machine
      
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
      -- Task type
      
      State : Task_State;
      -- State of the synchronous task.
   end record;
   
   No_Task : Task_Record :=
     (Name          => null,
      List_Link     => No_Task_List_Id,
      Parent        => No_Task_Id,
      Run_Condition => null,
      Period        => 0.0,
      Elapse_Time   => 0.0,
      Start_Time    => 0.0,
      Inputs        => null,
      Outputs       => null,
      Data_Register => null,
      Initialize    => null,
      Main          => null,
      Task_Kind     => Periodic_Task,
      State         => Initial);
   
   package Tasks_Table is new Rxrt.Table.Table
     (Table_Component_Type => Task_Record,
      Table_Index_Type     => Task_Id'Base,
      Table_Low_Bound      => First_Task_Id,
      Table_Initial        => Rxrt.Params.Tasks_Initial,
      Table_Increment      => Tasks_Increment,
      Table_Name           => "Tasks");
   
   Initial_Taks    : Task_List_Id;
   Ready_Tasks     : Task_List_Id;
   Stopped_Tasks   : Task_List_Id;
   Suspended_Tasks : Task_List_Id;
   Stepping_Tasks  : Task_List_Id;
   Aborted_Tasks   : Task_List_Id;
   
   -- The state machine of tasks state is
   --
   --         +-----------------------------+
   --         |                             |
   --         |                     +-----> Aborted
   --         |                     |           ^
   --        \|/                    |           |
   --     Initial --> Ready -----> Runnig --> Suspend
   --                  |           ^  ^         |
   --                  |           |  |         |
   --                  |           |  +---------+
   --                 \|/          |            |
   --               Stepped -------+            |
   --                  ^                        |
   --                  |                        |
   --                  +------<--------->-------+
   
   ------------------------
   -- Task_State_Machine --
   ------------------------
   
   procedure To_Run_State (T : Task_Id);
   
   procedure To_Suspend_State (T : Task_Id);
   
   procedure To_Stepping_State (T : Task_Id);
   
   procedure To_Abort_State (T : Task_Id);
   
   procedure To_Ready_State (T : Task_Id);
   
   procedure To_Initial_State (T : Task_Id);
   
   pragma Export (Ada, Initialize_Task, "Rxrt_Initialize_Task");
   pragma Export (Ada, Create_Task, "Rxrt_Create_Task");
   pragma Export (Ada, Cycle, "Rxrt_Cycle");
   pragma Export (Ada, Task_Name, "Rxrt_Task_Name");
   pragma Export (Ada, Task_Id_From_Name, "Rxrt_Task_Id_From_Name");
   pragma Export (Ada, Task_Inputs, "Rxrt_Task_Inputs");
   pragma Export (Ada, Set_Task_Inputs, "Rxrt_Set_Task_Inputs");
   pragma Export (Ada, Task_Outputs, "Rxrt_Task_Outputs");
   pragma Export (Ada, Set_Task_Outputs, "Rxrt_Set_Task_Outputs");
   pragma Export (Ada, Task_Data_Register, "Rxrt_Task_Data_Register");
   pragma Export (Ada, Set_Task_Data_Register, "Rxrt_Set_Task_Data_Register");
   pragma Export (Ada, Task_Init, "Rxrt_Init");
   pragma Export (Ada, Set_Task_Init, "Rxrt_Set_Task_Init");
   pragma Export (Ada, Task_Entry, "Rxrt_Task_Entry");
   pragma Export (Ada, Set_Task_Entry, "Rxrt_Set_Task_Entry");
   pragma Export (Ada, Run_Condition, "Rxrt_Run_Condition");
   pragma Export (Ada, Set_Run_Condition, "Rxrt_Set_Run_Condition");
   pragma Export (Ada, Period, "Rxrt_Period");
   pragma Export (Ada, Set_Period, "Rxrt_Set_Period");
   pragma Export (Ada, Elapse_Time, "Rxrt_Elapse_Time");
   pragma Export (Ada, Set_Elapse_Time, "Rxrt_Set_Elapse_Time");
   pragma Export (Ada, Start_Time, "Rxrt_Start_Time");
   pragma Export (Ada, Set_Start_Time, "Rxrt_Set_Start_Time");
   pragma Export (Ada, State, "Rxrt_State");
   pragma Export (Ada, Set_State, "Rxrt_Set_State");
   pragma Export (Ada, Task_Kind, "Rxrt_Task_Kind");
   pragma Export (Ada, Set_Task_Kind , "Rxrt_Set_Task_Kind");
   
end Rxrt.Tasks;
