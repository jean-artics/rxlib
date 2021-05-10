-----------------------------------------------------------------------
--                       Reflex Library - Timer TPULSE               --
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


with RxClock;

package body Rx.Library.Timers.TPULSE is

   --------------------
   -- Initialize_TON --
   --------------------
   
   procedure Initialize_TPULSE (This : in out Tpulse_Record) is
   begin
      This := No_Tpulse_Record;
   end Initialize_TPULSE;
   
   ------------
   -- Cyclic --
   ------------
   
   procedure Cyclic
     (This    : in out Tpulse_Record;
      Start   : in Boolean;
      Preset  : in Duration;
      Elapsed : out Duration;
      Q       : out Boolean) is
   begin
	 
      case This.Status is
	 
         when Status_Off =>
            if Start then
               This.Status     := Status_Running;
               This.Start_Time := RxClock.Clock;
               This.End_Time   := Preset;
               Elapsed := 0.0;
            end if;
	    
         when Status_Running =>
            Elapsed := RxClock.Clock - This.Start_Time;
            if Elapsed >= Preset then
               This.Status := Status_On;
            end if;
	    
         when Status_On =>
            if Start then
               This.Status := Status_Off;
            end if;
      end case;

      Q := This.Status = Status_Running;
   end Cyclic;

end Rx.Library.Timers.TPULSE;
