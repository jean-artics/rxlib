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

package body Rx.Library.Analogs.PID is
   
   ----------------
   -- Initialize --
   ----------------
   
   procedure Initialize
     (This       : in out Pid_Record;
      Kp         : Float;
      Ki         : Float;
      Kd         : Float;
      Period     : Duration;
      Limit_High : Float;
      Limit_Low  : Float) is
   begin
      This.Kp         := Kp;
      This.Ki         := Ki;
      This.Kd         := Kd;
      This.Period     := Period;
      This.Limit_High := Limit_High;
      This.Limit_Low  := Limit_Low;
      
      This.Previous_Run   := False;
      This.Previous_Error := 0.0;
      This.Previous_Clock := 0.0;
      This.Previous_Out   := 0.0;
      This.Period         := 0.5;
      This.Integral       := 0.0;
   end Initialize;
   
   ------------
   -- Cyclic --
   ------------
   
   procedure Cyclic
     (This          : in out Pid_Record;
      Clock         : in Duration;
      Run           : in Boolean;
      Set_Point     : in Float;
      Process_Value : in Float;
      Out_Value     : in out Float) is
      
      Error        : Float;
      Derivative   : Float;
      DeltaT       : Float;
      Init         : Boolean;
      Computed_Out : Float;
   begin
      Init              := not This.Previous_Run and Run;
      This.Previous_Run := Run;
      
      if Init then
         This.Integral       := 0.0;
         This.Previous_Error := 0.0;
         This.Previous_Out   := Process_Value;
	 This.Previous_Clock := Clock;
      end if;
      
      if Run then
	 
	 DeltaT := Float (Clock - This.Previous_Clock);
	 
	 if DeltaT >= Float (This.Period) or else Init then
	    
	    Error := Set_Point - Process_Value;
	    
	    This.Integral := This.Integral + (Error * DeltaT);
	    Derivative    := (Error - This.Previous_Error) / DeltaT;
	    
	    Computed_Out :=
	      (Error * This.Kp)
	      + (This.Integral * This.Ki)
	      + (Derivative * This.Kd);
	    
	    Out_Value := Limits (Computed_Out, This.Limit_High, This.Limit_Low);
	    
	    This.Previous_Error := Error;
	    This.Previous_Clock := Clock;
	 end if;
	 
      else
	 Out_Value := Process_Value;
      end if;
   end Cyclic;
   
end Rx.Library.Analogs.PID;
