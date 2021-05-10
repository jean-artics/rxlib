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

with System; use System;
with GNAT.OS_Lib; -- GNAT.OS_Lib.Errno
--  with System.OS_Interface; -- System.OS_Interface.errno

with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings;

package body Rx.Com.Protocols.LibModbus is
   
   ---------------------
   -- Modbus_Strerror --
   ---------------------
   
   function Modbus_Strerror return String is

      function C_Modbus_Strerror (errnum : in Interfaces.C.int)
                                  return Interfaces.C.Strings.chars_ptr;
      --  const char *modbus_strerror(int errnum);
      pragma Import (C, C_Modbus_Strerror, "modbus_strerror");

      Error_Number : Integer;
   begin
      Error_Number := GNAT.OS_Lib.Errno;
      return "(" & Integer'Image (Error_Number) & ") : " &
        Interfaces.C.Strings.Value
        (C_Modbus_Strerror (Interfaces.C.int (Error_Number)));
   end Modbus_Strerror;
   
   -----------------
   -- To_Duration --
   -----------------
   
   function To_Duration (Timeval : in Struct_Timeval) return Duration is
   begin
      return Duration (Timeval.tv_sec) + Duration (Timeval.tv_usec) / Micro_F;
   end To_Duration;
   
   ----------------
   -- To_Timeval --
   ----------------
   
   function To_Timeval (D : Duration) return Struct_Timeval is
      
      Secs       : Duration;
      Micro_Secs : Duration;
      Timeval    : Struct_Timeval;
   begin
      --  Seconds extraction, avoid potential rounding errors

      Secs           := D - 0.5;
      Timeval.Tv_Sec := C.Long (Secs);

      --  Microseconds extraction

      Micro_Secs      := D - Duration (Timeval.Tv_Sec);
      Timeval.Tv_Usec := C.Long (Micro_Secs * Micro);

      return Timeval;
   end To_Timeval;
   
   ---------------
   -- Set_Debug --
   ---------------
   
   procedure Set_Debug
     (Context : in Context_Type;
      On      : in Boolean) is

      procedure Modbus_Set_Debug
	(Context : in Context_Type;
	 On      : in Interfaces.C.int);
      --  void modbus_set_debug(modbus_t *ctx, int boolean);
      pragma Import (C, Modbus_Set_Debug, "modbus_set_debug");

      Debug_On : Interfaces.C.int;
   begin
      if On then
         Debug_On := 1;
      else
         Debug_On := 0;
      end if;
      Modbus_Set_Debug (Context => Context, On => Debug_On);
   end Set_Debug;
   
   ---------------
   -- Set_Slave --
   ---------------
   
   procedure Set_Slave
     (Context : in Context_Type;
      Slave   : in Slave_Address) is

      function Modbus_Set_Slave
        (Context : in Context_Type;
         Slave   : in Interfaces.C.int) return Interfaces.C.int;
      --  int modbus_set_slave(modbus_t* ctx, int slave);
      pragma Import
        (C, Modbus_Set_Slave, "modbus_set_slave");

      Result : Interfaces.C.int;
   begin
      Result := Modbus_Set_Slave (Context, Interfaces.C.int (Slave));
      
      if Result = -1 then
         raise Other_Error with Modbus_Strerror;
      end if;
   end Set_Slave;
   
   --------------------------
   -- Get_Response_Timeout --
   --------------------------
   
   function Get_Response_Timeout (Context : in Context_Type) return Duration is

      procedure Modbus_Get_Response_Timeout
        (Context : in Context_Type;
         Timeout : System.Address);
      --  void modbus_get_response_timeout
      --                             (modbus_t *ctx, struct timeval *timeout);
      pragma Import
        (C, Modbus_Get_Response_Timeout, "modbus_get_response_timeout");

      Timeout : Struct_Timeval := (0, 0);
   begin
      Modbus_Get_Response_Timeout (Context, Timeout'Address);
      return To_Duration (Timeout);
   end Get_Response_Timeout;
   
   --------------------------
   -- Set_Response_Timeout --
   --------------------------
   
   procedure Set_Response_Timeout
     (Context : in Context_Type;
      Timeout : in Duration) is

      procedure Modbus_Set_Response_Timeout
        (Context : in Context_Type;
         Timeout : System.Address);
      --  void modbus_set_response_timeout
      --                        (modbus_t *ctx, const struct timeval *timeout);
      pragma Import
        (C, Modbus_Set_Response_Timeout, "modbus_set_response_timeout");

      Timeval : Struct_Timeval := (0, 0);
   begin
      Timeval := To_Timeval (Timeout);
      Modbus_Set_Response_Timeout (Context, Timeval'Address);
   end Set_Response_Timeout;
   
   -------------
   -- New_TCP --
   -------------
   
   function New_TCP
     (IP_Address : in String;
      Port       : in TCP_Port_Type) return Context_Type is

      function Modbus_New_TCP
        (IP_Address : in Interfaces.C.Strings.chars_ptr;
         Port       : in Interfaces.C.int)
         return System.Address;
      --  modbus_t* modbus_new_tcp(const char *ip_address, int port);
      pragma Import (C, Modbus_New_TCP, "modbus_new_tcp");

      IP_Address_ptr : Interfaces.C.Strings.chars_ptr;
      Result         : System.Address;
   begin
      IP_Address_ptr := Interfaces.C.Strings.New_String (IP_Address);
      Result := Modbus_New_TCP
	(IP_Address => IP_Address_ptr,
	 Port       => Interfaces.C.int (Port));
      
      Interfaces.C.Strings.Free (IP_Address_ptr);
      
      if Result = System.Null_Address then
         raise Context_Error with Modbus_Strerror;
      end if;

      return Context_Type (Result);
   end New_TCP;
   
   -------------
   -- Connect --
   -------------
   
   procedure Connect (Context : in Context_Type) is

      function Modbus_Connect (Context : in Context_Type)
                               return Interfaces.C.int;
      --  int modbus_connect(modbus_t *ctx);
      pragma Import (C, Modbus_Connect, "modbus_connect");
   begin
      if Modbus_Connect (Context) = -1 then
         raise Connect_Error with Modbus_Strerror;
      end if;
   end Connect;
   
   ---------------
   -- Read_Bits --
   ---------------
   
   procedure Read_Bits
     (Context     : in Context_Type;
      Offset      : in Offset_Type;
      Number      : in Read_Bits_Quantity_Type;
      Dest        : out Bool_Array) is

      function Modbus_Read_Bits
        (Context     : in Context_Type;
         Offset      : in Interfaces.C.int;
         Number      : in Interfaces.C.int;
         Dest        : Byte_Array)
         return Interfaces.C.int;
      --  int modbus_read_bits(modbus_t *ctx, int addr, int nb, uint8_t *dest);
      pragma Import (C, Modbus_Read_Bits, "modbus_read_bits");

      Byte_Buffer : Byte_Array (Dest'First .. Dest'First + Number - 1) :=
        (others => C_FALSE);
   begin
      if Modbus_Read_Bits
	(Context, 
	 Interfaces.C.int (Offset),
	 Interfaces.C.int (Number),
	 Byte_Buffer) = -1
      then
         raise Other_Error with Modbus_Strerror;
	 
      else
         for I in Byte_Buffer'Range loop

            if Byte_Buffer (I) = C_FALSE then
               Dest (I) := False;
            else
               Dest (I) := True;
            end if;
         end loop;
      end if;
   end Read_Bits;
   
   ---------------------
   -- Read_Input_Bits --
   ---------------------
   
   procedure Read_Input_Bits
     (Context : in Context_Type;
      Offset  : in Offset_Type;
      Number  : in Read_Bits_Quantity_Type;
      Dest    : out Bool_Array) is

      function Modbus_Read_Input_Bits
        (Context : in Context_Type;
         Offset  : in Interfaces.C.int;
         Number  : in Interfaces.C.int;
         Dest    : Byte_Array) return Interfaces.C.int;
      --  int modbus_read_input_bits
      --                     (modbus_t *ctx, int addr, int nb, uint8_t *dest);
      pragma Import (C, Modbus_Read_Input_Bits, "modbus_read_input_bits");

      Byte_Buffer : Byte_Array (Dest'First .. Dest'First + Number - 1) :=
        (others => C_FALSE);
   begin
      if Modbus_Read_Input_Bits
	(Context,
	 Interfaces.C.int (Offset),
	 Interfaces.C.int (Number),
	 Byte_Buffer) = -1
      then
         raise Other_Error with Modbus_Strerror;
	 
      else
         for I in Byte_Buffer'Range loop

            if Byte_Buffer (I) = C_FALSE then
               Dest (I) := False;
            else
               Dest (I) := True;
            end if;
         end loop;
      end if;
   end Read_Input_Bits;
   
   --------------------
   -- Read_Registers --
   --------------------
   
   procedure Read_Registers
     (Context : in Context_Type;
      Offset  : in Offset_Type;
      Number  : in Read_Register_Quantity_Type;
      Dest    : Word_Array) is

      function Modbus_Read_Registers
        (Context : in Context_Type;
         Offset  : in Interfaces.C.int;
         Number  : in Interfaces.C.int;
         Dest    : Word_Array) return Interfaces.C.int;
      --  int modbus_read_registers(modbus_t *ctx, int addr,
      --                          int nb, uint16_t *dest);
      pragma Import (C, Modbus_Read_Registers, "modbus_read_registers");

   begin
      if Modbus_Read_Registers
	(Context,
	 Interfaces.C.int (Offset),
	 Interfaces.C.int (Number),
	 Dest) = -1
      then
         raise Other_Error with Modbus_Strerror;
      end if;
   end Read_Registers;
   
   --------------------------
   -- Read_Input_Registers --
   --------------------------
   
   procedure Read_Input_Registers
     (Context     : in Context_Type;
      Offset      : in Offset_Type;
      Number      : in Read_Register_Quantity_Type;
      Dest        : Word_Array) is

      function Modbus_Read_Input_Registers
        (Context     : in Context_Type;
         Offset      : in Interfaces.C.int;
         Number      : in Interfaces.C.int;
         Dest        : Word_Array) return Interfaces.C.int;
      --  int modbus_read_input_registers(modbus_t *ctx, int addr,
      --                                int nb, uint16_t *dest);
      pragma Import
        (C, Modbus_Read_Input_Registers, "modbus_read_input_registers");

   begin
      if Modbus_Read_Input_Registers
	(Context,
	 Interfaces.C.int (Offset),
	 Interfaces.C.int (Number),
	 Dest) = -1
      then
         raise Other_Error with Modbus_Strerror;
      end if;
   end Read_Input_Registers;
   
   ---------------
   -- Write_Bit --
   ---------------
   
   procedure Write_Bit
     (Context : in Context_Type;
      Offset  : in Offset_Type;
      Value   : in Boolean) is

      function Modbus_Write_Bit
        (Context : in Context_Type;
         Offset  : in Interfaces.C.int;
         Value   : in Interfaces.C.int) return Interfaces.C.int;
      --  int modbus_write_bit (modbus_t *ctx, int coil_addr, int status);
      pragma Import (C, Modbus_Write_Bit, "modbus_write_bit");

      C_Value :  Interfaces.C.int := C_FALSE;
   begin
      if Value then
         C_Value := C_TRUE;
      end if;

      if Modbus_Write_Bit
	(Context,
	 Interfaces.C.int (Offset),
	 C_Value) = -1
      then
         raise Other_Error with Modbus_Strerror;
      end if;
   end Write_Bit;
   
   --------------------
   -- Write_Register --
   --------------------
   
   procedure Write_Register
     (Context : in Context_Type;
      Offset  : in Offset_Type;
      Value   : in Word) is

      function Modbus_Write_Register
        (Context : in Context_Type;
         Offset  : in Interfaces.C.int;
         Value   : in Interfaces.C.int) return Interfaces.C.int;
      --  int modbus_write_register(modbus_t *ctx, int reg_addr, int value);
      pragma Import (C, Modbus_Write_Register, "modbus_write_register");

   begin
      if Modbus_Write_Register
	(Context,
	 Interfaces.C.int (Offset),
	 Interfaces.C.int (Value)) = -1
      then
         raise Other_Error with Modbus_Strerror;
      end if;
   end Write_Register;
   
   ----------------
   -- Write_Bits --
   ----------------
   
   procedure Write_Bits
     (Context : in Context_Type;
      Offset  : in Offset_Type;
      Number  : in Write_Bits_Quantity_Type;
      Data    : Bool_Array) is

      function Modbus_Write_Bits
        (Context : in Context_Type;
         Offset  : in Interfaces.C.int;
         Number  : in Interfaces.C.int;
         Data    : Byte_Array) return Interfaces.C.int;
      --  int modbus_write_bits(modbus_t *ctx, int addr,
      --                            int nb, const uint8_t *data);
      pragma Import (C, Modbus_Write_Bits, "modbus_write_bits");

      Byte_Buffer : Byte_Array (Data'First .. Data'First + Number - 1) :=
        (others => C_FALSE);
   begin
      for I in Data'Range loop

         if Data (I) then
            Byte_Buffer (I) := C_TRUE;
         end if;
      end loop;

      if Modbus_Write_Bits
	(Context,
	 Interfaces.C.int (Offset),
	 Interfaces.C.int (Number),
	 Byte_Buffer) = -1
      then
         raise Other_Error with Modbus_Strerror;
      end if;
   end Write_Bits;
   
   ---------------------
   -- Write_Registers --
   ---------------------
   
   procedure Write_Registers
     (Context : in Context_Type;
      Offset  : in Offset_Type;
      Number  : in Write_Register_Quantity_Type;
      Data    : Word_Array) is

      function Modbus_Write_Registers
        (Context : in Context_Type;
         Offset  : in Interfaces.C.int;
         Number  : in Interfaces.C.int;
         Data    : Word_Array) return Interfaces.C.int;
      --  int modbus_write_registers(modbus_t *ctx, int addr,
      --                            int nb, const uint16_t *data);
      pragma Import (C, Modbus_Write_Registers, "modbus_write_registers");

   begin
      if Modbus_Write_Registers
	(Context,
	 Interfaces.C.int (Offset),
	 Interfaces.C.int (Number),
	 Data) = -1
      then
         raise Other_Error with Modbus_Strerror;
      end if;
   end Write_Registers;
   
   --------------------------
   -- Write_Read_Registers --
   --------------------------
   
   procedure Write_Read_Registers
     (Context      : in Context_Type;
      Write_Offset : in Offset_Type;
      Write_Number : in Read_Write_Register_Quantity_Type;
      Write_Data   : Word_Array;
      Read_Offset  : in Offset_Type;
      Read_Number  : in Read_Write_Register_Quantity_Type;
      Read_Dest    : Word_Array) is

      function Modbus_Write_Read_Registers
        (Context      : in Context_Type;
         Write_Offset : in Interfaces.C.int;
         Write_Number : in Interfaces.C.int;
         Write_Data   : Word_Array;
         Read_Offset  : in Interfaces.C.int;
         Read_Number  : in Interfaces.C.int;
         Read_Dest    : Word_Array) return Interfaces.C.int;
      --  int modbus_write_and_read_registers
      --                  (modbus_t *ctx,
      --                   int write_addr, int write_nb, const uint16_t *src,
      --                   int read_addr, int read_nb, uint16_t *dest);
      pragma Import (C, Modbus_Write_Read_Registers,
                     "modbus_write_and_read_registers");

   begin
      if Modbus_Write_Read_Registers
        (Context,
         Interfaces.C.int (Write_Offset),
         Interfaces.C.int (Write_Number),
         Write_Data,
         Interfaces.C.int (Read_Offset),
         Interfaces.C.int (Read_Number),
         Read_Dest) = -1
      then
         raise Other_Error with Modbus_Strerror;
      end if;
   end Write_Read_Registers;
   
   -----------------
   -- Mapping_New --
   -----------------
   
   function Mapping_New
     (Nb_Coil_Status       : in Interfaces.C.int;
      Nb_Input_Status      : in Interfaces.C.int;
      Nb_Holding_Registers : in Interfaces.C.int;
      Nb_Input_Registers   : in Interfaces.C.int)
      return System.Address is

      function Modbus_Mapping_New
        (Nb_Coil_Status       : in Interfaces.C.int;
         Nb_Input_Status      : in Interfaces.C.int;
         Nb_Holding_Registers : in Interfaces.C.int;
         Nb_Input_Registers   : in Interfaces.C.int) return System.Address;
      --  modbus_mapping_t* modbus_mapping_new
      --                    (int nb_coil_status, int nb_input_status,
      --                     int nb_holding_registers, int nb_input_registers);
      pragma Import (C, Modbus_Mapping_New, "modbus_mapping_new");

      Result : System.Address;
   begin
      Result := Modbus_Mapping_New
	(Nb_Coil_Status,
	 Nb_Input_Status,
	 Nb_Holding_Registers,
	 Nb_Input_Registers);
      
      if Result = System.Null_Address then
         raise Other_Error with Modbus_Strerror;
      end if;

      return Result;
   end Mapping_New;
   
   ----------------
   -- TCP_Listen --
   ----------------
   
   function TCP_Listen
     (Context       : in Context_Type;
      Nb_Connection : in Integer) return Socket_Type is

      function Modbus_TCP_Listen 
	(Context       : in Context_Type;
	 Nb_Connection : in Interfaces.C.int) return Socket_Type;
      --  int modbus_tcp_listen(modbus_t *ctx, int nb_connection);
      pragma Import (C, Modbus_TCP_Listen, "modbus_tcp_listen");

      Result : Socket_Type;
   begin
      Result := Modbus_TCP_Listen
	(Context, Interfaces.C.int (Nb_Connection));
      
      if Result = No_Socket then
         raise Other_Error with Modbus_Strerror;
      end if;

      return Result;
   end TCP_Listen;
   
   ----------------
   -- TCP_Accept --
   ----------------
   
   procedure TCP_Accept
     (Context       : in Context_Type;
      Socket_Access : in System.Address) is

      function Modbus_TCP_Accept
	(Context       : in Context_Type;
	 Socket_Access : in System.Address) return Interfaces.C.int;
      --  int modbus_tcp_accept(modbus_t *ctx, int *socket);
      pragma Import (C, Modbus_TCP_Accept, "modbus_tcp_accept");

      Result : Interfaces.C.int;
   begin
      Result := Modbus_TCP_Accept (Context,
                                   Socket_Access);
      if Result = -1 then
         raise Other_Error with Modbus_Strerror;
      end if;
   end TCP_Accept;
   
   -------------
   -- New_RTU --
   -------------
   
   function New_RTU
     (Device    : in String;
      Baud_Rate : in Baud_Rate_Type;
      Parity    : in Parity_Type;
      Data_Bits : in Data_Bits_Type;
      Stop_Bits : in Stop_Bits_Type) return Context_Type is

      function Modbus_New_RTU
        (Device    : in Interfaces.C.Strings.chars_ptr;
         Baud_Rate : in Interfaces.C.int;
         Parity    : in Interfaces.C.char;
         Data_Bits : in Interfaces.C.int;
         Stop_Bits : in Interfaces.C.int) return System.Address;
      --  modbus_t* modbus_new_rtu(const char *device, int baud, char parity,
      --                           int data_bit, int stop_bit);
      pragma Import (C, Modbus_New_RTU, "modbus_new_rtu");

      Device_Ptr  : Interfaces.C.Strings.chars_ptr;
      Parity_Char : Interfaces.C.char;
      Result      : System.Address;
   begin
      Device_Ptr := Interfaces.C.Strings.New_String (Device);

      case Parity is
         when None => Parity_char := Interfaces.C.To_C ('N');
         when Even => Parity_char := Interfaces.C.To_C ('E');
         when Odd  => Parity_char := Interfaces.C.To_C ('O');
      end case;

      Result := Modbus_New_RTU
        (Device    => Device_ptr,
         Baud_Rate => Interfaces.C.int (Baud_Rate'Enum_Rep),
         Parity    => Parity_char,
         Data_Bits => Interfaces.C.int (Data_Bits),
         Stop_Bits => Interfaces.C.int (Stop_Bits));

      Interfaces.C.Strings.Free (Device_ptr);

      if Result = System.Null_Address then
         raise Context_Error with Modbus_Strerror;
      end if;

      return Context_Type (Result);
   end New_RTU;
   
   -------------------------
   -- RTU_Set_Serial_Mode --
   -------------------------
   
   procedure RTU_Set_Serial_Mode
     (Context : in Context_Type;
      Mode    : in Serial_Mode_Type) is

      function Modbus_RTU_Set_Serial_Mode
        (Context : in Context_Type;
         Mode    : in Interfaces.C.int) return Interfaces.C.int;
      --  int modbus_rtu_set_serial_mode(modbus_t *ctx, int mode);
      pragma Import
        (C, Modbus_RTU_Set_Serial_Mode, "modbus_rtu_set_serial_mode");

      Result : Interfaces.C.int;
   begin
      Result := Modbus_RTU_Set_Serial_Mode
        (Context, Interfaces.C.int (Mode'Enum_Rep));
      if Result = -1 then
         raise Other_Error with Modbus_Strerror;
      end if;
   end RTU_Set_Serial_Mode;
   
   -------------------------
   -- RTU_Get_Serial_Mode --
   -------------------------
   
   procedure RTU_Get_Serial_Mode
     (Context : in  Context_Type;
      Mode    : out Serial_Mode_Type) is

      function Modbus_RTU_Get_Serial_Mode
        (Context : in Context_Type) return Interfaces.C.int;
      --  int modbus_rtu_get_serial_mode(modbus_t *ctx);
      pragma Import
        (C, Modbus_RTU_Get_Serial_Mode, "modbus_rtu_get_serial_mode");

      Result : Interfaces.C.int;
   begin
      Result := Modbus_RTU_Get_Serial_Mode (Context);
      
      if Result = -1 then
         raise Other_Error with Modbus_Strerror;
	 
      elsif Result = 0 then
         Mode := RS232;
	 
      elsif Result = 1 then
         Mode := RS485;
	 
      else
         raise Other_Error with "Modbus_RTU_Get_Serial_Mode returned : "
           & Integer'Image (Integer (Result));
      end if;
   end RTU_Get_Serial_Mode;

end Rx.Com.Protocols.LibModbus;
