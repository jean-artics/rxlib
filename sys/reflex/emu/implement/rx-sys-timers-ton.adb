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

package body Rx.Sys.Timers.TON is

   procedure Cyclic
     (This_Timer : in out Instance;
      Start      : in Boolean;
      Preset     : in Time_Span;
      Elapsed    : out Time_Span;
      Q          : out Boolean) is
   begin
      if not Start then
         This_Timer.Status := Status_Off;
      end if;
      
      case This_Timer.Status is
         when Status_Off =>
            if Start then
               This_Timer.Status     := Status_Running;
               This_Timer.Start_Time := Clock_Time;
               This_Timer.End_Time   := This_Timer.Start_Time + Preset;
               Elapsed := Time_Span_Zero;
            end if;
         when Status_Running =>
            Elapsed := Clock_Time - This_Timer.Start_Time;
            if Elapsed >= Preset then
               This_Timer.Status := Status_On;
            end if;
         when Status_On =>
            null;
      end case;

      Q := This_Timer.Status = Status_On;
   end Cyclic;

end Rx.Sys.Timers.TON;
