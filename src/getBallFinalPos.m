function [ballFinalPos,t] = getBallFinalPos(v, initialPos)

if v(1) > 0
    ballFinalPos = [abs(initialPos(1)) + abs(initialPos(2)*v(1)/v(2)) 0];
else
    ballFinalPos = [abs(initialPos(1)) - abs(initialPos(2)*v(1)/v(2)) 0];
end

t = abs(initialPos(2)/v(2));

end