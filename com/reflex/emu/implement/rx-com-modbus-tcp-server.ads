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

with System;
with Rx.Com.Modbus.Memories;
with Rx.Sys.Task_Interfaces;
with Rx.Sys.Task_Watchdog; use Rx.Sys.Task_Watchdog;

with Rx.Com.Protocols; use Rx.Com.Protocols.IP_Address_Strings;
with Rx.Com.Protocols.LibModbus; use Rx.Com.Protocols.LibModbus;
with Rx.Sys.Lock_Mechanisms; use Rx.Sys.Lock_Mechanisms;

generic
   with package Mem is new Rx.Com.Modbus.Memories (<>);
package Rx.Com.Modbus.Tcp.Server is

   package LibModbus renames Rx.Com.Protocols.LibModbus;
   
   use Mem;
   
   type Server_Configuration is record
      Server_Enabled : Boolean := True;
      Debug_On       : Boolean := False;
      --  enables Modbus traces

      Retries : Positive;
      --  wait Retries * 1s before trying again

      Server_IP_Address : Bounded_String;
      Server_TCP_Port   : TCP_Port_Type;
   end record;
   type Server_Configuration_Access is access all Server_Configuration;

   type Commands_Status_Type is record
      Connected_Clients               : Natural  := 0;
      Read_Coils_Count                : DWord    := 0; -- 01
      Read_Input_Bits_Count           : DWord    := 0; -- 02
      Read_Holding_Registers_Count    : DWord    := 0; -- 03
      Read_Input_Registers_Count      : DWord    := 0; -- 04
      Write_Single_Coil_Count         : DWord    := 0; -- 05
      Write_Single_Register_Count     : DWord    := 0; -- 06
      Write_Multiple_Coils_Count      : DWord    := 0; -- 15
      Write_Multiple_Registers_Count  : DWord    := 0; -- 16
      Write_Read_Registers_Count      : DWord    := 0; -- 23
      Unmanaged_Requests_Count        : DWord    := 0;
   end record;

   type Server_Status_Type is record
      Terminated      : Boolean := False;
      Commands_Status : Commands_Status_Type;
   end record;

   protected type Server_Status is
      
      procedure Set_Terminated (Value : in Boolean);
      function Get_Terminated return Boolean;
      
      procedure Update_Commands_Status (Commands_Status : Commands_Status_Type);
      
      function Get_Status return Server_Status_Type;
      
   private
      Status : Server_Status_Type;
   end Server_Status;

   type Server_Interface is record
      Control : Rx.Sys.Task_Interfaces.Task_Control;
      Status  : Server_Status;

      Control_Watchdog : Control_Watchdog_Type;
      Status_Watchdog  : Status_Watchdog_Type;
   end record;
   type Server_Interface_Access is access all Server_Interface;

   task type Server_Task
     (Task_Priority           : System.Priority;
      Server_Itf              : Server_Interface_Access;
      Configuration           : Server_Configuration_Access) is
      pragma Priority (Task_Priority);
   end Server_Task;
   type Server_Task_Access is access Server_Task;

private

   My_Mapping : aliased LibModbus.Modbus_Mapping_Type; 
   
   Status : Server_Status_Type;
   --  Private_Task_Status

   procedure Run
     (Configuration : Server_Configuration_Access;
      Server_Itf    : Server_Interface_Access);
   --  The job of the periodic task
   
end Rx.Com.Modbus.Tcp.Server;
