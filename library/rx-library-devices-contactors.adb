-----------------------------------------------------------------------
--                       Reflex Library - Timer TOFF                 --
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

package body Rx.Library.Devices.Contactors is

   --------------------------
   -- Initialize_Contactor --
   --------------------------
   
   procedure Initialize_Contactor 
    (This       : in out Contactor_Record;
     TON_Preset : Duration) is
   begin
      This := No_Contactor_Record;
      This.Preset := TON_Preset;
      
      Rx.Library.Timers.TON.Initialize_TON (This.Tempo_Dis);
   end Initialize_Contactor;
   
   ------------
   -- Cyclic --
   ------------
   
   procedure Cyclic
     (This      : in out Contactor_Record;
      Feed_Back : Boolean;
      Ack       : Boolean;
      Cmd_On    : Boolean;
      Coil      : out Boolean) is
      
      Elapsed : Duration;
      Tempo_Q : Boolean;
   begin
      case This.Status is
         when Status_Off =>
            if Cmd_On then
               This.Status := Status_Going_On;
            end if;
         when Status_Going_On =>
            if Feed_Back then
               This.Status := Status_On;
            end if;
         when Status_On =>
            if not Cmd_On then
               This.Status := Status_Going_Off;
            end if;
         when Status_Going_Off =>
            if not Feed_Back then
               This.Status := Status_Off;
            end if;
         when Status_Fault =>
            if Ack then
               This.Status := Status_Off;
            end if;
      end case;

      Coil := (This.Status = Status_Going_On) or (This.Status = Status_On);

      This.Tempo_Dis.Cyclic
        (Start      => (Coil and not Feed_Back) or (not Coil and Feed_Back),
         Preset     => This.Preset,
         Elapsed    => Elapsed,
         Q          => Tempo_Q);

      if Tempo_Q then
         This.Status := Status_Fault;
      end if;

      This.Feed_Back := Feed_Back;
      This.Coil      := Coil;
   end Cyclic;
   
   -----------
   -- Is_On --
   -----------
   
   function Is_On (This : Contactor_Record) return Boolean is
   begin
      return This.Status = Status_On;
   end Is_On;
   
   ---------------
   -- Is_Faulty --
   ---------------
   
   function Is_Faulty (This : Contactor_Record) return Boolean is
   begin
      return This.Status = Status_Fault;
   end Is_Faulty;
   
   --------------------
   -- Get_Feed_back --
   --------------------
   
   function Get_Feed_back (This : Contactor_Record) return Boolean is
   begin
      return This.Feed_back;
   end Get_Feed_back;

   --------------
   -- Get_Coil --
   --------------
   
   function Get_Coil (This : Contactor_Record) return Boolean is
   begin
      return This.Coil;
   end Get_Coil;

end Rx.Library.Devices.Contactors;
