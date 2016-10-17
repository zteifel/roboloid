clear camobj
clear cam
close all
camobj = webcam(1);
%camobj.ExposureMode = 'manual';
%camobj.Exposure = -4;

figure()
hold on;
handle = imagesc(snapshot(camobj));
handle4 = plot(1,1,'*r');

figure()
hold on;
handle2 = imagesc(snapshot(camobj));
dim = [0.2 0.5 0.3 0.3];
ann = annotation('textbox',dim,'String','  ','FitBoxToText','on');

figure()
handle3 = imagesc(snapshot(camobj));




i = 0;
while(i < 10000)
    i = i+1;
    pic = snapshot(camobj);
    
    %mask = maskImage(pic, [200, 100, 20]);
    mask = maskImage(pic, [50, 80, 100]);
    robotMask = maskImage(pic, [200,255,100]);
    
    CC_ball = bwconncomp(mask);
    CC_robot = bwconncomp(robotMask);
    
    region = zeros(size(pic,1),size(pic,2));
    
    if(CC_ball.NumObjects ~= 0 && CC_robot.NumObjects ~= 0)
        
        pixels = CC_ball.PixelIdxList{1};
        region(pixels) = 1;
        pixels = CC_robot.PixelIdxList{1};
        region(pixels) = 1;       
    end
    set(handle, 'CData', pic);
    set(handle2, 'CData', mask);
    set(handle3, 'CData', robotMask);
    
    s = regionprops(CC_ball, 'centroid');
    a = regionprops(CC_ball, 'area');
    
    centroids = cat(1, s.Centroid);
    areas = cat(1, a.Area);
    
    centroids_chosen = centroids(areas > 50, :);
    xBall = 0;
    yBall = 0;
    if size(centroids_chosen, 1)~=0
        xBall = centroids_chosen(1,1);
        yBall = centroids_chosen(1,2);
    end
    
    xBall2 = 0;
    yBall2 = 0;
    if size(centroids_chosen, 1)== 2
        xBall2 = centroids_chosen(2,1);
        yBall2 = centroids_chosen(2,2);
    end
    
    dist = ((xBall - xBall2)^2 + (yBall -yBall2)^2)^0.5;
    dim = [0.2 0.5 0.3 0.3];
    str = dist;
    set(ann, 'String', str);
    
    
    
    s = regionprops(CC_robot, 'centroid');
    a = regionprops(CC_robot, 'area');
    
    centroids = cat(1, s.Centroid);
    areas = cat(1, a.Area);
    
    centroids_chosen = cat(1,centroids_chosen, centroids(areas > 300, :));
    
    hold on
    xBall = 0;
    yBall = 0;
    if size(centroids_chosen, 1)~=0
        
        set(handle4, 'XData', centroids_chosen(:,1));
        set(handle4, 'YData', centroids_chosen(:,2));
    end
    hold off
    
end
clear camobj