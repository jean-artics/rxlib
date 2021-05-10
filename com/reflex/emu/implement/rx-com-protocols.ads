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

-- This package is the home for the various field bus protocols. For the time
-- being the protocols alowed are Modbus TCP and Modbus RTU

with Ada.Strings.Bounded;

package Rx.Com.Protocols is

   IP_Address_String_Length_Max : constant := 15; -- "000.000.000.000"
   
   package IP_Address_Strings is new
     Ada.Strings.Bounded.Generic_Bounded_Length (IP_Address_String_Length_Max);

   Device_String_Length_Max : constant := 15;
   --  "/dev/ttyUSB0"
   --  "/dev/ttyS0"
   --  "\\\\.\\COM10"
   
   package Device_Strings is new
     Ada.Strings.Bounded.Generic_Bounded_Length (Device_String_Length_Max);
   --  The device argument specifies the name of the serial port handled by the
   --  OS, eg. /dev/ttyS0 or /dev/ttyUSB0. On Windows, it is necessary to
   --  prepend COM name with \\.\ for COM number greater than 9,
   --  eg. \\\\.\\COM10.
   --  See http://msdn.microsoft.com/en-us/library/aa365247(v=vs.85).aspx for
   --  details

end Rx.Com.Protocols;
