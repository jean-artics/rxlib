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

with Rx.Library.Timers.TON; use Rx.Library.Timers.TON;

package Rx.Library.Simulation.Contactors is

   type Contactor_Simul_Reoord is tagged private;
   
   No_Contactor_Simul_Reoord : constant Contactor_Simul_Reoord;
   
   procedure Initialize_Contactor_Simul
     (This       : in out Contactor_Simul_Reoord;
      Ton_Preset : Duration);
   
   procedure Cyclic
     (This      : in out Contactor_Simul_Reoord;
      Auto      : in Boolean;
      FB_Manu   : in Boolean;
      Coil      : in Boolean;
      Feed_Back : out Boolean);

private

   type Contactor_Simul_Reoord is tagged record
      Preset_Simu : Duration;
      Tempo_Simu  : Rx.Library.Timers.TON.Ton_Record;
   end record;
   
   No_Contactor_Simul_Reoord : constant Contactor_Simul_Reoord :=
     Contactor_Simul_Reoord'
     (Preset_Simu => 1000.0,
      Tempo_Simu  => Rx.Library.Timers.TON.No_Ton_Record);
   
end Rx.Library.Simulation.Contactors;
