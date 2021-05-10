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

--  This package implements PID Controller.

package Rx.Library.Analogs.PID is

   type Pid_Record is tagged private;
   
   procedure Initialize
     (This       : in out Pid_Record;
      Kp         : Float;
      Ki         : Float;
      Kd         : Float;
      Period     : Duration;
      Limit_High : Float;
      Limit_Low  : Float);

   procedure Cyclic
     (This          : in out Pid_Record;
      Clock         : in Duration;
      Run           : in Boolean;
      Set_Point     : in Float;
      Process_Value : in Float;
      Out_Value     : in out Float);
   
private

   type Pid_Record is tagged record
      Previous_Run   : Boolean;
      Previous_Error : Float;
      Previous_Clock : Duration;
      Previous_Out   : Float;
      Period         : Duration;
      Integral       : Float;
      Kp             : Float;
      Ki             : Float;
      Kd             : Float;
      Limit_High     : Float;
      Limit_Low      : Float;
   end record;

end Rx.Library.Analogs.PID;
