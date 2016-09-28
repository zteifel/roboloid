function [ballFinalPos,t] = getBallFinalPos(v, initialPos)

ballFinalPos = [initialPos(1) + initialPos(2)*v(1)/v(2) 0];
t = initialPos(2)/v(2);

end