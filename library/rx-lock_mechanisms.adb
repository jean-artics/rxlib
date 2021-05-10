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

package body Rx.Lock_Mechanisms is

   protected body Simple_RW_Lock_Mechanism is

      entry Write_Lock when not Write_Locked and Read_Count = 0 is
      begin
         Write_Locked := True;
      end Write_Lock;

      entry Write_Unlock when Write_Locked is
      begin
         Write_Locked := False;
      end Write_Unlock;

      entry Read_Lock when not Write_Locked is
      begin
         Read_Count := Read_Count + 1;
      end Read_Lock;

      entry Read_Unlock when Read_Count > 0 is
      begin
         Read_Count := Read_Count - 1;
      end Read_Unlock;

   end Simple_RW_Lock_Mechanism;

end Rx.Lock_Mechanisms;
