function velocity = getVelocityVector(filter, ballVelocity)
%GETVELOCITYVECTOR Summary of this function goes here
%   Detailed explanation goes here

p = polyfit(filter(:,1),filter(:,2),1);

theta = atan(1/p(1));
x = sin(theta) * norm(ballVelocity);
y = cos(theta) * norm(ballVelocity);

velocity = [x y];


end

