classdef Connection < handle
  properties
    lib_name

    BAUDRATE          = 1000000;
    DEVICENAME        = 'COM4';
    PROTOCOL_VERSION  = 1.0;
    COMM_SUCCESS      = 0;

    dev_name
    port_num
  end

  methods
    function obj = Connection()

      addpath('lib/DynamixelSDK/c/include/');
      addpath('lib/DynamixelSDK/c/build/linux64/');
      addpath('lib/DynamixelSDK/c/build/win64/output/');

      obj.loadLib();
      obj.initPort();

    end

    function initPort(obj)
      obj.port_num = calllib(obj.lib_name, 'portHandler', obj.dev_name);
      calllib(obj.lib_name, 'packetHandler')

      % Open port
      if calllib(obj.lib_name, 'openPort', obj.port_num)
          fprintf('Succeeded to open the port!\n');
      else
          unloadlibrary(obj.lib_name);
          fprintf('Failed to open the port!\n');
          input('Press any key to terminate...\n');
          return;
      end

      % Set port baudrate
      if calllib(obj.lib_name, 'setBaudRate', obj.port_num, obj.BAUDRATE)
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
        obj.dev_name = 'COM4';
        obj.lib_name = 'dxl_x86_c';
      elseif strcmp(computer, 'PCWIN64')
        obj.dev_name = 'COM4';
        obj.lib_name = 'dxl_x64_c';
      elseif strcmp(computer, 'GLNX86')
        obj.dev_name = '/dev/ttyUSB0';
        obj.lib_name = 'libdxl_x86_c';
      elseif strcmp(computer, 'GLNXA64')
        obj.dev_name = '/dev/ttyUSB0';
        obj.lib_name = 'libdxl_x64_c';
      end

      % Load Libraries
      if libisloaded(obj.lib_name)
        unloadlibrary(obj.lib_name)
      end
      [notfound, warnings] = loadlibrary(...
          obj.lib_name,'dynamixel_sdk.h','addheader', ...
          'port_handler.h','addheader','packet_handler.h');
    end

    function status = write1Byte(obj,dxl_id,dxl_addr, data)
      calllib(obj.lib_name, 'write1ByteTxRx', obj.port_num, ...
              obj.PROTOCOL_VERSION, dxl_id, dxl_addr, data);
      status = '';
    end

    function status = write2Byte(obj,dxl_id,dxl_addr,data)
      status = '';
      calllib(obj.lib_name, 'write2ByteTxRx', obj.port_num, ...
              obj.PROTOCOL_VERSION, dxl_id, dxl_addr, data);
    end

    function [val,status] = read2Byte(obj,dxl_id, dxl_addr)
      status = ''; 
      val = calllib(obj.lib_name, 'read2ByteTxRx', obj.port_num, ...
                    obj.PROTOCOL_VERSION, dxl_id, dxl_addr );
    end

  end

end
