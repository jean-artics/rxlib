-----------------------------------------------------------------------
--                          Reflex Library                           --
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

-- This package has the root of all system timers. These tiemrs are only used
-- by reflex run time and its associated components like communications. The
-- timers types are implemented by child of this package. This package only
-- provide a task time handler.

with System;

with Ada.Real_Time; use Ada.Real_Time;

with Rx.Sys.Task_Interfaces; use Rx.Sys.Task_Interfaces;

package Rx.Sys.Timers is

   type Task_Interface is record
      Control : Task_Control;
      Status  : Task_Status;
   end record;
   type Task_Itf_Access is access all Task_Interface;

   task type Clock_Handler_Task_Type
     (Task_Priority           : System.Priority;
      Task_Itf                : Task_Itf_Access;
      Period_In_Milliseconds  : Natural) is
      pragma Priority (Task_Priority);
   end Clock_Handler_Task_Type;
   --  This type should have only one instance
   type Clock_Handler_Task_Type_Access is access Clock_Handler_Task_Type;

   function Clock_Time return Time;
   --  returns the Time managed by the Clock_Handler task

private

   Clock_Time_Val : Time;

end Rx.Sys.Timers;
