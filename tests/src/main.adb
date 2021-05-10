-----------------------------------------------------------------------
--                       Reflex Library                              --
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
-----------------------------------------------------------------------

with Ada.Text_Io; use Ada.Text_Io;

with System; use System;

with Rxrt; use Rxrt;
with Rxrt.Tasks; use Rxrt.Tasks;
with Rxrt.RxClock; use Rxrt.RxClock;

-- <change>
with Mast_Section;
with Simul; use Simul;
-- <change end>

package body Main is
   
   -- <change>
   -- Liste des taches de l'appli
   
   Application_Tasks : Application_Tasks_Array := 
     (
      -- The APPlication Task
      
      (Name          => new String'("appli"),
       Inputs        => Mast_Section.Scale_Inputs'Address, 
       Outputs       => Mast_Section.Scale_Outputs'Address,
       Data_Register => System.Null_Address,
       Initialize    => Mast_Section.initialize'Address,
       Main          => Mast_Section.cyclic'Address,
       Task_Kind     => Periodic_Task,
       Period        => 0.1,
       Run_Condition => null),
      
      -- The Simulation Task
      
      (Name          => new String'("simul"),
       Inputs        => Simul_Get_Inputs'Address,
       Outputs       => Simul_Set_Outputs'Address,
       Data_Register => System.Null_Address,
       Initialize    => Simul.Initialize'Address,
       Main          => Simul.Cyclic'Address,
       Task_Kind     => Periodic_Task,
       Period        => 0.1,
       Run_Condition => null),

      -- The User Task
      
      (Name          => new String'("user"),
       Inputs        => System.Null_Address,
       Outputs       => System.Null_Address,
       Data_Register => System.Null_Address,
       Initialize    => System.Null_Address,
       Main          => System.Null_Address,
       Task_Kind     => Periodic_Task,
       Period        => 1.0,
       Run_Condition => null)

       );
        
   -- <change end>
   
   ---------------
   -- Add_Tasks --
   ---------------
   
   procedure Run_Tasks is
      Dt : Float := 0.0;
   begin
      Put_Line ("Run_Tasks Begin ");
      Initialize_Run_Time;
      Rxrt.RxClock.Set_Tick (0.1);
      
      Put_Line ("Run_Tasks Create Tasks");
      for I in Application_Tasks'Range loop
	 Create_Task (Application_Tasks (I));
      end loop;
      
      Put_Line ("Run_Tasks Goto Run");
      loop
	 Run;
	 delay 0.01;
      end loop;
   end Run_Tasks;
   
end Main;

