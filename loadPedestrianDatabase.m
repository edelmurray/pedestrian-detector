function boundingboxes = loadPedestrianDatabase(filename, sampling)

if nargin<2
    sampling =1;
end


fp = fopen(filename, 'rb');
assert(fp ~= -1, ['Could not open ', filename, '']);


line1=fgetl(fp);
numberOfImages = fscanf(fp,'%d',1);

bboxes = [];
for im=1:sampling:numberOfImages
    
    image = fscanf(fp, '%s',1);
    numberOfBoundingBoxes = fscanf(fp,'%s',1);
    numberOfBoundingBoxes = str2double(numberOfBoundingBoxes);
    
    all_boxes = fgetl(fp);
    string_split = " "| lettersPattern;
    N = split(all_boxes, string_split);
    N = N(strlength(N) > 0);
    N = str2double(N);
    
    %remove 0's
    bboxes_not_split = N(N~=0);

    %split into individual bounding boxes
    j=1;
    for i =1:numberOfBoundingBoxes
        bboxes(i,:) = [bboxes_not_split(j), bboxes_not_split(j+1), bboxes_not_split(j+2), bboxes_not_split(j+3)];
        j=j+4;
        
    end

    
end

fclose(fp);

end