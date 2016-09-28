function mask = maskImage(input, color)

cutoff = 50;

inputX = size(input,1);
inputY = size(input,2);

ycbcrMaskColor = rgb2ycbcr(color);
ycbcrImage = rgb2ycbcr(double(input));

cbcr = ycbcrImage(:,:,2:3);
colorMask = cat(3,ones(inputX, inputY)* ycbcrMaskColor(2), ones(inputX, inputY)* ycbcrMaskColor(3));

dist = sqrt(sum((cbcr - colorMask).^2,3));
mask = dist;

mask(mask<=cutoff) = 1;
mask(mask>cutoff) = 0;


end