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

package body Rx.Library.Analogs.Threshold is

   procedure Initialise
     (This       : in out Threshold_Record;
      Hysteresis : Float;
      HHH_T      : Float;
      HH_T       : Float;
      H_T        : Float;
      L_T        : Float;
      LL_T       : Float;
      LLL_T      : Float) is
   begin
      This.Hysteresis := Hysteresis;

      This.HHH_T := HHH_T;
      This.HH_T  := HH_T;
      This.H_T   := H_T;
      This.L_T   := L_T;
      This.LL_T  := LL_T;
      This.LLL_T := LLL_T;
   end Initialise;

   procedure Cyclic
     (This  : in out Threshold_Record;
      Value : in Float;
      HHH   : out Boolean;
      HH    : out Boolean;
      H     : out Boolean;
      L     : out Boolean;
      LL    : out Boolean;
      LLL   : out Boolean) is
   begin

      if Value > This.HHH_T then
         This.HHH := True;
      elsif Value <= This.HHH_T - This.Hysteresis then
         This.HHH := False;
      end if;

      if Value > This.HH_T then
         This.HH := True;
      elsif Value <= This.HH_T - This.Hysteresis then
         This.HH := False;
      end if;

      if Value > This.H_T then
         This.H := True;
      elsif Value <= This.H_T - This.Hysteresis then
         This.H := False;
      end if;

      if Value > This.L_T + This.Hysteresis then
         This.L := False;
      elsif Value <= This.L_T then
         This.L := True;
      end if;

      if Value > This.LL_T + This.Hysteresis then
         This.LL := False;
      elsif Value <= This.LL_T then
         This.LL := True;
      end if;

      if Value > This.LLL_T + This.Hysteresis then
         This.LLL := False;
      elsif Value <= This.LLL_T then
         This.LLL := True;
      end if;

      HHH := This.HHH;
      HH  := This.HH;
      H   := This.H;

      L   := This.L;
      LL  := This.LL;
      LLL := This.LLL;
   end Cyclic;

end Rx.Library.Analogs.Threshold;
