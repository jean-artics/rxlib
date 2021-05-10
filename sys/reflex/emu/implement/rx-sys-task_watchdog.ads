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

with Ada.Real_Time; use Ada.Real_Time;

with Rx.Sys.Timers.TON;

with Rx.Com; use Rx.Com;

package Rx.Sys.Task_Watchdog is

   Default_Watchdog_Time_Out_MS : constant Natural := 1000;

   --------------------------------------------------------------------
   --  Control Watchdog
   --------------------------------------------------------------------

   protected type Control_Watchdog_Type is

      procedure Watchdog
        (Watching        : in Boolean;
         Status_Watchdog : in DWord;
         Error           : out Boolean);

      procedure Set_Time_Out
        (Time_Out_MS : Natural := Default_Watchdog_Time_Out_MS);

      function Value return DWord;

   private

      Watching   : Boolean := False;

      Watchdog_Value    : DWord   := 0;

      Watchdog_Time_Out : Ada.Real_Time.Time_Span :=
        Ada.Real_Time.Milliseconds (Default_Watchdog_Time_Out_MS);

      Watchdog_TON         : Rx.Sys.Timers.TON.Instance;
      Watchdog_TON_Elapsed : Ada.Real_Time.Time_Span := Time_Span_Zero;
      Watchdog_TON_Start   : Boolean := False;
      Watchdog_TON_Q       : Boolean := False;

   end Control_Watchdog_Type;

   --------------------------------------------------------------------
   --  Status Watchdog
   --------------------------------------------------------------------

   protected type Status_Watchdog_Type is

      procedure Watchdog
        (Watching         : in Boolean;
         Control_Watchdog : in DWord;
         Error            : out Boolean);

      procedure Set_Time_Out
        (Time_Out_MS : Natural := Default_Watchdog_Time_Out_MS);

      function Value return DWord;

   private

      Watching   : Boolean := False;

      Watchdog_Value    : DWord   := 0;

      Watchdog_Time_Out : Ada.Real_Time.Time_Span :=
        Ada.Real_Time.Milliseconds (Default_Watchdog_Time_Out_MS);

      Watchdog_TON         : Rx.Sys.Timers.TON.Instance;
      Watchdog_TON_Elapsed : Ada.Real_Time.Time_Span := Time_Span_Zero;
      Watchdog_TON_Start   : Boolean := False;
      Watchdog_TON_Q       : Boolean := False;

   end Status_Watchdog_Type;

end Rx.Sys.Task_Watchdog;
