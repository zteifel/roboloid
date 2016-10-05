function newCoords = changeCoordinates(oldCoords, goalCenterPos)

newCoords(1) = oldCoords(1) - goalCenterPos(1);
newCoords(2) = oldCoords(2) - goalCenterPos(2);

end