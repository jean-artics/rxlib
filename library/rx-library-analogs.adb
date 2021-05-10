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

package body Rx.Library.Analogs is
   
   --------------------
   -- Epsilon_Equal --
   --------------------
   
   function Epsilon_Equal
     (V1 : Float;
      V2 : Float) return Boolean is
   begin
      return (abs (V2-V1)) < Epsilon;
   end Epsilon_Equal;
   
   --------------
   -- Scale_In --
   --------------
   
   function Scale_In
     (X    : Integer;
      Xmin : Integer;
      Xmax : Integer;
      Ymin : Float;
      Ymax : Float) return Float is
   begin
      return Ymax + ((Float (X - Xmax) * (Ymax - Ymin)) / Float (Xmax - Xmin));
   end Scale_In;
   
   ---------------
   -- Scale_Out --
   ---------------
   
   function Scale_Out
     (X    : Float;
      Xmin : Float;
      Xmax : Float;
      Ymin : Integer;
      Ymax : Integer) return Integer is
   begin
      return Ymax + Integer (Float'Floor (
        ((X - Xmax) * Float (Ymax - Ymin)) / (Xmax - Xmin)));
   end Scale_Out;
   
   ------------
   -- Limits --
   ------------
   
   function Limits
     (X    : Float;
      Ymin : Float;
      Ymax : Float) return Float is
   begin
      if X < Ymin then
         return Ymin;
      elsif X > Ymax then
         return Ymax;
      else
         return X;
      end if;
   end Limits;
   
   ---------------
   -- Dead_Band --
   ---------------
   
   procedure Dead_Band
     (In_Value       : in Float;
      Out_Value      : out Float;
      Dead_Band_High : in Float;
      Dead_Band_Low  : in Float) is
   begin
      if In_Value > Dead_Band_Low and In_Value < Dead_Band_High then
	 Out_Value := 0.0;
      else
	 Out_Value := In_Value;
      end if;
   end Dead_Band;
   
   ------------
   -- Max_Of --
   ------------

   function Max_Of
     (Val1 : Float;
      Val2 : Float) return Float
   is
      Val : Float;
   begin
      if Val1 > Val2 then
	 Val := Val1;
      else
	 Val := Val2;
      end if;
      return Val;
   end Max_Of;

  -------------
   -- Min_Of --
   ------------

   function Min_Of
     (Val1 : Float;
      Val2  : Float) return Float
   is
      Val : Float;
   begin
      if Val1 < Val2 then
	 Val := Val1;
      else
	 Val := Val2;
      end if;
      return Val;
   end Min_Of;

   ---------
   -- Min --
   ---------

   procedure Min_Limitation
     (Value : in out Float;
      Mini  : Float) is
   begin
      if Value < Mini then
	 Value := Mini;
      end if;
   end Min_Limitation;

   ---------
   -- Max --
   ---------

   procedure Max_Limitation
     (Value : in out Float;
      Maxi  : Float) is
   begin
      if Value > Maxi then
	 Value := Maxi;
      end if;
   end Max_Limitation;

   ----------
   -- Ramp --
   ----------
   
   procedure Ramp
     (Value_In  : in Float;
      Gradient  : in Gradient_Type;
      Value_Out : in out Float) is
   begin
      if (Value_In - Value_Out) > Float (Gradient) then
         Value_Out := Value_Out + Float (Gradient);
      elsif (-Value_In + Value_Out) > Float (Gradient) then
         Value_Out := Value_Out - Float (Gradient);
      else
         Value_Out := Value_In;
      end if;
   end Ramp;

end Rx.Library.Analogs;
