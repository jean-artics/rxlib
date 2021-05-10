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

with Ada.Text_Io; use Ada.Text_Io;
with Rxrt.Logutils; use Rxrt.Logutils;

with Rxrt.Tlists;
with RxClock;

package body Rxrt.Tasks is
   
   Tsks : Tasks_Table.Table_Ptr renames Tasks_Table.Table;
   
   procedure New_Synchronous_Task (Tdescr : Task_Description_record);
   pragma Inline (New_Synchronous_Task);
   -- Create a synchronous task
   
   ----------------
   -- Initialize --
   ----------------
   
   procedure Initialize is
   begin
      -- Log_Line ("Initialize Begin");
      Tasks_Table.Init;
      Tasks_Table.Increment_Last;
      First_Valid_Task_Id := Tasks_Table.Last;
      
      Tlists.Initialize;
      
      for I in 1..Rxrt.Params.Max_Tasks loop
	 Tasks_Table.Table (I) := No_Task;
      end loop;
      
      -- Create the list of running tasks. This list is populated each instant,
      -- regarding the task kind and its running condition (Periodic, Contionnal
      
      Running_Tasks_List := Tlists.New_List;
      
      --Log_Line ("Initialize End");
   end Initialize;
   
   ------------------
   -- Create_Tasks --
   ------------------
   
   procedure Create_Tasks is
   begin
      Log_Line ("Create_Tasks Begin");
      Tasks_Table.Init;
      Tasks_Table.Increment_Last;
      First_Valid_Task_Id := Tasks_Table.Last;
      
      Tlists.Initialize;
      
      for I in Application_Tasks'Range loop
	 --  New_Synchronous_Task (Rxrt.params.Application_Tasks (I));
	 Initialize_Task (Last_Task_Id);
	 Set_State (Last_Task_Id, Ready);
      end loop;
      
      -- Create the list of running tasks. This list is populated each instant,
      -- regarding the task kind and its running condition (Periodic, Contionnal
      
      Running_Tasks_List := Tlists.New_List;
      
      --Log_Line ("Create_Tasks End");
   end Create_Tasks;
   
   -----------------
   -- Create_Task --
   -----------------
   
   procedure Create_Task
     (Tdescr : Task_Description_Record) is
   begin
      Put_Line ("Create_Task Begin Task => " & Tdescr.Name.all);
      
      New_Synchronous_Task (Tdescr);
      Initialize_Task (Last_Task_Id);
      Set_State (Last_Task_Id, Ready);
      
      Put_Line ("Create_Task End Id => " & Last_Task_Id'Img);
   end Create_Task;
   
   --------------------------
   -- New_Synchronous_Task --
   --------------------------
   
   procedure New_Synchronous_Task
     (Tdescr : Task_Description_Record) is
   begin
      Put_Line ("New_Synchronous_Task Begin");
      
      Tasks_Table.Increment_Last;
      Last_Task_Id := Tasks_Table.Last;
      Tasks_Table.Table (Last_Task_Id) := No_Task;
      
      Tasks_Table.Table (Last_Task_Id).Name          := Tdescr.Name;
      Tasks_Table.Table (Last_Task_Id).Inputs        := Tdescr.Inputs;
      Tasks_Table.Table (Last_Task_Id).Outputs       := Tdescr.Outputs;
      Tasks_Table.Table (Last_Task_Id).Data_Register := Tdescr.Data_Register;
      Tasks_Table.Table (Last_Task_Id).Initialize    := Tdescr.Initialize;
      Tasks_Table.Table (Last_Task_Id).Main          := Tdescr.Main;
      Tasks_Table.Table (Last_Task_Id).Task_Kind     := Tdescr.Task_Kind;
      Tasks_Table.Table (Last_Task_Id).Period        := Tdescr.Period;
      Tasks_Table.Table (Last_Task_Id).Run_Condition := Tdescr.Run_Condition;
      
      Tasks_Table.Table (Last_Task_Id).State := Ready;
      
      -- Log_Line ("New_Synchronous_Task End => " & Last_Task_Id'Img);
   end New_Synchronous_Task;
   
   ---------------------
   -- Initialize_Task --
   ---------------------
   
   procedure Initialize_Task (T : Task_Id) is
   begin
      Put_Line ("Initialize_Task Begin => " & T'Img);
      if Tsks (T).Initialize /= null then
	 Tsks (T).Initialize.all;
      end if;
      
      if Tsks (T).Data_Register /= null then
	 Tsks (T).Data_Register.all;
      end if;
      
      Set_Start_Time (T, RxClock.Clock);
      
      Put_Line ("Initialize_Task End");
   end Initialize_Task;
   
   ----------------------
   -- Initialize_Tasks --
   ----------------------
   
   procedure Initialize_Tasks is
   begin
      --Log_Line ("Initialize_Tasks Begin");
      
      -- Call all initialization tasks that must be run at this instant
      
      for I in Task_Id range 1..Tasks_Table.Last loop
	 Initialize_Task (I);
      end loop;
      
      --Log_Line ("Initialize_Tasks End");
   end Initialize_Tasks;
   
   -----------
   -- Cycle --
   -----------
   
   procedure Cycle (T : Task_Id) is
   begin
      Log_Line ("Cycle Begin");
      if Tsks (T).Inputs /= null then
	 Tsks (T).Inputs.all;
      end if;
      
      if Tsks (T).Main /= null then
	 Tsks (T).Main.all;
      end if;
	 
      if Tsks (T).Outputs /= null then
	 Tsks (T).Outputs.all;
      end if;
      Log_Line ("Cycle End");
   end Cycle;
   
   ---------------
   -- Task_Name --
   ---------------
   
   function Task_Name (T : Task_Id) return String is
   begin
      if T in First_Valid_Task_Id..Last_Task_Id then
	 return Tsks (T).Name.all;
      else
	 return "";
      end if;
   end Task_Name;

   -----------------------
   -- Task_Id_From_Name --
   -----------------------
   
   function Task_Id_From_Name (Name : String) return Task_Id is
   begin
      for T in First_Valid_Task_Id..Last_Task_Id loop
         if Name = Task_Name (T) then
            return T;
         end if;
      end loop;
      return No_Task_Id;
   end Task_Id_From_Name;
   
   ------------------
   -- Task_Inputs --
   ------------------
   
   function Task_Inputs (T : Task_Id) return Access_Procedure is
   begin
      return Tsks (T).Inputs;
   end Task_Inputs;
   
   ---------------------
   -- Set_Task_Inputs --
   ---------------------
   
   procedure Set_Task_Inputs
     (T : Task_Id;
      P : Access_Procedure) is
   begin
      Tsks (T).Inputs := P;
   end Set_Task_Inputs;
   
   ------------------
   -- Task_Outputs --
   ------------------
   
   function Task_Outputs (T : Task_Id) return Access_Procedure is
   begin
      return Tsks (T).Outputs;
   end Task_Outputs;
   
   ----------------------
   -- Set_Task_Outputs --
   ----------------------
   
   procedure Set_Task_Outputs
     (T : Task_Id;
      P : Access_Procedure) is
   begin
      Tsks (T).Outputs := P;
   end Set_Task_Outputs;
   
   ---------------
   -- Task_Init --
   ---------------
   
   function Task_Init (T : Task_Id) return Access_Procedure is
   begin
      return Tsks (T).Initialize;
   end Task_Init;
   
   -------------------
   -- Set_Task_Init --
   -------------------
   
   procedure Set_Task_Init
    (T : Task_Id;
     P : Access_Procedure) is
   begin
      Tsks (T).Initialize := P;
   end Set_Task_Init;
   
   ------------------------
   -- Task_Data_Register --
   ------------------------
   
   function Task_Data_Register (T : Task_Id) return Access_Procedure is
   begin
      return Tsks (T).Data_Register;
   end Task_Data_Register;
   
   ----------------------------
   -- Set_Task_Data_Register --
   ----------------------------
   
   procedure Set_Task_Data_Register
    (T : Task_Id;
     P : Access_Procedure) is
   begin
      Tsks (T).Data_Register := P;
   end Set_Task_Data_Register;
   
   ----------------
   -- Task_Entry --
   ----------------
   
   function Task_Entry (T : Task_Id) return Access_Procedure is
   begin
      return Tsks (T).Main;
   end Task_Entry;
   
   --------------------
   -- Set_Task_Entry --
   --------------------
   
   procedure Set_Task_Entry
     (T : Task_Id;
      P : Access_Procedure) is
   begin
      Tsks (T).Main := P;
   end Set_Task_Entry;
  
   -------------------
   -- Run_Condition --
   -------------------
   
   function Run_Condition (T : Task_Id) return Access_Boolean is
   begin
      return Tsks (T).Run_Condition;
   end Run_Condition;
   
   -----------------------
   -- Set_Run_Condition --
   -----------------------
   
   procedure Set_Run_Condition
     (T : Task_Id;
      C : Access_Boolean) is
   begin
      Tsks (T).Run_Condition := C;
   end Set_Run_Condition;
   
   ------------
   -- Period --
   ------------
   
   function Period (T : Task_Id) return Duration is
   begin
      return Tsks (T).Period;
   end Period;
   
   ----------------
   -- Set_Period --
   ----------------
   
   procedure Set_Period
     (T  : Task_Id;
      Dt : Duration) is
   begin
      Tsks (T).Period := Dt;
   end Set_Period;
   
   -----------------
   -- Elapse_Time --
   -----------------
   
   function Elapse_Time (T : Task_Id) return Duration is
   begin
      return Tsks (T).Elapse_Time;
   end Elapse_Time;
   
   ---------------------
   -- Set_Elapse_Time --
   ---------------------
   
   procedure Set_Elapse_Time
     (T  : Task_Id;
      Dt : Duration) is
   begin
      Tsks (T).Elapse_Time := Tsks (T).Elapse_Time + Dt;
   end Set_Elapse_Time;
   
   ----------------
   -- Start_Time --
   ----------------
   
   function Start_Time (T : Task_Id) return Duration is
   begin
      return Tsks (T).Start_Time;
   end Start_Time;
   
   --------------------
   -- Set_Start_Time --
   --------------------
   
   procedure Set_Start_Time
     (T    : Task_Id;
      Clck : Duration) is
   begin
      Tsks (T).Start_Time := Clck;
   end Set_Start_Time;
   
   -----------
   -- State --
   -----------
   
   function State (T : Task_Id) return Task_State is
   begin
      return Tsks (T).State;
   end State;
   
   ---------------
   -- Set_State --
   ---------------
   
   procedure Set_State 
     (T : Task_Id;
      S : Task_State) is
   begin 
      Tsks (T).State := S;
   end Set_State;
   
   ---------------
   -- Task_Kind --
   ---------------
   
   function Task_Kind (T : Task_Id) return Task_Kind_Type is
   begin
      return Tsks (T).Task_Kind;
   end Task_Kind;
   
   -------------------
   -- Set_Task_Kind --
   -------------------
   
   procedure Set_Task_Kind 
     (T : Task_Id;
      K : Task_Kind_Type) is
   begin 
      Tsks (T).Task_Kind := K;
   end Set_Task_Kind; 
   
   -------------
   -- In_List --
   -------------
   
   function In_List (Tsk : Task_Id) return Boolean is
   begin
      return Tsks (Tsk).List_Link /= No_Task_List_Id;
   end In_List;
   
   ---------------
   -- List_Link --
   ---------------
   
   function List_Link (Tsk : Task_Id) return Task_List_Id is
   begin
      return Tsks (Tsk).List_Link;
   end List_Link;
   
   -------------------
   -- Set_List_Link --
   -------------------
   
   procedure Set_List_Link
     (Tsk : Task_Id;
      L   : Task_List_Id) is
   begin
      Tsks (Tsk).List_Link := L;
   end Set_List_Link;
   
   --------------------------
   -- Update_Running_Tasks --
   --------------------------
   
   procedure Update_Running_Tasks is
      Elapse    : Duration;
      Condition : Access_Boolean;
   begin
      Log_Line ("Update_Running_Tasks Begin");
      for I in First_Valid_Task_Id..Last_Task_Id loop
	 if State (I) = Ready then
	    if Task_Kind (I) = Unconditionnal_Task then
	       Tlists.Append (I, Running_Tasks_List);
	    
	    elsif Task_Kind (I) = Periodic_Task then
	       Elapse := RxClock.Clock - Start_Time (I); 
	       if Elapse >= Period (I) then
		  Tlists.Append (I, Running_Tasks_List);
		  Set_Start_Time (I, RxClock.Clock);
	       end if;
	       Set_Elapse_Time (I, Elapse);
	    end if;
	    
	 elsif Task_Kind (I) = Conditionnal_Task then
	    Condition := Run_Condition (I);
	    if Condition /= null and then Condition.all then
	       Tlists.Append (I, Running_Tasks_List);
	    end if;
	 end if;
      end loop;
      Log_Line ("Update_Running_Tasks End");
   end Update_Running_Tasks;
   
   -------------------------
   -- Reset_Running_Tasks --
   -------------------------
   
   procedure Reset_Running_Tasks is
      Tsk : Task_Id;
      Nxt : Task_Id;
   begin
      Log_Line ("Reset_Running_Tasks Begin");
      if Tlists.Is_Non_Empty_List (Running_Tasks_List) then
	 Tsk := Tlists.First (Running_Tasks_List);
	 while Tsk /= No_Task_Id loop
	    Nxt := Tlists.Next (Tsk);
	    Tlists.Remove (Tsk);
	    Tsk := Nxt;
	 end loop;
      end if;
      Log_Line ("Reset_Running_Tasks End");
   end Reset_Running_Tasks;
   
   ---------------
   -- Run_Tasks --
   ---------------
   
   procedure Run_Tasks is
      Tsk : Task_Id;
   begin
      -- Call all application tasks that must be run at this instant
      
      if Tlists.Is_Non_Empty_List (Running_Tasks_List) then
	 Tsk := Tlists.First (Running_Tasks_List);
	 while Tsk /= No_Task_Id loop
	    Cycle (Tsk);
	    Tlists.Next (Tsk);
	 end loop;
      end if;
      -- Put_Line ("Run_Tasks End");
   end Run_Tasks;
   
   ------------------------
   -- Task_State_Machine --
   ------------------------
   
   procedure To_Run_State (T : Task_Id) is
      S : Task_State := Tsks (T).State;
   begin
      if S = Ready or S = Stepping or S = Suspended then
	 S := Running;
      else
	 -- Error
	 null;
      end if;
   end To_Run_State;
   
   procedure To_Suspend_State (T : Task_Id) is
      S : Task_State := Tsks (T).State;
   begin
      if S = Running or S = Stepping then
	 S := Stepping;
      else
	 -- Error
	 null;
      end if;
   end To_Suspend_State;
   
   procedure To_Stepping_State (T : Task_Id) is
      S : Task_State := Tsks (T).State;
   begin
      if S = Ready or S = Suspended or S = Running then
	 S := Stepping;
      else
	 -- Error
	 null;
      end if;
   end To_Stepping_State;
   
   procedure To_Abort_State (T : Task_Id) is
      S : Task_State := Tsks (T).State;
   begin
      S := Aborted;
   end To_Abort_State;
   
   procedure To_Ready_State (T : Task_Id) is
      S : Task_State := Tsks (T).State;
   begin
      if S = Initial then
	 S := Ready;
	 
      else
	 -- Error
	 null;
      end if;
   end To_Ready_State;
   
   procedure To_Initial_State (T : Task_Id) is
      S : Task_State := Tsks (T).State;
   begin
      S := Initial;
   end To_Initial_State;
   
end Rxrt.Tasks;
