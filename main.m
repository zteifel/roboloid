% Main script for robot function.
% All positions are relative to a coordinate system with
% its origin at the center of the goal. One can further
% assume that the robot is oriented with its front towards the ball.

addpath('src')
addpath('src/vision')

close all
clear cam
clear camobj
figure(2)

figure(1);
hand = scatter([0,0,0], [0,0,0]);
axis([-2 2 -4 0.5]);

% Constants
%ROBOT_MOVEMENT_DEFS = ['ROBOT_STRAFE'; 'ROBOT_STRAFE2'; 'ROBOT_SLIDE';...
%  'ROBOT_STRAFE_SLIDE'; 'ROBOT_STRAFE2_SLIDE'; 'ROBOT_THROW'; 'ROBOT_SLIDE_THROW'];
ROBOT_MOVEMENT_DISTANCES = [0.05, 0.11, 0.18, 0.23, 0.31, 0.5, 0.7];
ROBOT_MOVEMENT_TIMES = [2.4, 5.0, 0.8, 3.2, 5.8, 1.2, 2.6];

% ROBOT_MOVEMENT_TIMES.('ROBOT_STRAFE')               = 1;
% ROBOT_MOVEMENT_TIMES.('ROBOT_STRAFE2')              = 2;
% ROBOT_MOVEMENT_TIMES.('ROBOT_SLIDE')                = 0.2;
% ROBOT_MOVEMENT_TIMES.('ROBOT_STRAFE_SLIDE')         = 1.2;
% ROBOT_MOVEMENT_TIMES.('ROBOT_STRAFE2_SLIDE')        = 2.2;
% ROBOT_MOVEMENT_TIMES.('ROBOT_THROW')                = 0.3;
% ROBOT_MOVEMENT_TIMES.('ROBOT_SLIDE_THROW')          = 0.5;

ROBOT_FOOT_WIDTH                                    = 0.04;
GOAL_SIZE                                           = 1.2;
ROBOT_MARKER_HEIGHT                                 = 0.25;

finalTimeOffset = 0.1;
% Visuals
CAM_ANG                                             = 45;
ch = 1.30;
cam = webcam(1);
cam.resolution = '640x480';
%cam.ExposureMode = 'manual';
%cam.Exposure = -3;

dt = inf;
ballVelocity = [0 0];

% Robot
robot = Robot;
currentState = 0;

% Lowpass for ball pos

filterLen = 8;
filterInd = 1;

% States

running = 1;
while running
  if (currentState == 0)
    % Set robot in default position, get goal center position,
    % wait for user to place in arena
    
    robot.defaultPosition2(0.3);
    input('Place robot and ball at starting positions, then press enter to continue\n')
    
    pic = snapshot(cam);
    [ball, robotPos, ballRaw, robotRaw, gamma] = findAtAngle(pic, CAM_ANG, ch);
    robotOffset = tand(CAM_ANG + gamma(2)) * ROBOT_MARKER_HEIGHT;
    robotPos(2) = robotPos(2) - robotOffset;
    goalCenterPosition = robotPos;
    currentState = 1;
    filterInd = 0;
    ballVelocity = [0 0];
    ballPosFilter = zeros(filterLen,2);
    cpu = 0;
    
  elseif (currentState == 1)
    % Initial state; get ball initial position and robot initial position

    ballInitialPos = changeCoordinates(ball, goalCenterPosition);
    robotInitialPos = changeCoordinates(robotPos, goalCenterPosition);
    ballInMotion = false;
    currentState = 2;
  elseif (currentState == 2)
    tic  
    % Determine ball velocity and final ball position
    lastBallVelocity = ballVelocity;
    lastPoint = ball;
    
    
    pic = snapshot(cam);
    [ball, robotPos, ballRaw, robotRaw] = findAtAngle(pic, 45, ch);
    ball = changeCoordinates(ball, goalCenterPosition);
    robotPos = changeCoordinates(robotPos, goalCenterPosition);
    robotPos(2) = robotPos(2) - robotOffset;
    
    ballVelocity = (ball - lastPoint) / dt;
    
    if norm(ballVelocity) > 0.1 %|| ballInMotion
        ballInMotion  = true;
        if cpu == 0
            cpu = cputime;
        end
        ballPosFilter(mod(filterInd, filterLen)+1,:) = ball;
        filterInd = filterInd + 1;
    end
    
    set(hand, 'XData', [ball(1) robotPos(1) ball(1)+ballVelocity(1)]);
    set(hand, 'YData', [ball(2) robotPos(2) ball(2)+ballVelocity(2)]);
    set(hand, 'CData', [[255 0 0]; [0 255 0]; [0 0 255]]);
    
    if nnz(ballPosFilter) == size(ballPosFilter,1)* size(ballPosFilter,2)
        ballVelocity = ballPosFilter(end,:) - ballPosFilter(end/2,:)/(filterLen/2*dt)
        ballVelocity = getVelocityVector(ballPosFilter, ballVelocity);
        test = cputime;
        test - cpu
        [ballFinalPos, ballFinalTime] = getBallFinalPos(ballVelocity, ball)
        ballInMotion = false;
        currentState = 3;
        
    end
    dt = toc;
  elseif (currentState == 3)
    % Determine movement needed
    
    if (abs(ballFinalPos(1)) > GOAL_SIZE/2)
      disp('Ball will miss, no action needed')
      currentState = 0;
    else
      action = '';
      requiredDistance = ballFinalPos(1) - robotInitialPos(1);
      if requiredDistance < 0
        direction = 'right';
      else
        direction = 'left';
      end
      if (abs(requiredDistance) > ROBOT_FOOT_WIDTH)
        inds = find(ROBOT_MOVEMENT_DISTANCES > abs(requiredDistance));
        ind = inds(1);
        for i=1:length(inds)
          if (ROBOT_MOVEMENT_TIMES(inds(i)) < (ballFinalTime-finalTimeOffset) &&...
              ROBOT_MOVEMENT_TIMES(inds(i)) >= ROBOT_MOVEMENT_TIMES(ind))
            ind = inds(i);
            break
          end
          action = ind;
          currentState = 4;
        end
      else
        disp('Ball will hit robot, no action needed')
        currentState = 0;
      end
      disp('DECISION MADE!!!')
    end
    
  elseif (currentState == 4)
    % Perform determined action
    disp(action)

    if strcmp(direction, 'left')
      switch ind
        case 1
          robot.strafeLeft(1);
        case 2
          robot.strafeLeft(2);
        case 3
          robot.slideLeft();
        case 4
          robot.strafeLeft(1);
          robot.slideLeft();
        case 5
          robot.strafeLeft(2);
          robot.slideLeft();
        case 6
          robot.throwLeft();
        case 7
          robot.slideLeft();
          robot.throwLeft();
        otherwise
          robot.defaultPosition(0.5);
      end
    elseif strcmp(direction, 'right')
      switch ind
        case 1
          robot.strafeRight(1);
        case 2
          robot.strafeRight(2);
        case 3
          robot.slideRight();
        case 4
          robot.strafeRight(1);
          robot.slideRight();
        case 5
          robot.strafeRight(2);
          robot.slideRight();
        case 6
          robot.throwRight();
        case 7
          robot.slideRight();
          robot.throwRight();
        otherwise
          robot.defaultPosition(0.5);
      end
    end
    close(2)
    figure(2)
    scatter(ballPosFilter(:,1),ballPosFilter(:,2))
    currentState = 0;
    pause(3)
    robot.defaultPosition2(0.3);
  end
end
