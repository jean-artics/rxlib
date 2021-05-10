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

package Rx.Library.Timers.TPULSE is

   type Tpulse_Record is new Timer_Record with private;

   No_Tpulse_Record : constant Tpulse_Record;
   
   procedure Initialize_TPULSE (This : in out Tpulse_Record);
   
   procedure Cyclic
     (This    : in out Tpulse_Record;
      Start   : in Boolean;
      Preset  : in Duration;
      Elapsed : out Duration;
      Q       : out Boolean);

private

   type Tpulse_Record is new Timer_Record with null record;
   
   No_Tpulse_Record: constant Tpulse_Record :=
     Tpulse_Record'
     (Status     => Status_Off,
      Start_Time => 0.0,
      End_Time   => 0.0);
   
end Rx.Library.Timers.TPULSE;
