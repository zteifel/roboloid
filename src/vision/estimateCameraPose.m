function bestGuess = estimateCameraPose(im)

markerSize = 300;

initGuess = [1, 45];

colorRed = [200, 0, 0];
colorGreen = [0, 200, 0];
colorBlue = [0, 0, 200];

distGR = 0.16;
distRB = 0.25;
distGB = sqrt(distGR^2 + distRB^2);
bestError = 9999;
bestGuess = initGuess;
guess = initGuess;
for iIter = 1:100
    posR = xyToPos(findColorMarker(im, colorRed, markerSize), guess(2), guess(1), size(im));
    posG = xyToPos(findColorMarker(im, colorGreen, markerSize), guess(2), guess(1), size(im));
    posB = xyToPos(findColorMarker(im, colorBlue, markerSize), guess(2), guess(1), size(im));
    
    estGR = norm(posG - posR);
    estRB = norm(posR - posB);
    estGB = norm(posG - posB);
    
    error = sqrt((distGR - estGR)^2 + (distRB - estRB)^2 + (distGB - estGB)^2)
    if error < bestError
        bestError = error;
        bestGuess = guess;
    end
    guess = bestGuess + 0.1*[rand, rand];
    
end




