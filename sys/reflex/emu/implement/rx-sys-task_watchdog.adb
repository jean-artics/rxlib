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

package body Rx.Sys.Task_Watchdog is

   --------------------------------------------------------------------
   --  Control Watchdog
   --------------------------------------------------------------------

   protected body Control_Watchdog_Type is

      procedure Watchdog
        (Watching        : in Boolean;
         Status_Watchdog : in DWord;
         Error           : out Boolean) is
      begin

         Watchdog_TON_Start :=
           Watching and (Watchdog_Value = Status_Watchdog);

         Watchdog_TON.Cyclic
           (Start   => Watchdog_TON_Start,
            Preset  => Watchdog_Time_Out,
            Elapsed => Watchdog_TON_Elapsed,
            Q       => Watchdog_TON_Q);

         Error := Watchdog_TON_Q;

         Watchdog_Value := Status_Watchdog;

      end Watchdog;

      procedure Set_Time_Out
        (Time_Out_MS : Natural := Default_Watchdog_Time_Out_MS) is
      begin
         Watchdog_Time_Out := Ada.Real_Time.Milliseconds (Time_Out_MS);
      end Set_Time_Out;

      function Value return DWord is
      begin
         return Watchdog_Value;
      end Value;

   end Control_Watchdog_Type;

   --------------------------------------------------------------------
   --  Status Watchdog
   --------------------------------------------------------------------

   protected body Status_Watchdog_Type is

      procedure Watchdog
        (Watching         : in Boolean;
         Control_Watchdog : in DWord;
         Error            : out Boolean) is
      begin

         Watchdog_TON_Start :=
           Watching and (Watchdog_Value /= Control_Watchdog);

         Watchdog_TON.Cyclic
           (Start   => Watchdog_TON_Start,
            Preset  => Watchdog_Time_Out,
            Elapsed => Watchdog_TON_Elapsed,
            Q       => Watchdog_TON_Q);

         Error := Watchdog_TON_Q;

         if Watchdog_Value = Control_Watchdog then
            Watchdog_Value := Watchdog_Value + 1;
         end if;

      end Watchdog;

      procedure Set_Time_Out
        (Time_Out_MS : Natural := Default_Watchdog_Time_Out_MS) is
      begin
         Watchdog_Time_Out := Ada.Real_Time.Milliseconds (Time_Out_MS);
      end Set_Time_Out;

      function Value return DWord is
      begin
         return Watchdog_Value;
      end Value;

   end Status_Watchdog_Type;

end Rx.Sys.Task_Watchdog;
