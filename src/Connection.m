classdef Connection
  properties
    lib_name = '';

    BAUDRATE                    = 1000000;
    DEVICENAME                  = '/dev/ttyUSB0';
    PROTOCOL_VERSION            = 1.0;
    COMM_SUCCESS = 0;

    dev_name;
    port_num;
  end

  methods
    function obj = Connection()

      addpath(genpath('lib/DynamixelSDK/matlab/m_basic_function/'));
      addpath('lib/DynamixelSDK/c/include/');
      addpath('lib/DynamixelSDK/c/build/linux64/');

      obj.dev_name = obj.DEVICENAME;
      obj.loadLib();
      obj.port_num = portHandler(obj.dev_name);
      packetHandler();
      obj.initPort();

    end

    function initPort(obj)

      % Open port
      if (openPort(obj.port_num))
          fprintf('Succeeded to open the port!\n');
      else
          unloadlibrary(obj.lib_name);
          fprintf('Failed to open the port!\n');
          input('Press any key to terminate...\n');
          return;
      end

      % Set port baudrate
      if (setBaudRate(obj.port_num, obj.BAUDRATE))
          fprintf('Succeeded to change the baudrate!\n');
      else
          unloadlibrary(obj.lib_name);
          fprintf('Failed to change the baudrate!\n');
          input('Press any key to terminate...\n');
          return;
      end

    end

    function  loadLib(obj)

      if strcmp(computer, 'PCWIN')
        obj.dev_name = 'COM1';
        obj.lib_name = 'dxl_x86_c';
      elseif strcmp(computer, 'PCWIN64')
        obj.dev_name = 'COM1';
        obj.lib_name = 'dxl_x64_c';
      elseif strcmp(computer, 'GLNX86')
        obj.dev_name = '/dev/ttyUSB0'
        obj.lib_name = 'libdxl_x86_c';
      elseif strcmp(computer, 'GLNXA64')
        obj.dev_name = '/dev/ttyUSB0';
        obj.lib_name = 'libdxl_x64_c';
      end

      % Load Libraries
      if ~libisloaded(obj.lib_name)
        obj.lib_name
        [notfound, warnings] = loadlibrary( ...
          obj.lib_name, 'dynamixel_sdk.h', 'addheader', ...
          'port_handler.h', 'addheader', 'packet_handler.h')
      end

    end

    function status = lastResponse(obj);
      status = '';
      return
      if getLastTxRxResult(obj.port_num, obj.PROTOCOL_VERSION) ~= obj.COMM_SUCCESS
        printTxRxResult(...
          obj.PROTOCOL_VERSION, ...
          getLastTxRxResult(obj.port_num, obj.PROTOCOL_VERSION) ...
        );
      elseif getLastRxPacketError(obj.port_num, obj.PROTOCOL_VERSION) == 0
        printRxPacketError( ...
          obj.PROTOCOL_VERSION, ...
          getLastRxPacketError(obj.port_num, obj.PROTOCOL_VERSION) ...
        );
        status = 0;
        return
      else
        %
      end
      status = 1;
    end

    function status = write1Byte(obj,dxl_id,dxl_addr, byte)
      write1ByteTxRx( ...
        obj.port_num, ...
        obj.PROTOCOL_VERSION, ...
        dxl_id, ...
        dxl_addr, ...
        byte ...
      );
      status = obj.lastResponse();
    end

    function status = write2Byte(obj,dxl_id,dxl_addr,byte)
      write2ByteTxRx( ...
        obj.port_num, ...
        obj.PROTOCOL_VERSION, ...
        dxl_id, ...
        dxl_addr, ...
        byte ...
      );
      status = obj.lastResponse();
    end

    function [val,status] = read2Byte(obj,dxl_id, dxl_addr)
      val = read2ByteTxRx(obj.port_num, obj.PROTOCOL_VERSION, dxl_id, dxl_addr);
      status = obj.lastResponse();
    end

  end

end
