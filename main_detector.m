addpath .\SVM-KM\
% addpath .\pedestrian\
% load detectorModel
% 
% [images, labels] = loadDatabase('C:\Users\edele\matlab 2\pedestrian\pedestrian',1);

I=images(94,:);
label = 1;
% 
bounding_box = sliding_window_detector(I,model,[48, 64]);
I=imread('C:\Users\edele\matlab 2\pedestrian\pedestrian\image_00000943.jpg');
imshow(I)
hold on

% if size(bounding_box,1)>1
%     non_overlapping_boxes = simpleNMS(bounding_box,0.1);
% else
non_overlapping_boxes=bounding_box;
% end
% for i=1:size(non_overlapping_boxes,1)
%     rectangle('Position', non_overlapping_boxes(i,:),...
%       'EdgeColor','r', 'LineWidth', 3)
% end
% Show the picture
colours =['b';'c';'m';'y'];
% Show the detected objects
% for i=1:size(non_overlapping_boxes,1)
%     rectangle('Position',[non_overlapping_boxes(i,1),non_overlapping_boxes(i,2),96,256],'LineWidth',1, 'EdgeColor','r');
% end
if(~isempty(non_overlapping_boxes))
    for n=1:size(non_overlapping_boxes,1)
        x1=non_overlapping_boxes(n,1); y1=non_overlapping_boxes(n,2);
        x2=non_overlapping_boxes(n,3); y2=non_overlapping_boxes(n,4);
        
        confidence = non_overlapping_boxes(n,5)/ max(non_overlapping_boxes(:,5));
        if confidence > 0.8
            c=1;
        elseif confidence> 0.5
            c=2;
        elseif confidence > 0.1
            c=3;
        else
            c=4;
        end
        
        plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1],colours(c));
    end
end
