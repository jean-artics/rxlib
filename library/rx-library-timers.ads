-----------------------------------------------------------------------
--                       Reflex Library - Timers                     --
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

package Rx.Library.Timers is

   type Timer_Record is tagged private;
   
   No_Timer_Record : constant Timer_record;
   
   procedure Cyclic
     (This    : in out Timer_Record;
      Start   : in Boolean;
      Preset  : in Duration;
      Elapsed : out Duration;
      Q       : out Boolean);

private

   type Timer_Status is
     (Status_Off,
      Status_Running,
      Status_On);

   type Timer_Record is tagged record
      Status     : Timer_Status;
      Start_Time : Duration;
      End_Time   : Duration;
   end record;
   
   No_Timer_Record : constant Timer_Record :=
     Timer_Record'
     (Status     => Status_Off,
      Start_Time => 0.0,
      End_Time   => 0.0);
   
end Rx.Library.Timers;
