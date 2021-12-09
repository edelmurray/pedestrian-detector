function non_overlapping_boxes = simpleNMS(bounding_box,threshold)
non_overlapping_boxes=[];
fcount=1;
flag=true;
count=0;
for i=1:size(bounding_box,1)
% calculate the intersection_area with any other detected_bounding_box
    for j=1:size(bounding_box,1)
        % compare every bounding box, not including itself
        if ~isequal(bounding_box(i,:),bounding_box(j,:))
            area = rectint(bounding_box(i,:),bounding_box(j,:));
%             if (intersection_area / bounding_box_area ) is > threshold
            if area/(bounding_box(i,3)*bounding_box(i,4))>threshold
                for z=1:size(non_overlapping_boxes,1)
                    if ~isequal(bounding_box(i,:),non_overlapping_boxes(z,:))
                        count=count+1;
                    end
                end
                if count==size(non_overlapping_boxes,1)|| size(non_overlapping_boxes,1)==0
%                     confidence = non_overlapping_boxes(n,5)/ max(non_overlapping_boxes(:,5));
                    confidence_i = bounding_box(i,5)/ max(bounding_box(:,5));
                    confidence_j = bounding_box(j,5)/ max(bounding_box(:,5));
                    if confidence_i >confidence_j
                        non_overlapping_boxes(fcount,:)=bounding_box(i,:);
                    else 
                        non_overlapping_boxes(fcount,:)=bounding_box(j,:);
                    end
                    fcount=fcount+1;
                end
                count=0;
% remove one of the intersecting bounding box (the one with smaller confidence)
            end
        end    
    end
end
non_overlapping_boxes=non_overlapping_boxes;
