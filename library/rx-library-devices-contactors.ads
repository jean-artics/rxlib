
------------------------------------------------------------------------------
--                            Ada for Automation                            --
--                                                                          --
--                   Copyright (C) 2012-2016, Stephane LOS                  --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

with Rx.Library.Timers.TON; use Rx.Library.Timers;

package Rx.Library.Devices.Contactors is

   type Contactor_Record is new Device_Record with private;

   procedure Initialize_Contactor 
    (This       : in out Contactor_Record;
     TON_Preset : Duration);
   --  TON Preset in milliseconds
   
   procedure Cyclic
     (This      : in out Contactor_Record;
      Feed_Back : Boolean;
      Ack       : Boolean;
      Cmd_On    : Boolean;
      Coil      : out Boolean);

   function Is_On (This : Contactor_Record) return Boolean;
   
   function Is_Faulty (This : Contactor_Record) return Boolean;

   function Get_Feed_back (This : Contactor_Record) return Boolean;
   
   function Get_Coil (This : Contactor_Record) return Boolean;
   
private

   type Device_Status is
     (Status_Off,
      Status_Going_On,
      Status_On,
      Status_Going_Off,
      Status_Fault);

   type Contactor_Record is new Device_Record with record
      Status    : Device_Status;
      Preset    : Duration;
      Tempo_Dis : Rx.Library.Timers.TON.TON_Record;
      Feed_Back : Boolean;
      Coil      : Boolean;
   end record;
   
   No_Contactor_Record : constant Contactor_Record :=
     Contactor_Record'
     (Status    => Status_Off,
      Preset    => 0.0,
      Tempo_Dis => Rx.Library.Timers.TON.No_Ton_Record,
      Feed_Back => False,
      Coil      => False);
   
end Rx.Library.Devices.Contactors;
