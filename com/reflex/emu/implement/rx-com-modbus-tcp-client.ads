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

with System;

with Ada.Unchecked_Deallocation;

with Rx.Sys.Task_Interfaces;
with Rx.Sys.Task_Watchdog; use Rx.Sys.Task_Watchdog;

with Rx.Com.Protocols; use Rx.Com.Protocols.IP_Address_Strings;
with Rx.Com.Protocols.LibModbus; use Rx.Com.Protocols.LibModbus;
with Rx.Sys.Dual_Port_Memory; use Rx.Sys.Dual_Port_Memory;

package Rx.Com.Modbus.Tcp.Client is

   Faults_Time_Out_MS   : Natural := 10000;

   type Command_Type (Action : Action_Type := Read_Registers) is record
      Enabled          : Boolean := True;
      Period_Multiple  : Positive;
      Shift            : Natural;
      
      case Action is
	 
	 when Read_Bits | Read_Input_Bits | Read_Registers |
	   Read_Input_Registers | Write_Bit | Write_Register |
	   Write_Bits | Write_Registers =>
	    
	    Number           : Positive;
	    Offset_Remote    : Offset_Type;
	    Offset_Local     : Offset_Type;
	    
	 when Write_Read_Registers =>
	    
	    Write_Number        : Positive;
	    Write_Offset_Remote : Offset_Type;
	    Write_Offset_Local  : Offset_Type;
	    
	    Read_Number         : Positive;
	    Read_Offset_Remote  : Offset_Type;
	    Read_Offset_Local   : Offset_Type;
	    
      end case;
   end record;
   
   type Commands_Table is array (Positive range <>) of Command_Type;

   --  Command_Number : The number of commands in the table
   type Client_Configuration (Command_Number : Positive) is record
      Enabled           : Boolean := True;
      Debug_On          : Boolean := False;
      --  Enables Modbus traces
      Task_Period_MS    : Positive;
      --  The period of the Client Task
      
      Retries           : Natural;
      --  The task will retry "Retries" time before setting status to fault
      
      Timeout           : Duration := 0.5;
      --  Command Time Out
      
      Server_IP_Address : Bounded_String;
      Server_TCP_Port   : TCP_Port_Type;
      Commands          : Commands_Table (1 .. Command_Number);
   end record;
   type Client_Configuration_Access is access all Client_Configuration;
   
   type Client_Configuration_Access_Array is array (Positive range <>)
     of Client_Configuration_Access;
   
   type Command_Status_Type is
     (Unknown,
      Disabled,
      Fine,
      Fault);

   type Command_Data_Type is record
      Retries : Natural := 3;
   end record;
   
   type Commands_Status_Type is array (Positive range <>)
     of Command_Status_Type;
   type Commands_Status_Access is access all Commands_Status_Type;

   type Commands_Data_Type is array (Positive range <>)
     of Command_Data_Type;

   type Client_Status_Type (Command_Number : Positive) is record
      Terminated  : Boolean  := False;
      
      Connected   : Boolean  := False;
      Commands_Status : Commands_Status_Type (1 .. Command_Number) :=
	(others => Unknown);
      Commands_Data : Commands_Data_Type (1 .. Command_Number);
   end record;
   type Client_Status_Access is access all Client_Status_Type;
   
   protected type Client_Status (Command_Number : Positive) is
      
      procedure Set_Terminated (Value : in Boolean);
      function Get_Terminated return Boolean;

      procedure Set_Connected (Value : in Boolean);
      function Get_Connected return Boolean;

      procedure Set_Command_Status
        (Command    : in Positive;
         Cmd_Status : in Command_Status_Type);

      function Get_Command_Status
        (Command    : in Positive)
         return Command_Status_Type;

      procedure Set_Command_Retries
        (Command : in Positive;
         Retries : in Natural);

      function Get_Command_Retries
        (Command : in Positive)
         return Natural;

      function Get_Status return Client_Status_Type;

   private
      Status : Client_Status_Type (Command_Number);
      
   end Client_Status;

   type Client_Interface (Command_Number : Positive) is record
      Control : Rx.Sys.Task_Interfaces.Task_Control;
      Status  : Client_Status (Command_Number);
      
      Control_Watchdog : Control_Watchdog_Type;
      Status_Watchdog  : Status_Watchdog_Type;
   end record;
   type Client_Interface_Access is access all Client_Interface;

   procedure Free_Client_Interface is new Ada.Unchecked_Deallocation
     (Object => Client_Interface, Name => Client_Interface_Access);

   task type Client_Task
     (Task_Priority           : System.Priority;
      Client_Itf              : Client_Interface_Access;
      Configuration           : Client_Configuration_Access;
      Bool_DPM_Access         : Bool_Dual_Port_Memory_Access;
      Word_DPM_Access         : Word_Dual_Port_Memory_Access) is

      pragma Priority (Task_Priority);
   end Client_Task;
   type Client_Task_Access is access Client_Task;

   type Client_Task_Access_Array is array (Positive range <>)
     of  Client_Task_Access;

private

   procedure Run
     (Configuration   : Client_Configuration_Access;
      Client_Itf      : Client_Interface_Access;
      Bool_DPM_Access : Bool_Dual_Port_Memory_Access;
      Word_DPM_Access : Word_Dual_Port_Memory_Access);
   --  The job of the periodic task

end Rx.Com.Modbus.Tcp.Client;
