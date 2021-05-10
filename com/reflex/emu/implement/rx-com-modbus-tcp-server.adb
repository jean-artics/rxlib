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

with Ada.Text_Io; use Ada.Text_Io;

with Interfaces.C; use Interfaces.C;

with Ada.Exceptions; use Ada.Exceptions;
with Ada.Unchecked_Conversion;

with GNAT.Sockets; use GNAT.Sockets;

with Rx.Sys.Log;

package body Rx.Com.Modbus.Tcp.Server is

   protected body Server_Status is

      procedure Set_Terminated (Value : in Boolean) is
      begin
         Status.Terminated := Value;
      end Set_Terminated;

      function Get_Terminated return Boolean is
      begin
         return Status.Terminated;
      end Get_Terminated;

      procedure Update_Commands_Status
	(Commands_Status : Commands_Status_Type) is
      begin
         Status.Commands_Status := Commands_Status;
      end Update_Commands_Status;

      function Get_Status return Server_Status_Type is
      begin
         return Status;
      end Get_Status;

   end Server_Status;
   
   ---------
   -- Run --
   ---------
   
   procedure Run
     (Configuration : Server_Configuration_Access;
      Server_Itf    : Server_Interface_Access) is
      
      My_Ident : constant String := "Rx.Com.Modbus.Tcp.Server.Run";

      type Function_Code is
        (Read_Coils,
         Read_Discrete_Inputs,
         Read_Holding_Registers,
         Read_Input_Registers,
         Write_Single_Coil,
         Write_Single_Register,
         Write_Multiple_Coils,
         Write_Multiple_Registers,
         Write_Read_Registers);
      
      for Function_Code use
        (Read_Coils               =>  1,
         Read_Discrete_Inputs     =>  2,
         Read_Holding_Registers   =>  3,
         Read_Input_Registers     =>  4,
         Write_Single_Coil        =>  5,
         Write_Single_Register    =>  6,
         Write_Multiple_Coils     => 15,
         Write_Multiple_Registers => 16,
         Write_Read_Registers     => 23);
      for Function_Code'Size use Byte'Size;

      Function_Code_Index : constant := 7;
      --  Request(0..6) is header

      function Byte_To_Function_Code is new Ada.Unchecked_Conversion
        (Source => Byte,
         Target => Function_Code);

      MyContext         : LibModbus.Context_Type;
      Result            : Interfaces.C.int;
      pragma Unreferenced (Result);
      Req_Len           : Interfaces.C.int;
      Request           : aliased Byte_Array :=
        (0 .. LibModbus.MODBUS_TCP_MAX_ADU_LENGTH => 0);

      Server_Socket     : LibModbus.Socket_Type;
      Master_Socket     : LibModbus.Socket_Type;

      Refset            : Socket_Set_Type;
      Rdset             : Socket_Set_Type;
      Wtset             : Socket_Set_Type;

      Selector          : Selector_Type;
      Select_Status     : Selector_Status;

      Time_Out          : constant := 1.0;     -- 1s

      Context_Ok : Boolean := False;
      Connect_Ok : Boolean := False;

      Watchdog_TON_Q       : Boolean := False;
      Watchdog_Error       : Boolean := False;

      procedure Close;

      procedure Close is
         My_Ident : constant String := "Rx.Com.Modbus.Tcp.Server.Run.Close";
      begin
         if Connect_Ok then
            LibModbus.Close (Context => MyContext);
            Connect_Ok := False;
         end if;
         if Context_Ok then
            LibModbus.Free (Context => MyContext);
            Context_Ok := False;
         end if;
         Rx.Sys.Log.Logger.Put
	   (Who  => My_Ident, What => "Closing gracefully.");
      end Close;

   begin
      --  if not initialized this way, LibModbus.Receive fails
      --  TO_DO : Test if Request(0) := 0; would suffice
      
      for Index in Request'Range loop
         Request (Index) := 0;
      end loop;

      MyContext := LibModbus.New_TCP
        (IP_Address => To_String (Configuration.Server_IP_Address),
         Port       => Configuration.Server_TCP_Port);
      Context_Ok := True;

      LibModbus.Set_Debug (Context => MyContext, On => Configuration.Debug_On);

      Server_Socket := LibModbus.TCP_Listen 
	(Context => MyContext, Nb_Connection => 2);
      Connect_Ok := True;

      Rx.Sys.Log.Logger.Put
	(Who  => My_Ident,
	 What => "TCP_Listen... Server_Socket = " & Image (Server_Socket));
      
      Empty (Refset);

      Set (Refset, Server_Socket);

      Create_Selector (Selector);

      --  Wait forever a Client connection until told to quit
      
      loop
         Server_Itf.Status_Watchdog.Watchdog
           (Watching         => Server_Itf.Control.Start_Watching,
            Control_Watchdog => Server_Itf.Control_Watchdog.Value,
            Error            => Watchdog_TON_Q);

         if Watchdog_TON_Q and not Watchdog_Error then
            Rx.Sys.Log.Logger.Put
	      (Who  => My_Ident, 
	       What => "Watchdog Time Out elapsed!");
	    
            Watchdog_Error := True;
         end if;

         Copy (Refset, Rdset);

         Check_Selector (Selector, Rdset, Wtset, Select_Status, Time_Out);

         case Select_Status is
            when Completed =>

               if Is_Set (Rdset, Server_Socket) then
                  --  A client is asking a new connection
                  Rx.Sys.Log.Logger.Put
                    (Who  => My_Ident,
                     What => "A client is asking a new connection");

                  LibModbus.TCP_Accept
                    (Context       => MyContext,
                     Socket_Access => Server_Socket'Address);

                  Master_Socket := LibModbus.Get_Socket (Context => MyContext);

                  Rx.Sys.Log.Logger.Put
                    (Who  => My_Ident,
                     What => "TCP_Accept... Master_Socket = "
		       & Image (Master_Socket));

                  Set (Refset, Master_Socket);

                  Status.Commands_Status.Connected_Clients :=
                    Status.Commands_Status.Connected_Clients + 1;
               else
                  loop
                     Get (Rdset, Master_Socket);
                     exit when Master_Socket = No_Socket;

                     --  An already connected master has sent a new query
                     LibModbus.Set_Socket
		       (Context => MyContext, Socket => Master_Socket);

                     Req_Len := LibModbus.Receive
		       (Context => MyContext, Request => Request);
		     
                     if (Req_Len > 0) then
			
			declare
			   Fct_Code : Function_Code;
			begin
			   Fct_Code := Byte_To_Function_Code
			     (Request (Function_Code_Index));
			   Put_Line ("Fct_Code ===> " & Fct_Code'Img);
			end;
			
                        case Byte_To_Function_Code
                          (Request (Function_Code_Index)) is

                        when Read_Coils =>

                           Status.Commands_Status.Read_Coils_Count :=
                             Status.Commands_Status.Read_Coils_Count + 1;

                           Mem.Coils_RW_Lock.Read_Lock;

                           Result := LibModbus.Reply
                             (Context        => MyContext,
                              Request        => Request,
                              Request_Len    => Req_Len,
                              Mapping_Access => Mem.Get_Mapping);

                           Mem.Coils_RW_Lock.Read_Unlock;

                        when Read_Discrete_Inputs =>

                           Status.Commands_Status.Read_Input_Bits_Count :=
                             Status.Commands_Status.Read_Input_Bits_Count + 1;

                           Mem.Input_Bits_RW_Lock.Read_Lock;

                           Result := LibModbus.Reply
                             (Context        => MyContext,
                              Request        => Request,
                              Request_Len    => Req_Len,
                              Mapping_Access => Mem.Get_Mapping);

                           Mem.Input_Bits_RW_Lock.Read_Unlock;

                        when Read_Holding_Registers =>
                           Status.Commands_Status.Read_Holding_Registers_Count
			     := 
			     Status.Commands_Status.Read_Holding_Registers_Count + 1;

                           Mem.Registers_RW_Lock.Read_Lock;

                           Result := LibModbus.Reply
                             (Context        => MyContext,
                              Request        => Request,
                              Request_Len    => Req_Len,
                              Mapping_Access => Mem.Get_Mapping);

                           Mem.Registers_RW_Lock.Read_Unlock;

                        when Read_Input_Registers =>

                           Status.Commands_Status.Read_Input_Registers_Count :=
                             Status.Commands_Status
                               .Read_Input_Registers_Count + 1;

                           Mem.Input_Registers_RW_Lock.Read_Lock;

                           Result := LibModbus.Reply
                             (Context        => MyContext,
                              Request        => Request,
                              Request_Len    => Req_Len,
                              Mapping_Access => Mem.Get_Mapping);

                           Mem.Input_Registers_RW_Lock.Read_Unlock;

                        when Write_Single_Coil =>

                           Status.Commands_Status.Write_Single_Coil_Count :=
                             Status.Commands_Status
                               .Write_Single_Coil_Count + 1;

                           Mem.Coils_RW_Lock.Write_Lock;

                           Result := LibModbus.Reply
                             (Context        => MyContext,
                              Request        => Request,
                              Request_Len    => Req_Len,
                              Mapping_Access => Mem.Get_Mapping);

                           Mem.Coils_RW_Lock.Write_Unlock;

                        when Write_Single_Register =>

                           Status.Commands_Status
                             .Write_Single_Register_Count :=
                               Status.Commands_Status
                                 .Write_Single_Register_Count + 1;

                           Mem.Registers_RW_Lock.Write_Lock;

                           Result := LibModbus.Reply
                             (Context        => MyContext,
                              Request        => Request,
                              Request_Len    => Req_Len,
                              Mapping_Access => Mem.Get_Mapping);

                           Mem.Registers_RW_Lock.Write_Unlock;

                        when Write_Multiple_Coils =>

                           Status.Commands_Status.Write_Multiple_Coils_Count :=
                             Status.Commands_Status
                               .Write_Multiple_Coils_Count + 1;

                           Mem.Coils_RW_Lock.Write_Lock;

                           Result := LibModbus.Reply
                             (Context        => MyContext,
                              Request        => Request,
                              Request_Len    => Req_Len,
                              Mapping_Access => Mem.Get_Mapping);

                           Mem.Coils_RW_Lock.Write_Unlock;

                        when Write_Multiple_Registers =>

                           Status.Commands_Status
                             .Write_Multiple_Registers_Count :=
                               Status.Commands_Status
                                 .Write_Multiple_Registers_Count + 1;

                           Mem.Registers_RW_Lock.Write_Lock;

                           Result := LibModbus.Reply
                             (Context        => MyContext,
                              Request        => Request,
                              Request_Len    => Req_Len,
                              Mapping_Access => Mem.Get_Mapping);

                           Mem.Registers_RW_Lock.Write_Unlock;

                        when Write_Read_Registers =>

                           Status.Commands_Status.Write_Read_Registers_Count :=
                             Status.Commands_Status
                               .Write_Read_Registers_Count + 1;

                           Mem.Registers_RW_Lock.Write_Lock;

                           Result := LibModbus.Reply
                             (Context        => MyContext,
                              Request        => Request,
                              Request_Len    => Req_Len,
                              Mapping_Access => Mem.Get_Mapping);

                           Mem.Registers_RW_Lock.Write_Unlock;

                        when others =>

                           Status.Commands_Status.Unmanaged_Requests_Count :=
                             Status.Commands_Status
                               .Unmanaged_Requests_Count + 1;

                              Result := LibModbus.Reply
                                (Context        => MyContext,
                                 Request        => Request,
                                 Request_Len    => Req_Len,
                                 Mapping_Access => Mem.Get_Mapping);

                        end case;

                     else
                        --  Connection closed by the client
                        Rx.Sys.Log.Logger.Put
                          (Who  => My_Ident,
                           What => "Connection closed by the client");

                        Close_Socket (Master_Socket);
                        Clear (refset, Master_Socket);

                        Status.Commands_Status.Connected_Clients :=
                          Status.Commands_Status.Connected_Clients - 1;
                     end if;

                  end loop;
               end if;

            when Expired =>
               null;
               --  Rx.Sys.Log.Logger.Put
               --    (Who  => My_Ident,
               --     What => "Check_Selector... Status = Expired");

            when Aborted =>
               Rx.Sys.Log.Logger.Put
                 (Who  => My_Ident,
                  What => "Check_Selector... Status = Aborted");
         end case;

         Server_Itf.Status.Update_Commands_Status (Status.Commands_Status);

         Status.Terminated := Server_Itf.Control.Quit;

         exit when Status.Terminated;

      end loop;

      Close;

   exception
      when Error : LibModbus.Context_Error | LibModbus.Connect_Error =>
         Rx.Sys.Log.Logger.Put
	   (Who  => My_Ident,
	    What => "libmodbus exception: " & CRLF 
	      & Exception_Information (Error));
         Close;

      when Error : others =>
         Rx.Sys.Log.Logger.Put
	   (Who  => My_Ident,
	    What => "Unexpected exception: " & CRLF
	      & Exception_Information (Error));
         Close;

   end Run;

   task body Server_Task is
      My_Ident : constant String := "Rx.ComModbus.Tcp.Server.Server_Task "
        & To_String (Configuration.Server_IP_Address) & ":"
        & Configuration.Server_TCP_Port'Img;

   begin
      Rx.Sys.Log.Logger.Put (Who  => My_Ident, What => "started !");

      loop
         Run (Configuration, Server_Itf);

         Rx.Sys.Log.Logger.Put (Who  => My_Ident, What => "Oups !");

         Status.Terminated := Server_Itf.Control.Quit;
         exit when Status.Terminated;

         delay Configuration.Retries * 1.0; -- Wait 3 seconds and retry
      end loop;

      Rx.Sys.Log.Logger.Put (Who  => My_Ident, What => "finished !");

      Server_Itf.Status.Set_Terminated (Status.Terminated);
      
   exception
      when Error : others =>
         Rx.Sys.Log.Logger.Put
	   (Who  => My_Ident,
	    What => "Unexpected exception: " & CRLF
	      & Exception_Information (Error));
   end Server_Task;
   
end Rx.Com.Modbus.Tcp.Server;
