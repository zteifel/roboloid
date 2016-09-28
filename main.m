% Main script for robot function.
% All positions are relative to a coordinate system with
% its origin at the center of the goal. One can further
% assume that the robot is oriented with its front towards the ball.

addpath('src')
addpath('src/vision')

% Constants (TODO: measure these values)
ROBOT_STRAFE_DISTANCE       = 0.1;
ROBOT_THROW_DISTANCE        = 0.2;
ROBOT_STRAFE_TIME           = 1;
ROBOT_THROW_TIME            = 1;
ROBOT_FOOT_WIDTH            = 0.06;
GOAL_SIZE                   = 1;

% Visuals
ballInitialPos = [0 1.50];
robotInitialPos = [0 0];
ballVelocity = [0 0];

ballVeclocityNew = [0.001 -0.1];

% Robot
robot = Robot();
currentState = 0;

% States

running = 1;
while running
  if (currentState == 0)
    % Set robot in default position, wait for user to place in arena
    
    robot.defaultPosition(1);
    input('Place robot at starting position, then press enter to continue\n')
    currentState = 1;
    
  elseif (currentState == 1)
    % Initial state; get ball initial position and robot initial position

    %ballInitialPos = getBallInitialPos()
    %robotInitialPos = getRobotInitialPos()
    currentState = 2;  
    
  elseif (currentState == 2)
    % Determine ball velocity and final ball position
    
    %ballVelocity = getBallVelocity();
    if (abs(ballVelocity(1)) > 0 || abs(ballVelocity(2)) > 0)
      %ballVelocityNew = getBallVelocity();
      if (abs(ballVelocityNew(1)) <= abs(ballVelocity(1)) || ...
          abs(ballVelocityNew(2)) <= abs(ballVelocity(2)))
        [ballFinalPos, t] = getBallFinalPos(ballVelocity, ballInitialPos);
        currentState = 3;
      end
    end
    %ballVelocity = getBallVelocity();
    
  elseif (currentState == 3)
    % Determine movement needed
    
    if (abs(ballFinalPos(1)) > GOAL_SIZE/2)
      print('Ball will miss, no action needed')
      currentState = 0;
    else
      requiredDistance = ballFinalPos(1) - robotInitialPos(1);
      if (requiredDistance > robotInitialPos(1)+ROBOT_FOOT_WIDTH)
        %if (abs(requiredDistance) > someThresHoldValue)
        %  
        %
        %
        %
        robot.throwRight()
      elseif (requiredDistance < robotInitialPos(1)-ROBOT_FOOT_WIDTH)
        robot.throwLeft()
      else
      end
    
    
    end
    

  end
end
