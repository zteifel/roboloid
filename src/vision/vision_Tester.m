close all;
clear cam;
clear camobj;

ch = 0.68;
cam = webcam(1);
ballColor = [205, 100, 0];
robotColor = [200,255,50];

figure()
hold on;
handle = imagesc(snapshot(cam));
axis([0,640,0,480]);

dim = [0.2 0.5 0.3 0.3];
dim2 = [0.2 0.4 0.3 0.3];
ann = annotation('textbox',dim,'String','  ','FitBoxToText','on');
ann2 = annotation('textbox',dim2,'String','1','FitBoxToText','on');
robHandle = plot(1,1,'r*');
ballHandle = plot(1,1,'g*');
ballArrow = plot([0 0], [0 0]);
lastPoint = [0,0];
dt = 1;
filterLen = 8;
ballSpeedFilter = zeros(filterLen,2);
filterInd = 1;
while true
    tic
    pic = snapshot(cam);
    [dist, angle, status, ball, robot] = findDistanceAngle(cam, ch, ballColor, robotColor);
    
    goalLine = robot(2);
    ballSpeed = (ball - lastPoint) / dt;
    lastPoint = ball;
    filterInd = filterInd + 1;
    ballSpeedFilter(mod(filterInd, filterLen)+1,:) = ballSpeed;
    avgBallSpeed = mean(ballSpeedFilter,1);
    
    
    set(handle, 'CData', pic);
    set(ann, 'String', dist);
    set(ann2, 'String', status);
    set(robHandle, 'XData', robot(1));
    set(robHandle, 'YData', robot(2));
    set(ballHandle, 'XData', ball(1));
    set(ballHandle, 'YData', ball(2));
    if size(avgBallSpeed,2) ~=0
        set(ballArrow, 'XData', [ball(1), ball(1)+avgBallSpeed(1)]);
        set(ballArrow, 'YData', [ball(2), ball(2)+avgBallSpeed(2)]);
    end
    drawnow();
    
    dt = toc;
    
end
