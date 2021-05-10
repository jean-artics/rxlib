
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

package body Rxrt.Locks is
   
   
   protected body Locker is
      entry Lock when not Locked is
      begin
         Locked := True;
      end Lock;

      entry Unlock when Locked is
      begin
         Locked := False;
      end Unlock;
   end Locker;
   
   -----------------
   -- Create_Lock --
   -----------------
   
   function Create_Lock return Lock_Access is
   begin
      return new Locker;
   end Create_Lock;
   
   ----------
   -- Lock --
   ----------
   
   procedure Lock (L : Lock_Access) is
   begin
      L.Lock;
   end Lock;
   
   ------------
   -- Unlock --
   ------------
   
   procedure Unlock (L : Lock_Access) is
   begin
      L.Unlock;
   end Unlock;
   
end Rxrt.Locks;
