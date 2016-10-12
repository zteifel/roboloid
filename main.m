% Main script for robot function.
% All positions are relative to a coordinate system with
% its origin at the center of the goal. One can further
% assume that the robot is oriented with its front towards the ball.

addpath('src')
addpath('src/vision')

close all
clear cam
clear camobj

% Constants
ROBOT_MOVEMENT_DEFS = ['ROBOT_STRAFE', 'ROBOT_STRAFE2', 'ROBOT_SLIDE',...
  'ROBOT_STRAFE_SLIDE', 'ROBOT_STRAFE2_SLIDE', 'ROBOT_THROW', 'ROBOT_SLIDE_THROW'];
ROBOT_MOVEMENT_DISTANCES = [0.05, 0.11, 0.18, 0.23, 0.31, 0.5, 0.7];
ROBOT_MOVEMENT_TIMES = [2.4, 5.0, 0.8, 3.2, 5.8, 1.2, 2.6];

% ROBOT_MOVEMENT_TIMES.('ROBOT_STRAFE')               = 1;
% ROBOT_MOVEMENT_TIMES.('ROBOT_STRAFE2')              = 2;
% ROBOT_MOVEMENT_TIMES.('ROBOT_SLIDE')                = 0.2;
% ROBOT_MOVEMENT_TIMES.('ROBOT_STRAFE_SLIDE')         = 1.2;
% ROBOT_MOVEMENT_TIMES.('ROBOT_STRAFE2_SLIDE')        = 2.2;
% ROBOT_MOVEMENT_TIMES.('ROBOT_THROW')                = 0.3;
% ROBOT_MOVEMENT_TIMES.('ROBOT_SLIDE_THROW')          = 0.5;

ROBOT_FOOT_WIDTH                                    = 0.08;
GOAL_SIZE                                           = 1;

% Visuals
ch = 1.30;
cam = webcam(1);
cam.resolution = '640x480';
cam.ExposureMode = 'manual';
cam.Exposure = -3;

dt = inf;
ballVelocity = [0 0];

% Robot
robot = Robot;
currentState = 0;

% States

running = 1;
while running
  if (currentState == 0)
    % Set robot in default position, get goal center position,
    % wait for user to place in arena
    
    input('Place robot and ball at starting positions, then press enter to continue\n')
    pic = snapshot(cam);
    [ball, robotPos, ballRaw, robotRaw] = findAtAngle(pic, 45, ch);
    goalCenterPosition = robotPos;
    currentState = 1;
    
  elseif (currentState == 1)
    % Initial state; get ball initial position and robot initial position

    ballInitialPos = changeCoordinates(ball, goalCenterPosition);
    robotInitialPos = changeCoordinates(robotPos, goalCenterPosition);
    currentState = 2;
    
  elseif (currentState == 2)
    tic  
    % Determine ball velocity and final ball position
    lastPoint = ball;
    lastBallVelocity = ballVelocity;
    
    pic = snapshot(cam);
    [ball, robot, ballRaw, robotRaw] = findAtAngle(pic, 45, ch);
    
    ballVelocity = (ball - lastPoint) / dt;
    if (abs(ballVelocity(1)) > 0 || abs(ballVelocity(2)) > 0)
      if (abs(ballVelocity(1)) <= abs(lastBallVelocity(1)) || ...
          abs(ballVelocity(2)) <= abs(lastBallVelocity(2)))
        [ballFinalPos, ballFinalTime] = getBallFinalPos(ballVelocity, ball);
        currentState = 3;
      end
    end
    %ballVelocity = getBallVelocity();
    dt = toc;
  elseif (currentState == 3)
    % Determine movement needed
    
    if (abs(ballFinalPos(1)) > GOAL_SIZE/2)
      disp('Ball will miss, no action needed')
      currentState = 0;
    else
      action = '';
      % QUESTION: WHICH ORIENTATION IS THE COORDINATE SYSTEM?
      requiredDistance = ballFinalPos(1) - robotInitialPos(1);
      if requiredDistance < 0
        direction = 'right';
      else
        direction = 'left';
      end
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
        disp(action)
        currentState = 4;
      else
        disp('Ball will hit robot, no action needed')
        currentState = 0;
      end
    end
    
  elseif (currentState == 4)
    % Perform determined action
    
    if strcmp(direction, 'left')
      switch action
        case 'ROBOT_STRAFE'
          robot.strafeLeft(1);
        case 'ROBOT_STRAFE2'
          robot.strafeLeft(2);
        case 'ROBOT_SLIDE'
          robot.slideLeft();
        case 'ROBOT_STRAFE_SLIDE'
          robot.strafeLeft(1);
          robot.slideLeft();
        case 'ROBOT_STRAFE2_SLIDE'
          robot.strafeLeft(2);
          robot.slideLeft();
        case 'ROBOT_THROW'
          robot.throwLeft();
        case 'ROBOT_SLIDE_THROW'
          robot.slideLeft();
          robot.throwLeft();
        otherwise
          robot.defaultPostion(0.5);
      end
    elseif strcmp(direction, 'right')
      switch action
        case 'ROBOT_STRAFE'
          robot.strafeRight(1);
        case 'ROBOT_STRAFE2'
          robot.strafeRight(2);
        case 'ROBOT_SLIDE'
          robot.slideRight();
        case 'ROBOT_STRAFE_SLIDE'
          robot.strafeRight(1);
          robot.slideRight();
        case 'ROBOT_STRAFE2_SLIDE'
          robot.strafeRight(2);
          robot.slideRight();
        case 'ROBOT_THROW'
          robot.throwRight();
        case 'ROBOT_SLIDE_THROW'
          robot.slideRight();
          robot.throwRight();
        otherwise
          robot.defaultPostion(0.5);
      end
    end
    running = 0;
  end
end
