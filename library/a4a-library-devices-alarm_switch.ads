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
--                                                                   --
-- As a special exception, if other files instantiate generics from  --
-- this unit, or you link this unit with other files to produce an   --
-- executable, this  unit  does not  by itself cause  the resulting  --
-- executable to be covered by the GNU General Public License. This  --
-- exception does not however invalidate any other reasons why the   --
-- executable file  might be covered by the  GNU Public License.     --
-----------------------------------------------------------------------

with Rx.Library.Timers.TON; use Rx.Library.Timers;

package Rx.Library.Devices.Alarm_Switch is

   Default_TON_Preset : constant := 1000;
   --  Default value in milliseconds for Timer TON Preset

   type Alarm_Switch_Record is new Device_Type with private;

   overriding function Create
     (Id : in String)
      return Instance;

   function Create
     (Id         : in String;
      TON_Preset : in Positive)
      --  TON Preset in milliseconds
      return Instance;

   procedure Cyclic
     (Device     : in out Instance;
      Alarm_Cond : in Boolean;
      Ack        : in Boolean;
      Inhibit    : in Boolean);

   function is_On
     (Device    : in Instance) return Boolean;

   function is_Faulty
     (Device    : in Instance) return Boolean;

private

   type Device_Status is
     (Status_Off,
      Status_On,
      Status_Fault);

   type Instance is new Device_Type with
      record
         Status    : Device_Status := Status_Off;
         Preset    : Time_Span;
         Tempo_Dis : TON.Instance;
      end record;

end Rx.Library.Devices.Alarm_Switch;
