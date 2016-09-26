classdef MockActuator < handle
  properties

    DXL_MOVING_STATUS_THRESHOLD = 10;           % Dynamixel moving status threshold 

    ADDR_MX_TORQUE_ENABLE       = 24;
    ADDR_MX_GOAL_POSITION       = 30;
    ADDR_MX_PRESENT_POSITION    = 36;

    TORQUE_ENABLE               = 1;            % Value for enabling the torque
    TORQUE_DISABLE              = 0;            % Value for disabling the torque

    dxl_id;
    dxl_min_pos_val;
    dxl_max_pos_val;

    con;

  end

  methods

    function obj = MockActuator(con,dxl_id, min_pos_val, max_pos_val);
      obj.con = con;
      obj.dxl_id = dxl_id;
      obj.dxl_min_pos_val = min_pos_val;
      obj.dxl_max_pos_val = max_pos_val;
    end

    function status = enableTorgue(obj)
      return
    end

    function status = disableTorgue(obj)
      return
    end

    function status = setGoalPosition(obj,relPos)
      return
    end

    function val = getPosValue(obj)
      val = rand;
    end

  end

end
