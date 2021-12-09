addpath .\SVM-KM\
% Load database
% load in positive images with positive pedestrian detection with label 1
% [positive_images, pos_labels] = loadDatabase('C:\Users\edele\matlab 2\images\images\pos',1);
% 
% %load in negative images with negative pedestrian detection with label -1
% [negative_images, neg_labels] = loadDatabase('C:\Users\edele\matlab 2\images\images\neg',-1);

% Training images
training_images = [];
sampling = 1;
for i=1:sampling:round(size(positive_images,1)*0.6)-1
    training_images = [training_images;positive_images(i,:)];
end
for i=1:sampling:round(size(negative_images,1)*0.6)
    training_images = [training_images;negative_images(i,:)];
end



%Training labels
training_labels = [];
for i=1:sampling:round(size(pos_labels,1)*0.6)-1
    training_labels = [training_labels;pos_labels(i,:)];
end
for i=1:sampling:round(size(neg_labels,1)*0.6)
    training_labels = [training_labels;neg_labels(i,:)];
end



%Testing images
testing_images = [];
for i=round(size(positive_images,1)*0.6):sampling:size(positive_images,1)
    testing_images = [testing_images;positive_images(i,:)];
end
for i=round(size(negative_images,1)*0.6)+1:sampling:size(negative_images,1)
    testing_images = [testing_images;negative_images(i,:)];
end



% Testing labels
testing_labels = [];
for i=round(size(pos_labels,1)*0.6):sampling:size(pos_labels,1)
    testing_labels = [testing_labels;pos_labels(i,:)];
end
for i=round(size(neg_labels,1)*0.6)+1:sampling:size(neg_labels,1)
    testing_labels = [testing_labels;neg_labels(i,:)];
end

% NN Training
 feature_vectors = [];
 for i=1:size(training_images,1)
     training_images(i,:) = enhanceContrastHE(cast(training_images(i,:), 'uint8'));
     sample_image = reshape(training_images(i,:),160,96);
     feature = hog_feature_vector(sample_image);
     feature_vectors = [feature_vectors;feature];
 end

model = SVMtraining(feature_vectors,training_labels);

%model = TreeBagger(100,feature_vectors,training_labels);
 
save detectorModel model
% 
% % NN Testing
% test_feature_vectors = [];
% for i=1:size(testing_images,1)
%     training_images(i,:) = enhanceContrastHE(cast(testing_images(i,:), 'uint8'));
%     test_image = reshape(testing_images(i,:),160,96);%this gave errors with 160,96
%     test_feature = hog_feature_vector(test_image);
%     test_feature_vectors = [test_feature_vectors;test_feature];
% end
% 
% for i=1:size(testing_images,1)
%     
%     testnumber= test_feature_vectors(i,:);
%     
%     classificationResult(i,1) = SVMTesting(testnumber,model);
     %classificationResult(i,1) = str2double(predict(model, testnumber));
% 
% end
% 
% 
% %Evaluation
% 
% comparison = (testing_labels==classificationResult);
% incorrect_comparison = sum(testing_labels~=classificationResult);
% tp=0;fp=0;tn=0;fn=0;
% for i=1:size(classificationResult)
%     if (classificationResult(i)==1 && testing_labels(i)==1)
%         tp = tp+1;
%     elseif (classificationResult(i)==1 && testing_labels(i)==-1)
%         fp=fp+1;
%     elseif (classificationResult(i)==-1 && testing_labels(i)==-1)
%         tn=tn+1;
%     else
%         fn=fn+1;
%     end
% end
% 
% 
% 
% 
% %Accuracy is the most common metric. It is defiend as the numebr of
% %correctly classified samples/ the total number of tested samples
% Accuracy = sum(comparison)/length(comparison);
% error_rate = incorrect_comparison/length(comparison);
% recall = tp / (tp + fn);
% precision = tp / (tp + fp);
% specificity = tn / (tn + fp);
% f1 = 2*(precision*recall)/(precision+recall);
% false_alarm_Rate = 1-specificity;
% roc = tp/fp;
% 
% 
% 
