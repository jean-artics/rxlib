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

with Rx.Sys.Task_Interfaces;
with Rx.Sys.Task_Watchdog; use Rx.Sys.Task_Watchdog;

with Rx.Com.Protocols; use Rx.Com.Protocols.Device_Strings;
with Rx.Com.Protocols.LibModbus; use Rx.Com.Protocols.LibModbus;
with Rx.Sys.Dual_Port_Memory; use Rx.Sys.Dual_Port_Memory;

package Rx.Com.Modbus.Rtu.Master is

   Faults_Time_Out_MS   : Natural := 10000;

   type Command_Type (Action : Action_Type := Read_Registers) is record
      Enabled          : Boolean := True;
      Period_Multiple  : Positive;
      Shift            : Natural;
      
      Slave            : Slave_Address;
      
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
   
   type Master_Configuration (Command_Number : Positive) is record
      Enabled           : Boolean := True;
      --  Enables the Master Scanning
      
      Debug_On          : Boolean := False;
      --  Enables Modbus traces
      
      Task_Period_MS    : Positive;
      --  The period of the Master Task
      
      Retries           : Natural;
      --  The task will retry "Retries" time before setting status to fault
      
      Timeout           : Duration := 0.5;
      --  Command Time Out
      
      Device            : Bounded_String;
      Baud_Rate         : Baud_Rate_Type := BR_9600;
      Parity            : Parity_Type    := Even;
      Data_Bits         : Data_Bits_Type := 8;
      Stop_Bits         : Stop_Bits_Type := 1;
      
      Commands          : Commands_Table (1 .. Command_Number);
   end record;
   type Master_Configuration_Access is access all Master_Configuration;

   type Master_Configuration_Access_Array is array (Positive range <>)
     of Master_Configuration_Access;
   
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

   type Commands_Data_Type is array (Positive range <>)
     of Command_Data_Type;

   type Task_Status_Type (Command_Number : Positive) is record
      Terminated  : Boolean  := False;
      
      Connected   : Boolean  := False;
      Commands_Status : Commands_Status_Type (1 .. Command_Number) :=
	(others => Unknown);
      Commands_Data : Commands_Data_Type (1 .. Command_Number);
   end record;
   
   protected type Task_Status (Command_Number : Positive) is

      procedure Terminated
        (Value : in Boolean);
      function Terminated return Boolean;

      procedure Connected
        (Value : in Boolean);
      function Connected return Boolean;

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

      function Get_Status return Task_Status_Type;

   private
      Status : Task_Status_Type (Command_Number);

   end Task_Status;

   type Task_Interface (Command_Number : Positive) is record
      Control : Rx.Sys.Task_Interfaces.Task_Control;
      Status  : Task_Status (Command_Number);
      
      Control_Watchdog : Control_Watchdog_Type;
      Status_Watchdog  : Status_Watchdog_Type;
   end record;
   type Task_Itf_Access is access all Task_Interface;

   task type Periodic_Task
     (Task_Priority   : System.Priority;
      Task_Itf        : Task_Itf_Access;
      Configuration   : Master_Configuration_Access;
      Bool_DPM_Access : Bool_Dual_Port_Memory_Access;
      Word_DPM_Access : Word_Dual_Port_Memory_Access) is

      pragma Priority (Task_Priority);
   end Periodic_Task;
   type Periodic_Task_Access is access Periodic_Task;

   type Periodic_Task_Access_Array is array (Positive range <>)
     of  Periodic_Task_Access;

private

   procedure Run
     (Configuration   : Master_Configuration_Access;
      Task_Itf        : Task_Itf_Access;
      Bool_DPM_Access : Bool_Dual_Port_Memory_Access;
      Word_DPM_Access : Word_Dual_Port_Memory_Access);
   --  The job of the periodic task

end Rx.Com.Modbus.Rtu.Master;
