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

with Rx.Com; use Rx.Com;

package Rx.Memory.Rtu_Master is

   --------------------------------------------------------------------
   --  IO Areas
   --------------------------------------------------------------------

   Bool_IO_Size  : constant := 1024;
   subtype Bool_IO_Range is Integer range 0 .. Bool_IO_Size - 1;

   Bool_Inputs  : Bool_Array (Bool_IO_Range) := (others => False);
   Bool_Outputs : Bool_Array (Bool_IO_Range) := (others => False);

   Word_IO_Size  : constant := 1024;
   subtype Word_IO_Range is Integer range 0 .. Word_IO_Size - 1;

   Word_Inputs  : Word_Array (Word_IO_Range) := (others => 0);
   Word_Outputs : Word_Array (Word_IO_Range) := (others => 0);

end Rx.Memory.Rtu_Master;
