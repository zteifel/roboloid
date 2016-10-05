function mask = maskImage(input, color)

cutoff = 20;

inputX = size(input,1);
inputY = size(input,2);

ycbcrMaskColor = rgb2ycbcr(color);
ycbcrImage = rgb2ycbcr(double(input));

cbcr = ycbcrImage(:,:,2:3);
oneM = ones(inputX, inputY);
colorMask = cat(3, oneM* ycbcrMaskColor(2), oneM* ycbcrMaskColor(3));

%HSV_MaskColor = rgb2hsv(color/255);
%HSVImage = rgb2hsv(double(input));  
%colorMask = oneM * HSV_MaskColor(1);
%H_Image = HSVImage(:,:,1);


dist = sqrt(sum((cbcr - colorMask).^2,3));

%dist = abs(H_Image - HSV_MaskColor(1));
%dist = HSVImage-cat(3, oneM * HSV_MaskColor(1),oneM * HSV_MaskColor(2), oneM * HSV_MaskColor(3));
%dist = sqrt(dist(:,:,1).^2 + dist(:,:,2).^2 + dist(:,:,3).^2);
mask = dist .* ycbcrImage(:,:,3);

imMax = max(max(max(ycbcrImage(:,:,1))));
filter = 0.5-abs((ycbcrImage(:,:,1)/imMax)-0.5);

%dist = dist.*filter > 0.25;

mask(dist<=cutoff) = 1;
mask(dist>cutoff) = 0;

%SE = strel('disk', 2);
%mask = imopen(mask,SE);


end