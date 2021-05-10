
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

package Rxrt.Locks is
   
   -------------------
   -- The semaphore --
   -------------------
   
   protected type Locker is
      entry Lock;
      entry Unlock;
   private
      Locked : Boolean := False;
   end Locker;

   type Lock_Access is access all Locker;
   
   function Create_Lock return Lock_Access;
   procedure Lock   (L : Lock_Access);
   procedure Unlock (L : Lock_Access);
   
   pragma Export (Ada, Create_Lock, "Rxrt_Create_Lock");
   pragma Export (Ada, Lock, "Rxrt_Lock");
   pragma Export (Ada, Unlock, "Rxrt_Unlock");
   
end Rxrt.Locks;
