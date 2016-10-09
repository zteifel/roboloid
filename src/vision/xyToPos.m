function pos = xyToPos(inCoord, camAng, camH, camRes)
FOVx = 70.58;
FOVy = 55.92;

%gammaX = pixelToAngle(inCoord(1));
%gammaY = pixelToAngle(inCoord(2));

gammaX = (inCoord(1)-camRes(1)/2) * FOVx / camRes(1);
gammaY = (inCoord(2)-camRes(2)/2) * FOVy / camRes(2);

yPos = camH*(tand(camAng+gammaY));

r = sqrt(camH^2 + yPos^2);
xPos = r * tand(gammaX);

[gammaX, gammaY, xPos, yPos, inCoord];

pos = [xPos yPos];

