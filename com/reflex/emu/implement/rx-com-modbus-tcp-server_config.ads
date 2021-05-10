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

with Rx.Com.Modbus.Memories;
with Rx.Com.Modbus.Tcp.Server;
with Rx.Com.Protocols; use Rx.Com.Protocols.IP_Address_Strings;

package Rx.Com.Modbus.Tcp.Server_Config is

   --------------------------------------------------------------------
   --  Modbus TCP Server configuration
   --------------------------------------------------------------------
   
   package Modbus_Memory is new Rx.Com.Modbus.Memories
     (Coils_Number           => 1024,
      Input_Bits_Number      => 1024,
      Input_Registers_Number => 65536,
      Registers_Number       => 65536);
   use Modbus_Memory;
   
   package Server is new Rx.Com.Modbus.Tcp.Server (Modbus_Memory);
   use Server;
   
   Config1 : aliased Server.Server_Configuration :=
     (Server_Enabled           => True,
      Debug_On                 => False,
      Retries                  => 3,
      Server_IP_Address        => To_Bounded_String ("127.0.0.1"),
      Server_TCP_Port          => 1503);
   
   procedure Rum_Modbus_Server;
   
   The_Server_Task : Server.Server_Task_Access;
   
end Rx.Com.Modbus.Tcp.Server_Config;
