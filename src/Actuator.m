classdef Actuator < handle
  properties

    DXL_MOVING_STATUS_THRESHOLD = 10;           % Dynamixel moving status threshold 

    ADDR_MX_TORQUE_ENABLE       = 24;
    ADDR_MX_GOAL_POSITION       = 30;
    ADDR_MX_MOVING_SPEED        = 32;
    ADDR_MX_TORQUE_LIMIT        = 34;
    ADDR_MX_PRESENT_POSITION    = 36;
    ADDR_MX_IS_MOVING           = 46;

    TORQUE_ENABLE               = 1;            % Value for enabling the torque
    TORQUE_DISABLE              = 0;            % Value for disabling the torque

    dxl_id;
    dxl_min_pos_val;
    dxl_max_pos_val;

    con;

  end

  methods

    function obj = Actuator(con,dxl_id, min_pos_val, max_pos_val);
      obj.con = con;
      obj.dxl_id = dxl_id;
      obj.dxl_min_pos_val = min_pos_val;
      obj.dxl_max_pos_val = max_pos_val;
    end

    function status = enableTorque(obj)
      status = obj.con.write1Byte( ...
        obj.dxl_id, obj.ADDR_MX_TORQUE_ENABLE, obj.TORQUE_ENABLE);
    end

    function status = disableTorque(obj)
      status = obj.con.write1Byte( ...
        obj.dxl_id, obj.ADDR_MX_TORQUE_ENABLE, obj.TORQUE_DISABLE);
    end

    function status = setGoalPosition(obj,relPos)
      pos = obj.dxl_min_pos_val + (obj.dxl_max_pos_val-obj.dxl_min_pos_val)*relPos;
      status = obj.con.write2Byte(obj.dxl_id, obj.ADDR_MX_GOAL_POSITION,pos);
    end

    function status = setMovingSpeed(obj,speed)
      val = speed*1022+1;
      status = obj.con.write2Byte(obj.dxl_id, obj.ADDR_MX_MOVING_SPEED,val);
    end

    function status = setTorque(obj,tq)
      val = tq*1022+1;
      status = obj.con.write2Byte(obj.dxl_id, obj.ADDR_MX_TORQUE_LIMIT,val);
    end

    function [val,status] = isMoving(obj)
      val = obj.con.read2Byte(obj.dxl_id, obj.ADDR_MX_IS_MOVING);
    end

    function [reVal,status] = getPosValue(obj)
      val = obj.con.read2Byte(obj.dxl_id, obj.ADDR_MX_PRESENT_POSITION);
      reVal = (val-obj.dxl_min_pos_val)/(obj.dxl_max_pos_val-obj.dxl_min_pos_val);
    end

  end

end
