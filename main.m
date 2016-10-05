% Main script for robot function.
% All positions are relative to a coordinate system with
% its origin at the center of the goal. One can further
% assume that the robot is oriented with its front towards the ball.

addpath('src')
addpath('src/vision')

% Constants (TODO: measure these values)
ROBOT_MOVEMENT_DEFS = ['ROBOT_STRAFE', 'ROBOT_STRAFE2', 'ROBOT_SLIDE',...
  'ROBOT_STRAFE_SLIDE', 'ROBOT_STRAFE2_SLIDE', 'ROBOT_THROW', 'ROBOT_SLIDE_THROW'];
ROBOT_MOVEMENT_DISTANCES = [0.1, 0.2, 0.2, 0.3, 0.4, 0.5, 0.7];
ROBOT_MOVEMENT_TIMES = [1, 2, 0.2, 1.2, 2.2, 0.3, 0.5];

% ROBOT_MOVEMENT_TIMES.('ROBOT_STRAFE')               = 1;
% ROBOT_MOVEMENT_TIMES.('ROBOT_STRAFE2')              = 2;
% ROBOT_MOVEMENT_TIMES.('ROBOT_SLIDE')                = 0.2;
% ROBOT_MOVEMENT_TIMES.('ROBOT_STRAFE_SLIDE')         = 1.2;
% ROBOT_MOVEMENT_TIMES.('ROBOT_STRAFE2_SLIDE')        = 2.2;
% ROBOT_MOVEMENT_TIMES.('ROBOT_THROW')                = 0.3;
% ROBOT_MOVEMENT_TIMES.('ROBOT_SLIDE_THROW')          = 0.5;

ROBOT_FOOT_WIDTH                                    = 0.06;
GOAL_SIZE                                           = 1;

% Visuals
ballInitialPos = [0 1.50];
robotInitialPos = [0 0];
ballVelocity = [0 0];
goalCenterPosition = [1.2 0.1];

ballVeclocityNew = [0.001 -0.1];

% Robot
robot = Robot();
currentState = 0;

% States

running = 1;
while running
  if (currentState == 0)
    % Set robot in default position, get goal center position,
    % wait for user to place in arena
    
    %goalCenterPosition = getGoalCenterPosition()
    robot.defaultPosition(1);
    input('Place robot at starting position, then press enter to continue\n')
    currentState = 1;
    
  elseif (currentState == 1)
    % Initial state; get ball initial position and robot initial position

    %ballInitialPos = changeCoordinates(getBallInitialPos())
    %robotInitialPos = changeCoordinates(getRobotInitialPos())
    currentState = 2;  
    
  elseif (currentState == 2)
    % Determine ball velocity and final ball position
    
    %ballVelocity = getBallVelocity();
    if (abs(ballVelocity(1)) > 0 || abs(ballVelocity(2)) > 0)
      %ballVelocityNew = getBallVelocity();
      if (abs(ballVelocityNew(1)) <= abs(ballVelocity(1)) || ...
          abs(ballVelocityNew(2)) <= abs(ballVelocity(2)))
        [ballFinalPos, ballFinalTime] = getBallFinalPos(ballVelocity, ballInitialPos);
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
      action = '';
      requiredDistance = ballFinalPos(1) - robotInitialPos(1);
      if (abs(requiredDistance) > ROBOT_FOOT_WIDTH)
        inds = find(ROBOT_MOVEMENT_DISTANCES > abs(requiredDistance));
        ind = inds(1);
        for i=2:length(inds)
          if (ROBOT_MOVEMENT_TIMES(inds(i)) < ballFinalTime &&...
              ROBOT_MOVEMENT_TIMES(inds(i)) > ROBOT_MOVEMENT_TIMES(ind))
            ind = inds(i);
          end
        end
        action = ROBOT_MOVEMENT_DEFS(ind);
        currentState = 4;
      else
        print('Ball will hit robot, no action needed')
        currentState = 0;
      end
    end
    
  elseif (currentState == 4)
    % Perform determined action
    

  end
end
