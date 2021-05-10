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

--  This package provides the binding to libmodbus, a library implementing
--  the Modbus RTU and TCP protocols.

with System;
with Interfaces.C;
with GNAT.Sockets; use GNAT.Sockets;

package Rx.Com.Protocols.LibModbus is

   package C renames Interfaces.C;

   C_FALSE : constant := 0;
   C_TRUE  : constant := 1;

   Context_Error : exception;
   Connect_Error : exception;
   Other_Error   : exception;

   type Action_Type is
     (Read_Bits,
      --  16#01# / 01

      Read_Input_Bits,
      --  16#02# / 02

      Read_Registers,
      --  16#03# / 03

      Read_Input_Registers,
      --  16#04# / 04

      Write_Bit,
      --  16#05# / 05

      Write_Register,
      --  16#06# / 06

      Write_Bits,
      --  16#0F# / 15

      Write_Registers,
      --  16#10# / 16

      Write_Read_Registers
      --  16#17# / 23
     );

   --------------------------------------------------------------------
   --  from modbus.h
   --------------------------------------------------------------------

   MODBUS_BROADCAST_ADDRESS      : constant := 0;
   --  #define MODBUS_BROADCAST_ADDRESS    0

   MODBUS_MAX_READ_BITS          : constant := 2000;
   --  #define MODBUS_MAX_READ_BITS              2000

   MODBUS_MAX_WRITE_BITS         : constant := 1968;
   --  #define MODBUS_MAX_WRITE_BITS             1968

   MODBUS_MAX_READ_REGISTERS     : constant := 125;
   --  #define MODBUS_MAX_READ_REGISTERS          125

   MODBUS_MAX_WRITE_REGISTERS    : constant := 123;
   --  #define MODBUS_MAX_WRITE_REGISTERS         123

   MODBUS_MAX_RW_WRITE_REGISTERS : constant := 121;
   --  #define MODBUS_MAX_RW_WRITE_REGISTERS      121

   subtype Offset_Type is Integer range 0 .. 65535;

   subtype Read_Bits_Quantity_Type is
     Integer range 0 .. MODBUS_MAX_READ_BITS;

   subtype Write_Bits_Quantity_Type is
     Integer range 0 .. MODBUS_MAX_WRITE_BITS;

   subtype Read_Register_Quantity_Type is
     Integer range 0 .. MODBUS_MAX_READ_REGISTERS;

   subtype Write_Register_Quantity_Type is
     Integer range 0 .. MODBUS_MAX_WRITE_REGISTERS;

   subtype Read_Write_Register_Quantity_Type is
     Integer range 0 .. MODBUS_MAX_RW_WRITE_REGISTERS;

   type Context_Type is private;
   --  Modbus context : RTU or TCP

   type Modbus_Mapping_Type is record
      nb_bits             : C.int;
      nb_input_bits       : C.int;
      nb_input_registers  : C.int;
      nb_registers        : C.int;
      tab_bits            : System.Address;
      tab_input_bits      : System.Address;
      tab_input_registers : System.Address;
      tab_registers       : System.Address;
   end record;

   type Modbus_Mapping_Type_Access is access all Modbus_Mapping_Type;
   --     typedef struct {
   --       int nb_bits;
   --       int nb_input_bits;
   --       int nb_input_registers;
   --       int nb_registers;
   --       uint8_t *tab_bits;
   --       uint8_t *tab_input_bits;
   --       uint16_t *tab_input_registers;
   --       uint16_t *tab_registers;
   --     } modbus_mapping_t;

   subtype Slave_Address is Integer range 0 .. 247;

   procedure Set_Slave
     (Context : in Context_Type;
      Slave   : in Slave_Address);
   --  May raise an Error
   --  int modbus_set_slave(modbus_t* ctx, int slave);

   function Get_Response_Timeout (Context : in Context_Type) return Duration;
   --  void modbus_get_response_timeout
   --         (modbus_t *ctx, struct timeval *timeout);

   procedure Set_Response_Timeout
     (Context : in Context_Type;
      Timeout : in Duration);
   --  void modbus_set_response_timeout
   --         (modbus_t *ctx, const struct timeval *timeout);

   procedure Connect (Context : in Context_Type);
   --  May raise an Error
   --  int modbus_connect(modbus_t *ctx);

   procedure Close (Context : in Context_Type);
   --  void modbus_close(modbus_t *ctx);
   pragma Import (C, Close, "modbus_close");

   procedure Free (Context : in Context_Type);
   --  void modbus_free(modbus_t *ctx);
   pragma Import (C, Free, "modbus_free");

   procedure Set_Debug (Context : in Context_Type;
                        On      : in Boolean);
   --  void modbus_set_debug(modbus_t *ctx, int boolean);

   procedure Read_Bits
     (Context : in Context_Type;
      Offset  : in Offset_Type;
      Number  : in Read_Bits_Quantity_Type;
      Dest    : out Bool_Array);
   --  May raise an Error
   --  int modbus_read_bits(modbus_t *ctx, int addr, int nb, uint8_t *dest);
   --  Uses Modbus function code 16#01# / 01

   procedure Read_Input_Bits
     (Context : in Context_Type;
      Offset  : in Offset_Type;
      Number  : in Read_Bits_Quantity_Type;
      Dest    : out Bool_Array);
   --  May raise an Error
   --  int modbus_read_input_bits
   --                     (modbus_t *ctx, int addr, int nb, uint8_t *dest);
   --  Uses Modbus function code 16#02# / 02

   procedure Read_Registers
     (Context : in Context_Type;
      Offset  : in Offset_Type;
      Number  : in Read_Register_Quantity_Type;
      Dest    : Word_Array);
   --  May raise an Error
   --  int modbus_read_registers
   --                       (modbus_t *ctx, int addr, int nb, uint16_t *dest);
   --  Uses Modbus function code 16#03# / 03

   procedure Read_Input_Registers
     (Context : in Context_Type;
      Offset  : in Offset_Type;
      Number  : in Read_Register_Quantity_Type;
      Dest    : Word_Array);
   --  May raise an Error
   --  int modbus_read_input_registers
   --                       (modbus_t *ctx, int addr, int nb, uint16_t *dest);
   --  Uses Modbus function code 16#04# / 04

   procedure Write_Bit
     (Context : in Context_Type;
      Offset  : in Offset_Type;
      Value   : in Boolean);
   --  May raise an Error
   --  int modbus_write_bit (modbus_t *ctx, int coil_addr, int status);
   --  Uses Modbus function code 16#05# / 05

   procedure Write_Register
     (Context : in Context_Type;
      Offset  : in Offset_Type;
      Value   : in Word);
   --  May raise an Error
   --  int modbus_write_register (modbus_t *ctx, int reg_addr, int value);
   --  Uses Modbus function code 16#06# / 06

   procedure Write_Bits
     (Context : in Context_Type;
      Offset  : in Offset_Type;
      Number  : in Write_Bits_Quantity_Type;
      Data    : Bool_Array);
   --  May raise an Error
   --  int modbus_write_bits
   --                  (modbus_t *ctx, int addr, int nb, const uint8_t *data);
   --  Uses Modbus function code 16#0F# / 15

   procedure Write_Registers
     (Context : in Context_Type;
      Offset  : in Offset_Type;
      Number  : in Write_Register_Quantity_Type;
      Data    : Word_Array);
   --  May raise an Error
   --  int modbus_write_registers
   --                  (modbus_t *ctx, int addr, int nb, const uint16_t *data);
   --  Uses Modbus function code 16#10# / 16

   procedure Write_Read_Registers
     (Context      : in Context_Type;
      Write_Offset : in Offset_Type;
      Write_Number : in Read_Write_Register_Quantity_Type;
      Write_Data   : Word_Array;
      Read_Offset  : in Offset_Type;
      Read_Number  : in Read_Write_Register_Quantity_Type;
      Read_Dest    : Word_Array);
   --  int modbus_write_and_read_registers
   --                  (modbus_t *ctx,
   --                   int write_addr, int write_nb, const uint16_t *src,
   --                   int read_addr, int read_nb, uint16_t *dest);
   --  Uses Modbus function code 16#17# / 23

   function Mapping_New
     (Nb_Coil_Status       : in C.int;
      Nb_Input_Status      : in C.int;
      Nb_Holding_Registers : in C.int;
      Nb_Input_Registers   : in C.int)
      return System.Address;
   --  May raise an Error
   --  modbus_mapping_t* modbus_mapping_new
   --                       (int nb_coil_status, int nb_input_status,
   --                        int nb_holding_registers, int nb_input_registers);
   --  Not to be used !
   --  In Ada for Automation, it is done the other way, the data is allocated
   --  from Ada side.

   procedure Mapping_Free (Mapping_Access : in System.Address);
   --  void modbus_mapping_free (modbus_mapping_t *mb_mapping);
   pragma Import (C, Mapping_Free, "modbus_mapping_free");
   --  Not to be used !
   --  In Ada for Automation, it is done the other way, the data is allocated
   --  from Ada side.

   function Receive
     (Context : in Context_Type;
      Request : in Byte_Array) return C.int;
   --  int modbus_receive(modbus_t *ctx, uint8_t *req);
   pragma Import (C, Receive, "modbus_receive");

   function Reply
     (Context        : in Context_Type;
      Request        : in Byte_Array;
      Request_Len    : in C.int;
      Mapping_Access : in Modbus_Mapping_Type) return C.int;
   --  int modbus_reply (modbus_t *ctx, const uint8_t *req,
   --                  int req_length, modbus_mapping_t *mb_mapping);
   pragma Import (C, Reply, "modbus_reply");

   subtype TCP_Port_Type is Integer range 0 .. 65535;

   --------------------------------------------------------------------
   --  from modbus-tcp.h
   --------------------------------------------------------------------

   MODBUS_TCP_MAX_ADU_LENGTH  : constant := 260;
   --  #define MODBUS_TCP_MAX_ADU_LENGTH  260

   function New_TCP
     (IP_Address : in String;
      Port       : in TCP_Port_Type) return Context_Type;
   --  May raise an Error
   --  modbus_t* modbus_new_tcp(const char *ip_address, int port);

   subtype Socket_Type is GNAT.Sockets.Socket_Type;
   --  type Socket_Type_Access is access all Socket_Type;
   --  pragma Convention (C, Socket_Type_Access);

   function TCP_Listen
     (Context       : in Context_Type;
      Nb_Connection : in Integer) return Socket_Type;
   --  May raise an Error
   --  int modbus_tcp_listen(modbus_t *ctx, int nb_connection);

   procedure TCP_Accept
     (Context       : in Context_Type;
      Socket_Access : in System.Address);
   --  May raise an Error
   --  int modbus_tcp_accept(modbus_t *ctx, int *socket);

   procedure Set_Socket
     (Context : in Context_Type;
      Socket  : in Socket_Type);
   --  void modbus_set_socket(modbus_t *ctx, int socket);
   pragma Import (C, Set_Socket, "modbus_set_socket");

   function Get_Socket (Context : in Context_Type) return Socket_Type;
   --  int modbus_get_socket(modbus_t *ctx);
   pragma Import (C, Get_Socket, "modbus_get_socket");

   --------------------------------------------------------------------
   --  from modbus-rtu.h
   --------------------------------------------------------------------

   MODBUS_RTU_MAX_ADU_LENGTH  : constant := 256;
   --  #define MODBUS_RTU_MAX_ADU_LENGTH  256

   type Baud_Rate_Type is
     (BR_1200,
      BR_2400,
      BR_4800,
      BR_9600,
      BR_19200,
      BR_38400,
      BR_57600,
      BR_115200);
   for Baud_Rate_Type use
     (BR_1200     =>    1200,
      BR_2400     =>    2400,
      BR_4800     =>    4800,
      BR_9600     =>    9600,
      BR_19200    =>   19200,
      BR_38400    =>   38400,
      BR_57600    =>   57600,
      BR_115200   =>  115200);

   type Parity_Type is
     (None, Even, Odd);

   subtype Data_Bits_Type is Integer range 5 .. 8;
   subtype Stop_Bits_Type is Integer range 1 .. 2;

   function New_RTU
     (Device    : in String;
      Baud_Rate : in Baud_Rate_Type;
      Parity    : in Parity_Type;
      Data_Bits : in Data_Bits_Type;
      Stop_Bits : in Stop_Bits_Type) return Context_Type;
   --  May raise an Error
   --  modbus_t* modbus_new_rtu(const char *device, int baud, char parity,
   --                          int data_bit, int stop_bit);

   type Serial_Mode_Type is (RS232, RS485);
   for Serial_Mode_Type use (RS232 => 0, RS485 => 1);
   --  #define MODBUS_RTU_RS232 0
   --  #define MODBUS_RTU_RS485 1

   procedure RTU_Set_Serial_Mode
     (Context : in Context_Type;
      Mode    : in Serial_Mode_Type);
   --  May raise an Error
   --  int modbus_rtu_set_serial_mode(modbus_t *ctx, int mode);

   procedure RTU_Get_Serial_Mode
     (Context : in  Context_Type;
      Mode    : out Serial_Mode_Type);
   --  May raise an Error
   --  int modbus_rtu_get_serial_mode(modbus_t *ctx);

private
   type Context_Type is new System.Address;

   function Modbus_Strerror return String;
   --  const char *modbus_strerror(int errnum);

   type Struct_Timeval is record
      tv_sec  : C.long;
      tv_usec : C.long;
   end record;
   pragma Convention (C, Struct_Timeval);
   --  from _timeval.h
   --  struct timeval
   --  {
   --   long tv_sec;
   --   long tv_usec;
   --  };

   Micro   : constant := 1_000_000;
   Micro_F : constant := 1_000_000.0;
   function To_Duration (Timeval : in Struct_Timeval) return Duration;

   function To_Timeval (D : Duration) return Struct_Timeval;

end Rx.Com.Protocols.LibModbus;
