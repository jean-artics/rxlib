
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
   pragma Convention (Ada, Task_State);
   -- The different states of a synchronous task
   
   procedure Create_Task (Tdescr : Task_Description_Record);
   pragma Import (Ada, Create_Task, "Rxrt_Create_Task");
   
   procedure Initialize_Task (T : Task_Id);
   pragma Import (Ada, Initialize_Task, "Rxrt_Initialize_Task");
   -- Initialize the synchronous task
   
   procedure Cycle (T : Task_Id);
   pragma Import (Ada, Cycle, "Rxrt_Cycle");
   -- To do one cycle off the synchronous task
  
   function Task_Name (T : Task_Id) return String_Ptr;
   pragma Import (Ada, Task_Name, "Rxrt_Task_Name");
   -- Return the name of the task T
   
   function Task_Id_From_Name (Name : String_Ptr) return Task_Id;
   pragma Import (Ada, Task_Id_From_Name, "Rxrt_Task_Id_From_Name");
   -- Return the corresponding Id of Task
   
   function Task_Inputs (T : Task_Id) return Access_Procedure;
   procedure Set_Task_Inputs
     (T : Task_Id;
      P : Access_Procedure);
   pragma Import (Ada, Task_Inputs, "Rxrt_Task_Inputs");
   pragma Import (Ada, Set_Task_Inputs, "Rxrt_Set_Task_Inputs");
   
   function Task_Outputs (T : Task_Id) return Access_Procedure;
   procedure Set_Task_Outputs
     (T : Task_Id;
      P : Access_Procedure);
   pragma Import (Ada, Task_Outputs, "Rxrt_Task_Outputs");
   pragma Import (Ada, Set_Task_Outputs, "Rxrt_Set_Task_Outputs");
  
   function Task_Data_Register (T : Task_Id) return Access_Procedure;
   procedure Set_Task_Data_Register
     (T : Task_Id;
      P : Access_Procedure);
   pragma Import (Ada, Task_Data_Register, "Rxrt_Task_Data_Register");
   pragma Import (Ada, Set_Task_Data_Register, "Rxrt_Set_Task_Data_Register");
  
   function Task_Init (T : Task_Id) return Access_Procedure;
   procedure Set_Task_Init
     (T : Task_Id;
      P : Access_Procedure);
   pragma Import (Ada, Task_Init, "Rxrt_Init");
   pragma Import (Ada, Set_Task_Init, "Rxrt_Set_Task_Init");
  
   function Task_Entry (T : Task_Id) return Access_Procedure;
   procedure Set_Task_Entry
     (T : Task_Id;
      P : Access_Procedure);
   pragma Import (Ada, Task_Entry, "Rxrt_Task_Entry");
   pragma Import (Ada, Set_Task_Entry, "Rxrt_Set_Task_Entry");
  
   function Run_Condition (T : Task_Id) return Access_Boolean;
   procedure Set_Run_Condition
     (T : Task_Id;
      C : Access_Boolean);
   pragma Import (Ada, Run_Condition, "Rxrt_Run_Condition");
   pragma Import (Ada, Set_Run_Condition, "Rxrt_Set_Run_Condition");
   
   function Period (T : Task_Id) return Duration;
   procedure Set_Period
     (T  : Task_Id;
      Dt : Duration);
   pragma Import (Ada, Period, "Rxrt_Period");
   pragma Import (Ada, Set_Period, "Rxrt_Set_Period");
   -- Period ellasped between two cycles
   
   function Elapse_Time (T : Task_Id) return Duration;
   procedure Set_Elapse_Time
     (T  : Task_Id;
      Dt : Duration);
   pragma Import (Ada, Elapse_Time, "Rxrt_Elapse_Time");
   pragma Import (Ada, Set_Elapse_Time, "Rxrt_Set_Elapse_Time");
   -- Logic global time from the start of the machine
   
   function Start_Time (T : Task_Id) return Duration;
   procedure Set_Start_Time
     (T    : Task_Id;
      Clck : Duration);
   pragma Import (Ada, Start_Time, "Rxrt_Start_Time");
   pragma Import (Ada, Set_Start_Time, "Rxrt_Set_Start_Time");
   -- The last Instant time the task has ruun
   
   function State (T : Task_Id) return Task_State;
   procedure Set_State 
     (T : Task_Id;
      S : Task_State);
   pragma Import (Ada, State, "Rxrt_State");
   pragma Import (Ada, Set_State, "Rxrt_Set_State");
   -- Current task state
   
   function Task_Kind (T : Task_Id) return Task_Kind_Type;
   procedure Set_Task_Kind 
     (T : Task_Id;
      K : Task_Kind_Type);
   pragma Import (Ada, Task_Kind, "Rxrt_Task_Kind");
   pragma Import (Ada, Set_Task_Kind , "Rxrt_Set_Task_Kind");
   -- The kind of the task
   
end Rxrt.Tasks;
