function region = findFirstRegion(mask)



imageX = size(mask,1);
imageY = size(mask,2);

startPoint = [0 0];

for i = 1:imageX
    for j = 1:imageY
        if mask(i,j) == 1
            startPoint = [i j];
            break
        end
    end
    if startPoint ~= [0 0]
        break
    end
end

if startPoint == [0 0]
    region = -1;
    return
end

if mean(mean(mask)) == 0
    region = -1;
    return
end

region = zeros(imageX,imageY);

nodeList = zeros(10000,2);
nodeList(1,:) = startPoint;

%fh = figure(12);
%im = imagesc(region);

maxBuffer = 0;
regionSize = 1;
while size(find(nodeList,1)) > 0
    
    index = find(nodeList(:,1),1,'last');
    if index > maxBuffer
        maxBuffer = index;
    end
    currNode = nodeList(index,:);
    nodeList(index,:) = [];
    
    x = currNode(1);
    y = currNode(2);
    
    region(x,y) = 1;
    mask(x,y) = 0;
    
    countAdded = 0;
    if x < imageX-1
        if mask(x+1,y) == 1
            nodeList(index + countAdded,:) = [x+1,y];
            countAdded = countAdded + 1;
        end
    end
    if x > 1
        if mask(x-1,y) == 1
            nodeList(index + countAdded,:) = [x-1,y];
            countAdded = countAdded + 1;
        end
    end
    if y < imageY-1
        if mask(x,y+1) == 1
            nodeList(index + countAdded,:) = [x,y+1];
            countAdded = countAdded + 1;
        end
    end
    if y > 1
        if mask(x,y-1) == 1
            nodeList(index + countAdded,:) = [x,y-1];
            countAdded = countAdded + 1;
        end
    end
    regionSize = regionSize + countAdded;
    
    %set(im, 'CData', region);
    %drawnow;
    
end
maxBuffer
if regionSize < 30
    region = findFirstRegion(mask);
end
