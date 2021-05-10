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

with Rx.Library.Timers.TON;

package Rx.Library.Devices.Valves is

   type Valve_Record is new Device_Record with private;
   
   No_Valve_Record : constant Valve_Record;
   
   procedure Initialize_Valve 
     (This           : in out Valve_Record;
      TON_Preset_Dis : Duration;
      TON_Preset_Mov : Duration);
   
   procedure Cyclic
     (This        : in out Valve_Record;
      Pos_Open    : Boolean;
      Pos_Closed  : Boolean;
      Ack         : Boolean;
      Cmd_Open    : Boolean;
      Coil        : out Boolean);

   function Is_Open (This : Valve_Record) return Boolean;
   
   function Is_Closed (This : Valve_Record) return Boolean;
   
   function Is_Faulty (This : Valve_Record) return Boolean;
   
   function Get_Coil (This : Valve_Record) return Boolean;

private

   type Device_Status is
     (Status_Closed,
      Status_Opening,
      Status_Open,
      Status_Closing,
      Status_Fault);

   type Valve_Record is new Device_Record with record
      Status     : Device_Status;
      Preset_Dis : Duration;
      Preset_Mov : Duration;
      Tempo_Dis  : Rx.Library.Timers.TON.Ton_Record;
      Tempo_Mov  : Rx.Library.Timers.TON.Ton_Record;
      Pos_Open   : Boolean;
      Pos_Closed : Boolean;
      Coil       : Boolean;
   end record;
   
   No_Valve_Record : constant Valve_Record :=
     Valve_Record'
     (Status     => Status_Closed,
      Preset_Dis => 1.0,
      Preset_Mov => 1.0,
      Tempo_Dis  => Rx.Library.Timers.TON.No_Ton_Record,
      Tempo_Mov  => Rx.Library.Timers.TON.No_Ton_Record,
      Pos_Open   => False,
      Pos_Closed => False,
      Coil       => False);
   
end Rx.Library.Devices.Valves;
