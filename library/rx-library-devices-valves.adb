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

package body Rx.Library.Devices.Valves is

   ----------------------
   -- Initialize_Valve --
   ----------------------
   
   procedure Initialize_Valve 
     (This           : in out Valve_Record;
      TON_Preset_Dis : Duration;
      TON_Preset_Mov : Duration) is
   begin
      This := No_Valve_Record;
      
      This.Preset_Dis := TON_Preset_Dis;
      Rx.Library.Timers.TON.Initialize_TON (This.Tempo_Dis);
      
      This.Preset_Mov := TON_Preset_Mov;
      Rx.Library.Timers.TON.Initialize_TON (This.Tempo_Mov);
   end Initialize_Valve;
   
   ------------
   -- Cyclic --
   ------------
   
   procedure Cyclic
     (This        : in out Valve_Record;
      Pos_Open    : Boolean;
      Pos_Closed  : Boolean;
      Ack         : Boolean;
      Cmd_Open    : Boolean;
      Coil        : out Boolean) is
      
      Elapsed_Dis               : Duration;
      Elapsed_Mov               : Duration;
      Tempo_Dis_Q               : Boolean;
      Tempo_Mov_Q               : Boolean;
      Static_Failure_Condition  : Boolean;
      Dynamic_Failure_Condition : Boolean;
   begin

      Static_Failure_Condition :=
        ((This.Status = Status_Closed) and not Pos_Closed)
        or ((This.Status = Status_Open) and not Pos_Open)
        or (Pos_Closed and Pos_Open);

      This.Tempo_Dis.Cyclic
        (Start      => Static_Failure_Condition,
         Preset     => This.Preset_Dis,
         Elapsed    => Elapsed_Dis,
         Q          => Tempo_Dis_Q);

      Dynamic_Failure_Condition :=
        (This.Status = Status_Opening) or (This.Status = Status_Closing);

      This.Tempo_Mov.Cyclic
        (Start      => Dynamic_Failure_Condition,
         Preset     => This.Preset_Mov,
         Elapsed    => Elapsed_Mov,
         Q          => Tempo_Mov_Q);

      if Tempo_Dis_Q or Tempo_Mov_Q then
         This.Status := Status_Fault;
      end if;

      case This.Status is
         when Status_Closed =>
            if Cmd_Open then
               This.Status := Status_Opening;
            end if;
         when Status_Opening =>
            if Pos_Open then
               This.Status := Status_Open;
            end if;
         when Status_Open =>
            if not Cmd_Open then
               This.Status := Status_Closing;
            end if;
         when Status_Closing =>
            if Pos_Closed then
               This.Status := Status_Closed;
            end if;
         when Status_Fault =>
            if Ack then
               This.Status := Status_Closed;
            end if;
      end case;

      Coil := (This.Status = Status_Opening) or (This.Status = Status_Open);

      This.Pos_Open   := Pos_Open;
      This.Pos_Closed := Pos_Closed;
      This.Coil       := Coil;
   end Cyclic;
   
   -------------
   -- Is_Open --
   -------------
   
   function Is_Open (This : Valve_Record) return Boolean is
   begin
      return This.Status = Status_Open;
   end Is_Open;
   
   ---------------
   -- Is_Closed --
   ---------------
   
   function Is_Closed (This : Valve_Record) return Boolean is
   begin
      return This.Status = Status_Closed;
   end Is_Closed;
   
   ---------------
   -- Is_Faulty --
   ---------------
   
   function Is_Faulty (This : Valve_Record) return Boolean is
   begin
      return This.Status = Status_Fault;
   end Is_Faulty;
   
   -------------
   -- Get_Coil --
   -------------
   
   function Get_Coil (This : Valve_Record) return Boolean is
   begin
      return This.Coil;
   end Get_Coil;

end Rx.Library.Devices.Valves;
