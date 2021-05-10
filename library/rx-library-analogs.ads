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

--  This package provides a home for analog stuff.
--  - Scale_In,
--  - Scale_Out,
--  - Threshold,
--  - Limits,
--  - Filters.

package Rx.Library.Analogs is
   
   Epsilon : constant Float := 0.00001;
   
   function Epsilon_Equal
     (V1 : Float;
      V2 : Float) return Boolean;
   
   function Scale_In
     (X    : Integer;
      Xmin : Integer;
      Xmax : Integer;
      Ymin : Float;
      Ymax : Float) return Float;
   -- returns the value scaled :
   -- Y = Ymax + ((X - Xmax) * (Ymax - Ymin) / (Xmax - Xmin))

   function Scale_Out
     (X    : Float;
      Xmin : Float;
      Xmax : Float;
      Ymin : Integer;
      Ymax : Integer) return Integer;
   -- returns the value scaled :
   -- Y = Ymax + ((X - Xmax) * (Ymax - Ymin) / (Xmax - Xmin))

   function Limits
     (X    : Float;
      Ymin : Float;
      Ymax : Float) return Float;
   -- returns the value limited to the bounds
   
   procedure Dead_Band
     (In_Value       : in Float;
      Out_Value      : out Float;
      Dead_Band_High : in Float;
      Dead_Band_Low  : in Float);
   
   function Max_Of
     (Val1 : Float;
      Val2 : Float) return Float;
   
   function Min_Of
     (Val1 : Float;
      Val2  : Float) return Float;
   
   procedure Min_Limitation
     (Value : in out Float;
      Mini  : Float);

   procedure Max_Limitation
     (Value : in out Float;
      Maxi  : Float);

   subtype Gradient_Type is Float range 0.0 .. Float'Last;

   procedure Ramp
     (Value_In  : in Float;
      Gradient  : in Gradient_Type;
      Value_Out : in out Float);
   -- has to be called in a periodic task. the gradient has to be calculated
   -- accordingly

end Rx.Library.Analogs;
