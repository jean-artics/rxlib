
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

--with Ada.Text_Io; use Ada.Text_Io;

with Rxrt.Logutils; use Rxrt.Logutils;

with RxClock;
with Rxrt.Tasks;

package body Rxrt.Handler is
   
   -------------------------
   -- Initialize_Run_Time --
   -------------------------
   
   procedure Initialize_Run_Time is
   begin
      -- Create_Loginfos_File ("rxrtlog.txt");
      Log_Line ("Initialize_Run_Time Begin");
      
      -- Set_Applications_Tasks (Tasks);
      
      -- Initialize Global Clock
      
      -- Rxrt.Data_Infos.Initialize;
      
      Rxrt.Initialize_Clock;
      
      -- Create the tasks
      
      Rxrt.Tasks.Initialize;      
      
      Log_Line ("Initialize_Run_Time End");
   end Initialize_Run_Time;
   
   --------------------
   -- Pre_Processing --
   --------------------
   
   procedure Pre_Processing is
   begin
      Log_Line ("Pre_Processing Begin");
      -- Update Global Clock
      
      Rxrt.Update_Clock;
      
      --Refresh_Intputs_Connectors;
      
      -- Update the tasks clock and tranders them to the running list is the
      -- waiting time bteween two runs is terminated
      
      Rxrt.Tasks.Update_Running_Tasks;
      
      Log_Line ("Pre_Processing End");
   end Pre_Processing;
   
   ---------------------
   -- Post_Processing --
   ---------------------
   
   procedure Post_Processing is
   begin
      Log_Line ("Post_Processing Begin");
      -- Reset the running tasks list
      
      --Refresh_Outputs_Connectors;
      
      Rxrt.Tasks.Reset_Running_Tasks;
      
      Log_Line ("Post_Processing End");
   end Post_Processing;
   
   ----------------------------
   -- Initialize_Application --
   ----------------------------
   
   procedure Initialize_Application is
   begin
      -- Initialize all tasks declared by user
      null;
   end Initialize_Application;
   
   ---------
   -- Run --
   ---------
   
   procedure Run is
   begin
      Log_Line ("Runtime Run Begin");
      -- Do all pre processing before calling application
      
      Pre_Processing;
      
      -- Call all application tasks that must be run at this instant
      
      Rxrt.Tasks.Run_Tasks;
      
      -- Do all post processing after the application has run
      
      Post_Processing;
      
      Log_Line ("Runtime Run End");
   end Run;
   
   ----------------
   -- master_Run --
   ----------------
   
   procedure Master_Run is
   begin
      Log_Line ("Runtime Master_Run Begin");
      -- Do all pre processing before calling application
      
      Pre_Processing;
	 
      -- Call all application tasks that must be run at this instant
      
      Rxrt.Tasks.Run_Tasks;
      
      -- Do all post processing after the application has run
      
      Post_Processing;
      
      Log_Line ("Runtime Master_Run End");
   end Master_Run;
   
   --------------------------------
   -- Refresh_Outputs_Connectors --
   --------------------------------
   
   procedure Refresh_Outputs_Connectors is
   begin
      --Global_Lock.Lock;
--        for I in 1 .. Connectros_Count loop
--  	 Ms_Outputs (Connectros (I));
--        end loop;
--Global_Lock.Unlock;
null;
   end Refresh_Outputs_Connectors;
   
   -------------------------------
   -- Refresh_inputs_Connectors --
   -------------------------------
   
   procedure Refresh_Inputs_Connectors is
   begin
--        Global_Lock.Lock;
--        for I in 1 .. Connectros_Count loop
--  	 Ms_Inputs (Connectros (I));
--        end loop;
--        Global_Lock.Unlock;
null;   end Refresh_Inputs_Connectors;
   
end Rxrt.Handler;
