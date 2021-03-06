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

package Rx.Library.Analogs.Utils is
   
   Epsilon : constant Float := 0.00001;
   
   function Epsilon_Equal
     (V1 : Float;
      V2 : Float) return Boolean;
   
   function Saturation
     (Value : in Float;
      Low   : in Float;
      High  : in Float) return Float;
   -- Saturate the value between Low and High bounds
   
   procedure Saturate_Value
     (Value : in out Float;
      Low   : in Float;
      High  : in Float);
   
   procedure Dead_Band
     (In_Value       : in Float;
      Out_Value      : out Float;
      Dead_Band_High : in Float;
      Dead_Band_Low  : in Float);
   
   procedure Gain 
     (Value : in Float;
      G     : in Float;
      Q     : out Float);
   
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

   procedure Pid_Controller
     (Init           : in out Boolean;
      Setpoint       : in Float;
      Meas           : in Float;
      Dead_Band_Low  : in Float;
      Dead_Band_High : in Float;
      Kp             : in Float;
      Ki             : in Float;
      Kd             : in Float;
      Ki_Limit_Low   : in Float;
      Ki_Limit_High  : in Float;
      Period         : in Duration;
      Last_Clock     : in out Duration;
      Ki_Out_1       : in out Float;
      Err_Db         : out Float;
      Cmd            : in out Float);
   
   procedure Ramp_Limitation
     (Init       : in Boolean;
      In_P       : in Float;
      Setpoint   : in Float;
      Dt         : in Float;
      Limit_Rise : in Float;
      Limit_Fall : in Float;
      Out_P_Old  : in out Float;
      Out_P      : out Float);
   
end Rx.Library.Analogs.Utils;
