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

with Ada.Real_Time; use Ada.Real_Time;
with Ada.Exceptions; use Ada.Exceptions;

with Rx.Sys.Log;

with Rx.Sys.Timers.TON; use Rx.Sys.Timers;

package body Rx.Com.Modbus.Rtu.Master is

   package LibModbus renames Rx.Com.Protocols.LibModbus;

   protected body Task_Status is

      procedure Terminated (Value : in Boolean) is
      begin
         Status.Terminated := Value;
      end Terminated;

      function Terminated return Boolean is
      begin
         return Status.Terminated;
      end Terminated;

      procedure Connected
        (Value : in Boolean) is
      begin
         Status.Connected := Value;
      end Connected;

      function Connected return Boolean is
      begin
         return Status.Connected;
      end Connected;

      procedure Set_Command_Status
        (Command    : in Positive;
         Cmd_Status : in Command_Status_Type) is
      begin
         Status.Commands_Status (Command) := Cmd_Status;
      end Set_Command_Status;

      function Get_Command_Status
        (Command    : in Positive)
         return Command_Status_Type is
      begin
         return Status.Commands_Status (Command);
      end Get_Command_Status;

      procedure Set_Command_Retries
        (Command : in Positive;
         Retries : in Natural) is
      begin
         Status.Commands_Data (Command).Retries := Retries;
      end Set_Command_Retries;

      function Get_Command_Retries
        (Command : in Positive)
         return Natural is
      begin
         return Status.Commands_Data (Command).Retries;
      end Get_Command_Retries;

      function Get_Status return Task_Status_Type is
      begin
         return Status;
      end Get_Status;

   end Task_Status;
   
   ---------
   -- Run --
   ---------
   
   procedure Run
     (Configuration   : Master_Configuration_Access;
      Task_Itf        : Task_Itf_Access;
      Bool_DPM_Access : Bool_Dual_Port_Memory_Access;
      Word_DPM_Access : Word_Dual_Port_Memory_Access) is

      My_Ident : constant String := "Rx.Modbus.rtu.Master.Periodic_Task.Run";

      Next_Time : Ada.Real_Time.Time := Clock;
      Period    : constant Time_Span :=
        Milliseconds (Configuration.Task_Period_MS);

      MyContext : LibModbus.Context_Type;

      Command_Scheduling : array (Configuration.Commands'Range) of Natural;

      Command_Index  : Integer;
      Command        : Command_Type;
      Command_Status : Command_Status_Type;
      Command_Retries : Natural;

      subtype Buffer_Bool_T is
        Bool_Array (0 .. MODBUS_MAX_READ_BITS - 1);

      Buffer_Bool : Buffer_Bool_T := (others => False);

      subtype Buffer_Registers_T is
        Word_Array (0 .. MODBUS_MAX_READ_REGISTERS - 1);

      Buffer_Registers : Buffer_Registers_T := (others => 0);

      Context_Ok : Boolean := False;
      Connect_Ok : Boolean := False;

      Watchdog_TON_Q       : Boolean := False;
      Watchdog_Error       : Boolean := False;

      Faults_TON         : TON.Instance;
      Faults_TON_Elapsed : Ada.Real_Time.Time_Span := Time_Span_Zero;
      Faults_TON_Start   : Boolean := False;
      Faults_TON_Q       : Boolean := False;

      procedure Close;

      procedure Close is
         My_Ident : constant String := "Rx.Modbus.Rtu.Master.Run.Close";
      begin
         if Connect_Ok then
            LibModbus.Close (Context => MyContext);
            Connect_Ok := False;
            Task_Itf.Status.Connected (False);

         end if;

         if Context_Ok then
            LibModbus.Free (Context => MyContext);
            Context_Ok := False;
         end if;
         Rx.Sys.Log.Logger.Put (Who  => My_Ident,
				What => "Closing gracefully.");
      end Close;

   begin

      for Index in Command_Scheduling'Range loop
         Command_Scheduling (Index) :=
           Configuration.Commands (Index).Period_Multiple
           + Configuration.Commands (Index).Shift;
      end loop;

      loop
         Next_Time := Next_Time + Period;

         Task_Itf.Status_Watchdog.Watchdog
           (Watching         => Task_Itf.Control.Start_Watching,
            Control_Watchdog => Task_Itf.Control_Watchdog.Value,
            Error            => Watchdog_TON_Q);

         if Watchdog_TON_Q and not Watchdog_Error then
            Rx.Sys.Log.Logger.Put (Who  => My_Ident,
				   What => "Watchdog Time Out elapsed!");
            Watchdog_Error := True;
         end if;

         if Configuration.Enabled then

            if not Context_Ok then

               MyContext := LibModbus.New_RTU
                 (Device    => To_String (Configuration.Device),
                  Baud_Rate => Configuration.Baud_Rate,
                  Parity    => Configuration.Parity,
                  Data_Bits => Configuration.Data_Bits,
                  Stop_Bits => Configuration.Stop_Bits);

               LibModbus.Set_Debug (Context => MyContext,
                                    On      => Configuration.Debug_On);

               LibModbus.Set_Response_Timeout
                 (Context => MyContext,
                  Timeout => Configuration.Timeout);

               Context_Ok := True;
            end if;

            if not Connect_Ok then
               LibModbus.Connect (Context => MyContext);
               Connect_Ok := True;
               Task_Itf.Status.Connected (True);
            else

               Faults_TON_Start := not Faults_TON_Q;

               Faults_TON.Cyclic
                 (Start   => Faults_TON_Start,
                  Preset  => Ada.Real_Time.Milliseconds (Faults_Time_Out_MS),
                  Elapsed => Faults_TON_Elapsed,
                  Q       => Faults_TON_Q);

               if Faults_TON_Q then
                  for Index in Configuration.Commands'Range
                  loop
                     if Fault = Task_Itf.Status.Get_Command_Status (Index) then
                        Task_Itf.Status.Set_Command_Status (Index, Unknown);
                        Task_Itf.Status.Set_Command_Retries
                          (Index, Configuration.Retries);
                     end if;
                  end loop;
               end if;

               Process_All_Commands :
               for Index in Configuration.Commands'Range loop

                  Command_Index := Index;
                  Command := Configuration.Commands (Index);
                  Command_Status := Task_Itf.Status.Get_Command_Status (Index);

                  if Command_Status = Unknown or Command_Status = Fine then

                     if Command_Scheduling (Index) > 0 then
                        Command_Scheduling (Index) :=
                          Command_Scheduling (Index) - 1;
                     else
                        Command_Scheduling (Index) :=
                          Command.Period_Multiple;

                        LibModbus.Set_Slave
                          (Context => MyContext,
                           Slave   => Command.Slave);

                        case Command.Action is

                        when Read_Bits =>

                           LibModbus.Read_Bits
                             (Context => MyContext,
                              Offset  => Command.Offset_Remote,
                              Number  => Command.Number,
                              Dest    => Buffer_Bool);

                           Bool_DPM_Access.Inputs.Set_Data
                             (Data_In => Buffer_Bool
                                (0 .. Command.Number - 1),
                              Offset  => Command.Offset_Local);

                        when Read_Input_Bits =>

                           LibModbus.Read_Input_Bits
                             (Context => MyContext,
                              Offset  => Command.Offset_Remote,
                              Number  => Command.Number,
                              Dest    => Buffer_Bool);

                           Bool_DPM_Access.Inputs.Set_Data
                             (Data_In => Buffer_Bool
                                (0 .. Command.Number - 1),
                              Offset  => Command.Offset_Local);

                        when Read_Registers =>

                           LibModbus.Read_Registers
                             (Context => MyContext,
                              Offset  => Command.Offset_Remote,
                              Number  => Command.Number,
                              Dest    => Buffer_Registers);

                           Word_DPM_Access.Inputs.Set_Data
                             (Data_In => Buffer_Registers
                                (0 .. Command.Number - 1),
                              Offset  => Command.Offset_Local);

                        when Read_Input_Registers =>

                           LibModbus.Read_Input_Registers
                             (Context => MyContext,
                              Offset  => Command.Offset_Remote,
                              Number  => Command.Number,
                              Dest    => Buffer_Registers);

                           Word_DPM_Access.Inputs.Set_Data
                             (Data_In => Buffer_Registers
                                (0 .. Command.Number - 1),
                              Offset  => Command.Offset_Local);

                        when Write_Bit =>

                           Buffer_Bool (0 .. 0) :=
                             Bool_DPM_Access.Outputs.Get_Data
                               (Offset => Command.Offset_Local,
                                Number => 1);

                           LibModbus.Write_Bit
                             (Context => MyContext,
                              Offset  => Command.Offset_Remote,
                              Value   => Buffer_Bool (0));

                        when Write_Register =>

                           Buffer_Registers (0 .. 0) :=
                             Word_DPM_Access.Outputs.Get_Data
                               (Offset => Command.Offset_Local,
                                Number => 1);

                           LibModbus.Write_Register
                             (Context => MyContext,
                              Offset  => Command.Offset_Remote,
                              Value   => Buffer_Registers (0));

                        when Write_Bits =>

                           Buffer_Bool (0 .. Command.Number - 1) :=
                             Bool_DPM_Access.Outputs.Get_Data
                               (Offset => Command.Offset_Local,
                                Number => Command.Number);

                           LibModbus.Write_Bits
                             (Context => MyContext,
                              Offset  => Command.Offset_Remote,
                              Number  => Command.Number,
                              Data    => Buffer_Bool);

                        when Write_Registers =>

                           Buffer_Registers (0 .. Command.Number - 1) :=
                             Word_DPM_Access.Outputs.Get_Data
                               (Offset => Command.Offset_Local,
                                Number => Command.Number);

                           LibModbus.Write_Registers
                             (Context => MyContext,
                              Offset  => Command.Offset_Remote,
                              Number  => Command.Number,
                              Data    => Buffer_Registers);

                        when Write_Read_Registers =>

                           Buffer_Registers (0 .. Command.Write_Number - 1) :=
                             Word_DPM_Access.Outputs.Get_Data
                               (Offset => Command.Write_Offset_Local,
                                Number => Command.Write_Number);

                           LibModbus.Write_Read_Registers
                             (Context => MyContext,
                              Write_Offset  => Command.Write_Offset_Remote,
                              Write_Number  => Command.Write_Number,
                              Write_Data    => Buffer_Registers,
                              Read_Offset   => Command.Read_Offset_Remote,
                              Read_Number   => Command.Read_Number,
                              Read_Dest     => Buffer_Registers);

                           Word_DPM_Access.Inputs.Set_Data
                             (Data_In => Buffer_Registers
                                (0 .. Command.Read_Number - 1),
                              Offset  => Command.Read_Offset_Local);

                        end case;

                        Task_Itf.Status.Set_Command_Status (Index, Fine);

                     end if;

                  end if;

               end loop Process_All_Commands;

            end if;

         end if;

         exit when Task_Itf.Control.Quit;
         delay until Next_Time;

      end loop;

      Close;

   exception

      when Error : LibModbus.Context_Error | LibModbus.Connect_Error =>

         Rx.Sys.Log.Logger.Put (Who  => My_Ident,
                             What => "libmodbus exception: " & CRLF
                             & Exception_Information (Error));

         for Index in Configuration.Commands'Range
         loop
            if not (Disabled = Task_Itf.Status.Get_Command_Status (Index)) then
               Task_Itf.Status.Set_Command_Status (Index, Unknown);
            end if;
         end loop;

         Close;

      when Error : others =>

         Rx.Sys.Log.Logger.Put (Who  => My_Ident,
                             What => "Command (" & Command_Index'Img & ") "
                             & "Unexpected exception: " & CRLF
                             & Exception_Information (Error));

         for Index in Configuration.Commands'Range
         loop
            if not (Disabled = Task_Itf.Status.Get_Command_Status (Index)) then
               Task_Itf.Status.Set_Command_Status (Index, Unknown);
            end if;
         end loop;

         Command_Retries :=
           Task_Itf.Status.Get_Command_Retries (Command_Index);

         if Command_Retries > 0 then
            Task_Itf.Status.Set_Command_Retries
              (Command_Index, Command_Retries - 1);
         else
            Task_Itf.Status.Set_Command_Status (Command_Index, Fault);
         end if;

         Close;

   end Run;
   --  The job of the periodic task

   task body Periodic_Task is
      My_Ident : constant String := "Rxrt.MBRTU_Master.Periodic_Task";
   begin
      Rx.Sys.Log.Logger.Put (Who  => My_Ident,
                          What => "started !");

      for Index in Configuration.Commands'Range
      loop
         if not Configuration.Commands (Index).Enabled then
            Task_Itf.Status.Set_Command_Status (Index, Disabled);
         end if;
         Task_Itf.Status.Set_Command_Retries (Index, Configuration.Retries);
      end loop;

      loop

         Run (Configuration, Task_Itf, Bool_DPM_Access, Word_DPM_Access);

         Rx.Sys.Log.Logger.Put (Who  => My_Ident,
                             What => "Oups !");

         exit when Task_Itf.Control.Quit;
         delay 1.0; -- Wait some seconds and retry
      end loop;

      Rx.Sys.Log.Logger.Put (Who  => My_Ident,
                          What => "finished !");

      Task_Itf.Status.Terminated (Task_Itf.Control.Quit);
   end Periodic_Task;
   
end Rx.Com.Modbus.Rtu.Master;
