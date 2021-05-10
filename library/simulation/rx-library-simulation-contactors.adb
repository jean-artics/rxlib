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

package body Rx.Library.Simulation.Contactors is
   
   --------------------------------
   -- Initialize_Contactor_Simul --
   --------------------------------
   
   procedure Initialize_Contactor_Simul
     (This       : in out Contactor_Simul_Reoord;
      Ton_Preset : Duration) is
   begin
      This := No_Contactor_Simul_Reoord;
      Rx.Library.Timers.TON.Initialize_Ton (This.Tempo_Simu);
   end Initialize_Contactor_Simul;
   
   ------------
   -- Cyclic --
   ------------
   
   procedure Cyclic
     (This      : in out Contactor_Simul_Reoord;
      Auto      : in Boolean;
      FB_Manu   : in Boolean;
      Coil      : in Boolean;
      Feed_Back : out Boolean) is
      
      Elapsed : Duration;
      Tempo_Q : Boolean;
   begin
      This.Tempo_Simu.Cyclic
        (Start   => Coil,
         Preset  => This.Preset_Simu,
         Elapsed => Elapsed,
         Q       => Tempo_Q);

      Feed_Back := (Auto and Tempo_Q) or (not Auto and FB_Manu);
   end Cyclic;

end Rx.Library.Simulation.Contactors;
