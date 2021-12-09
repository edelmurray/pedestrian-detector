% addpath .\SVM-KM\
% Load database
% load in positive images with positive pedestrian detection with label 1
% [positive_images, pos_labels] = loadDatabase('C:\Users\edele\matlab 2\images\images\pos',1);
% 
% %load in negative images with negative pedestrian detection with label -1
% [negative_images, neg_labels] = loadDatabase('C:\Users\edele\matlab 2\images\images\neg',-1);
% 
% %Training images
training_images = [];
sampling = 1;
for i=1:sampling:round(size(positive_images,1)*.8)-1
    training_images = [training_images;positive_images(i,:)];
end
for i=1:sampling:size(negative_images,1)*.8
    training_images = [training_images;negative_images(i,:)];
end

%Training labels
training_labels = [];
for i=1:sampling:round(size(pos_labels,1)*.8)-1
    training_labels = [training_labels;pos_labels(i,:)];
end
for i=1:sampling:size(neg_labels,1)*.8
    training_labels = [training_labels;neg_labels(i,:)];
end

%Testing images
testing_images = [];
for i=round(size(positive_images,1)*.8):sampling:size(positive_images,1)
    testing_images = [testing_images;positive_images(i,:)];
end
for i=round(size(negative_images,1)*.8)+1:sampling:size(negative_images,1)
    testing_images = [testing_images;negative_images(i,:)];
end

%Testing labels
testing_labels = [];
for i=round(size(pos_labels,1)*.8):sampling:size(pos_labels,1)
    testing_labels = [testing_labels;pos_labels(i,:)];
end
for i=round(size(neg_labels,1)*.8)+1:sampling:size(neg_labels,1)
    testing_labels = [testing_labels;neg_labels(i,:)];
end

% 
% % %% SVM Training
% %In this scrpit we want to deat with a binary classification problem.
% %Therefore we selec only those images corresponding to 0 or 1
 indexesZeros = find (training_labels == -1);
 indexesOnes = find (training_labels == 1);

% %this is a matrix below with images as index 0 as first row
% % and images index one as secon row same for labels
for i=1:size(training_images,1)
    training_images(i,:) = enhanceContrastHE(cast(training_images(i,:), 'uint8'));
end
training_images= [training_images(indexesZeros,:); training_images(indexesOnes,:)];
training_labels= [training_labels(indexesZeros); training_labels(indexesOnes)];

% For visualization purposes, we display the first 100 images
% figure
% for i=1:100
% 
%     % As you can notice by the size of the matrix image, each digit image
%     % has been transform into a long feature vector to be fed in a machine
%     % learning algorithm.
%     %FEATURE VECTOR = 1D matrice used to describe a feature of an image
%     
%     %To visualise or recompose the image again, we need to revert that
%     %process in its 160x96 image format
%     Im = reshape(training_images(i,:),160,96);
%     subplot(10,10,i), imagesc(Im), title(['label: ',num2str(training_labels(i))])
%     
% end


% It is difficult for humans to visualise the full space of digits, since they have more than 700 dimension.
% In order to make it more human friendly and understand how difficult is
% the problem, i.e. how close or far away are the different classes, we can
% apply dimenisonality reduction (we will see this in our last lectures), which will give us the most relevant
% dimension to observe
% [U,S,X_reduce] = pca(training_images,3);
% 
% figure, hold on
% colours= ['r.'; 'g.'; 'b.'; 'k.'; 'y.'; 'c.'; 'm.'; 'r+'; 'g+'; 'b+'; 'k+'; 'y+'; 'c+'; 'm+'];
% count=0;
% for i=min(training_labels):max(training_labels)
%     count = count+1;
%     indexes = find (training_labels == i);
%     plot3(X_reduce(indexes,1),X_reduce(indexes,2),X_reduce(indexes,3),colours(count,:))
% end

model = SVMtraining(training_images,training_labels);

%model = TreeBagger(100,training_images,training_labels);

% After calculating the support vectors, we can draw them in the previous
% image
% 
% hold on
% %transformation to the full image to the best 3 dimensions 
% imean=mean(training_images,1);
% xsup_pca=(model.xsup-ones(size(model.xsup,1),1)*imean)*U(:,1:3);
% % plot support vectors
% h=plot3(xsup_pca(:,1),xsup_pca(:,2),xsup_pca(:,3),'go');
% set(h,'lineWidth',5)

%% SVM Testing
indexesZeros = find (testing_labels == -1);
indexesOnes = find (testing_labels == 1);

testing_images= [testing_images(indexesZeros,:); testing_images(indexesOnes,:)];
testing_labels= [testing_labels(indexesZeros); testing_labels(indexesOnes)];


for i=1:size(testing_images,1)
    testing_images(i,:) = enhanceContrastHE(cast(testing_images(i,:), 'uint8'));
    testnumber= testing_images(i,:);
    
    classificationResult(i,1) = SVMTesting(testnumber,model);
    %classificationResult(i,1) = str2double(predict(model, testnumber));

end
% 
% 
% %% Evaluation

% Finally we compared the predicted classification from our mahcine
% learning algorithm against the real labelling of the esting image
comparison = (testing_labels==classificationResult);
incorrect_comparison = sum(testing_labels~=classificationResult);
tp=0;fp=0;tn=0;fn=0;
for i=1:size(classificationResult)
    if (classificationResult(i)==1 && testing_labels(i)==1)
        tp = tp+1;
    elseif (classificationResult(i)==1 && testing_labels(i)==-1)
        fp=fp+1;
    elseif (classificationResult(i)==-1 && testing_labels(i)==-1)
        tn=tn+1;
    else
        fn=fn+1;
    end
end


%Accuracy is the most common metric. It is defiend as the numebr of
%correctly classified samples/ the total number of tested samples
Accuracy = sum(comparison)/length(comparison);
error_rate = incorrect_comparison/length(comparison);
recall = tp / (tp + fn);
precision = tp / (tp + fp);
specificity = tn / (tn + fp);
f1 = 2*(precision*recall)/(precision+recall);
false_alarm_Rate = 1-specificity;
recognition_rate = tp/fp;


