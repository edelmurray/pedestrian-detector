function [bounding_box] = sliding_window_detector(im,model,wSize)

fcount = 1;
col_limit=size(im,2);
row_limit=size(im,1);
% col_limit=size(im,2);
% row_limit=size(im,1);
% sample_window_rate_y=size(im,2)/4;
% sample_window_rate_x=size(im,1)/4;
sample_window_rate_y=wSize(2)*2;
sample_window_rate_x=wSize(1)*2;
l = 480;
w = 640;

% loop over img and extract features for each crop
% experimented with x,y=0 or 1.
for y = 0:96:l
    for x = 0:256:w
        po = [x y wSize(1) wSize(2)];
%         po = [x y x+wSize(1) y+wSize(2)];
        img = reshape(im,480,640);
        img = imcrop(img,po);
        img = imresize(img, [160, 96]);
        featureVector{fcount} = hog_feature_vector(img);
        [prediction,pred]=SVMTesting(featureVector{fcount},model);
        results{fcount}=prediction;
%         check if person detected
        if results{fcount}==1
            bounding_box(fcount,1)=x;
            bounding_box(fcount,2)=y;
            bounding_box(fcount,3)=wSize(2);
            bounding_box(fcount,4)=wSize(1);

%         bounding_box(fcount,3)=x+wSize(2);
%         bounding_box(fcount,4)=y+wSize(1);
%         confidence value
        bounding_box(fcount,5)=pred;
        fcount=fcount+1;
        end
    end
end

% drawing bounding box manually, 
% 
% x=460;
% y=400;
% x2=350;
% y2=100;
% po = [x y x2 y2];
% img = reshape(im,480,640);
% img = imcrop(img,po);
% img = imresize(img, [160, 96]);
% featureVector = hog_feature_vector(img);
% [prediction,pred]=SVMTesting(featureVector,model);
% results=prediction;
% %         check if person detected
% % if results>0
%     bounding_box(fcount,1)=x;
%     bounding_box(fcount,2)=y;
%     bounding_box(fcount,3)=x2;
%     bounding_box(fcount,4)=y2;
%     %         confidence value
%     bounding_box(fcount,5)=pred;
%     fcount=fcount+1;
% %         end
% % end
% 
