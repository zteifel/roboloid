function pos = findColorMarker(im, color, Msize)
mask = maskImage(im, color);

CC = bwconncomp(mask);

Centr = regionprops(CC, 'centroid');
AreaProps = regionprops(CC, 'area');
Coords = cat(1, Centr.Centroid);
Area = cat(1, AreaProps.Area);

[~, I] = sort(abs(Area-Msize));
if size(I,1) > 0
    X = Coords(I(1),1);
    Y = Coords(I(1),2);
    pos = [X, Y];
else
    pos = [-1 -1];
end