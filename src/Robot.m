classdef Robot < handle

  properties
    actuators;
    nActuators = 18;
    baseSpeed = 0.7;

    workPool;
    con;
  end

  methods

    function obj = Robot()
      [~,currFolder,~] = fileparts(pwd);
      if currFolder ~= 'roboloid'
        disp('run Robot.m from project root directory, exiting.');
        return
      end
      %obj.workPool = WorkPool();
      obj.con = Connection();
      obj.actuators = obj.initActuator();
      obj.defaultPosition(0.2);
    end

    function playTest(obj)
      obj.playSequence('test.mat',0.8,1);
    end

    function defaultPosition(obj, speed)
      obj.playSequence('default.mat',speed,1);
    end

    function defaultPosition2(obj, speed)
      obj.playSequence('defaultPosition2.mat',speed,1);
    end

    function slideLeft(obj)
      obj.playSequence('slideLeft.mat',0.3,1);
    end

    function slideRight(obj)
      obj.playSequence('slideRight.mat',0.3,1);
    end

    function throwLeft(obj)
      obj.playSequence('throwLeft.mat',1,1);
    end

    function throwRight(obj)
      obj.playSequence('throwRight.mat',1,1);
    end

    function strafeLeft(obj,steps)
      obj.playSequence('strafeLeft.mat',0.22,steps);
    end

    function strafeRight(obj,steps)
      obj.playSequence('strafeRight.mat',0.22,steps);
    end


    function playSequence(obj,filename,speed,nRepeats)
      tmp = load(['data/' filename],'seq');
      seq = tmp.seq;
      nRepeats = (nRepeats < 1)*1E5 + (nRepeats > 0)*nRepeats;

      for rep=1:nRepeats
        for i=1:size(seq,1)

          startPositions = obj.getJointsPositions();
          movementLengths = abs(seq(i,:) - startPositions);
          [maxMove,iMaxMove] = max(movementLengths);
          maxVelocities = speed.*(movementLengths./maxMove);

          first = true;
          j = 1;
          while first || obj.actuators(iMaxMove).isMoving()
            currPos = obj.actuators(j).getPosValue();
            relPos = abs(currPos-startPositions(j))/movementLengths(j);

            if not(isnan(relPos)) && not(relPos == Inf)
              velocity = obj.relSpeed(relPos)*maxVelocities(j);
              velocity = not(velocity > 1)*(velocity-1)+1;
              velocity = not(velocity < 0)*velocity;

              obj.actuators(j).setMovingSpeed(velocity);
              if first
                obj.actuators(j).setGoalPosition(seq(i,j));
              end

            end
            if j == obj.nActuators
              j = 1;
              first = false;
            else
             j = j + 1;
            end
          end
        end
      end

    end

    function recordSequence(obj)
      obj.disableTorque();
      i = 0;
      while true
        in = input('[r]ecord pose, [s]ave sequence or [q]uit ','s');
        if in == 'r'
          i = i + 1;
          for j = 1: obj.nActuators
            pose(1,j) = obj.actuators(j).getPosValue();
          end
          seq(i,:) = pose;
        elseif in == 's'
          filename = input('save as: ','s');
          save(['data/',filename],'seq');
          break
        elseif in == 'q'
          disp('No sequenced saved');
          break
        else
          disp('input not recognized...');
        end
      end
      obj.enableTorque();
    end

    function speed = relSpeed(obj,x)
      speed = -4*(1-obj.baseSpeed)*x^2+4*(1-obj.baseSpeed)*x+obj.baseSpeed;
    end

    function enableTorque(obj)
      for i=1: obj.nActuators
        obj.actuators(i).enableTorque();
      end
    end

    function disableTorque(obj)
      for i=1: obj.nActuators
        obj.actuators(i).disableTorque();
      end
    end

    function setSpeedAll(obj,speed)
      for i=1: obj.nActuators
        obj.actuators(i).setMovingSpeed(speed);
      end
    end

    function positions = getJointsPositions(obj)
      positions = zeros(1,obj.nActuators);
      for i=1:obj.nActuators
        positions(i) = obj.actuators(i).getPosValue();
      end
    end

    function movement = isMoving(obj)
      movement = false;
      for i=1: obj.nActuators
        if obj.actuators(i).isMoving();
          movement = true;
          return
        end
      end
    end

    function queMovement(obj,func)
      obj.workPool.scheduleJob(func,true);
    end

    function interuptMovement(obj,func)
      obj.workPool.scheduleJob(func,false);
    end

    function actuators = initActuator(obj)
      tmp = load('data/actuatorData.mat');
      actData = tmp.actData;
      for i=1:size(actData,1)
        actuators(i) = Actuator(obj.con,i,actData(i,1),actData(i,2));
        %actuators(i).enableTorque();
      end
    end

  end

end
