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

with Rx.Com.Modbus.Tcp.Client; use Rx.Com.Modbus.Tcp.Client;
with Rx.Com.Protocols; use Rx.Com.Protocols.IP_Address_Strings;
with Rx.Com.Protocols.LibModbus; use Rx.Com.Protocols.LibModbus;

package Rx.Com.Modbus.Tcp.Clients_Config is

   --------------------------------------------------------------------
   --  Modbus TCP Clients configuration
   --------------------------------------------------------------------

   --  For each Modbus TCP Server define one client configuration task

   Config1 : aliased Client_Configuration :=
     (Command_Number    => 2,
      Enabled           => True,
      Debug_On          => False,
      Task_Period_MS    => 10,
      Retries           => 3,
      Timeout           => 0.2,

      Server_IP_Address => To_Bounded_String ("127.0.0.1"),

      Server_TCP_Port   => 1504,
      --  502 Standard / 1502 PLC Simu / 1504 App1Simu

      Commands =>
        (
         --                                Period              Offset Offset
         --               Action Enabled Multiple Shift Number Remote  Local
         1 =>
           (Read_Input_Bits,        True,      10,    0,    16,     0,     0),
         2 =>
           (Write_Bits,             True,      10,    5,    16,     0,     0)
        )
     );

   Config2 : aliased Client_Configuration :=
     (Command_Number    => 2,
      Enabled           => True,
      Debug_On          => False,
      Task_Period_MS    => 100,
      Retries           => 3,
      Timeout           => 0.2,

      Server_IP_Address => To_Bounded_String ("127.0.0.1"),
      Server_TCP_Port   => 1503, -- My own MBTCP server

      Commands =>
        (
         --                                Period              Offset Offset
         --               Action Enabled Multiple Shift Number Remote  Local
         1 =>
           (Read_Registers,         True,      10,    0,    10,     0,     0),
         2 =>
           (Write_Registers,        True,      30,    1,    10,     0,     0)
        )
     );

   --  Declare all clients configuration in the array
   --  The kernel will create those clients accordingly

   MBTCP_Clients_Configuration : Client_Configuration_Access_Array :=
     (1 => Config1'Access,
      2 => Config2'Access);

end Rx.Com.Modbus.Tcp.Clients_Config;
