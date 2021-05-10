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

package body Rx.Library.Simulation.Valves is
   
   ----------------------------
   -- Initialize_Valve_Simul --
   ----------------------------
   
   procedure Initialize_Valve_Simul
     (This       : in out Valve_Simul_Record;
      Ton_Preset : Duration) is
   begin
      This := No_Valve_Simul_Record;
      
      Rx.Library.Timers.TON.Initialize_TON (This.Tempo_Simu);
   end Initialize_Valve_Simul;
   
   ------------
   -- Cyclic --
   ------------
   
   procedure Cyclic
     (This        : in out Valve_Simul_Record;
      Auto        : in Boolean;
      ZO_Manu     : in Boolean;
      ZF_Manu     : in Boolean;
      Coil        : in Boolean;
      Pos_Open    : out Boolean;
      Pos_Closed  : out Boolean) is

      Elapsed     : Duration;
      Tempo_Q     : Boolean;
      Tempo_Start : Boolean;
   begin
      Tempo_Start := (This.Status = Status_Opening) 
	or (This.Status = Status_Closing);

      This.Tempo_Simu.Cyclic
        (Start      => Tempo_Start,
         Preset     => This.Preset_Simu,
         Elapsed    => Elapsed,
         Q          => Tempo_Q);

      case This.Status is
         when Status_Closed =>
            if Coil then
               This.Status := Status_Opening;
            end if;
         when Status_Opening =>
            if Tempo_Q then
               This.Status := Status_Open;
            end if;
         when Status_Open =>
            if not Coil then
               This.Status := Status_Closing;
            end if;
         when Status_Closing =>
            if Tempo_Q then
               This.Status := Status_Closed;
            end if;
      end case;

      Pos_Open := (Auto and (This.Status = Status_Open)) 
	or (not Auto and ZO_Manu);

      Pos_Closed := (Auto and (This.Status = Status_Closed)) 
	or (not Auto and ZF_Manu);

   end Cyclic;

end Rx.Library.Simulation.Valves;
