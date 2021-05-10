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

package body Rx.Sys.Timers is

   task body Clock_Handler_Task_Type is
      Next_Time : Time := Clock;
      Period : constant Time_Span := Milliseconds (Period_In_Milliseconds);
   begin
      loop
         Next_Time := Next_Time + Period;

         Clock_Time_Val := Clock;

         exit when Task_Itf.Control.Quit;
         delay until Next_Time;
      end loop;

      Task_Itf.Status.Terminated (Task_Itf.Control.Quit);
   end Clock_Handler_Task_Type;
   
   ----------------
   -- Clock_Time --
   ----------------
   
   function Clock_Time return Time is
   begin
      return Clock_Time_Val;
   end Clock_Time;

end Rx.Sys.Timers;
