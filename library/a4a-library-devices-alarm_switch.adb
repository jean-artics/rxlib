
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

package body A4A.Library.Devices.Alarm_Switch is

   overriding function Create
     (Id : in String)
      return Instance is
      Tempo_Dis : TON.Instance;
   begin
      return (Limited_Controlled with Id => new String'(Id),
              Status    => Status_Off,
              Preset    => Milliseconds (Default_TON_Preset),
              Tempo_Dis => Tempo_Dis);
   end Create;

   function Create
     (Id         : in String;
      TON_Preset : in Positive)
      --  TON Preset in milliseconds
      return Instance is
      Tempo_Dis : TON.Instance;
   begin
      return (Limited_Controlled with Id => new String'(Id),
              Status    => Status_Off,
              Preset    => Milliseconds (TON_Preset),
              Tempo_Dis => Tempo_Dis);
   end Create;

   procedure Cyclic
     (Device     : in out Instance;
      Alarm_Cond : in Boolean;
      Ack        : in Boolean;
      Inhibit    : in Boolean) is
      Elapsed : Time_Span;
      Tempo_Q : Boolean;
   begin

      Device.Tempo_Dis.Cyclic
        (Start      => Alarm_Cond and not Inhibit,
         Preset     => Milliseconds (1000),
         Elapsed    => Elapsed,
         Q          => Tempo_Q);

      case Device.Status is
         when Status_Off =>
            if Alarm_Cond and not Inhibit then
               Device.Status := Status_On;
            end if;
         when Status_On =>
            if Tempo_Q then
               Device.Status := Status_Fault;
            elsif not Alarm_Cond or Inhibit then
               Device.Status := Status_Off;
            end if;
         when Status_Fault =>
            if Ack then
               Device.Status := Status_Off;
            end if;
      end case;
   end Cyclic;

   function is_On
     (Device    : in Instance) return Boolean is
   begin
      return (Device.Status = Status_On);
   end is_On;

   function is_Faulty
     (Device    : in Instance) return Boolean is
   begin
      return (Device.Status = Status_Fault);
   end is_Faulty;

end A4A.Library.Devices.Alarm_Switch;
