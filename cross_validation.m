%%Cross validation 
% Load database
% load in positive images with positive pedestrian detection with label 1
[positive_images] = loadDatabase('C:\Users\edele\matlab 2\images\images\pos',1);
%load in negative images with negative pedestrian detection with label -1
[negative_images] = loadDatabase('C:\Users\edele\matlab 2\images\images\neg',-1);
all_images = [];

k_fold = 3;
sampling = 10;
% i=training set 
% label negative and poitive images accordingly, were going to combine them
% into one dataset, not loading in labels so have to assign ourselves. 
for i=1:size(positive_images)
    img = ["1" positive_images(i,:)];
    all_images = [all_images; img ];
end
for j=1:size(negative_images)
%     img = ["-1" negative_images(j,:)];
    all_images = [all_images; ["-1" negative_images(j,:)]];
end

randomize images for training/testing
all_images = all_images(randperm(size(all_images,1)),:);

k_loop = fix(size(all_images,1)/k_fold);
index = 1;
% z assigns which dataset to use for training
z = 1;
testing = [];
training=[];

% loop over training and testing of svm model k_fold times, then averge the
% accuracy scores
for m=1:k_fold
%     getting the different allocation of traing and testing
    for i=1:k_fold
        for j=1:k_loop
            if i==z
                testing = [testing;all_images(index,:)];
            else
                training = [training; all_images(index,:)];
            end
            index=index+1;
        end
    end
    training_labels = [training;training(1,:)];
     feature_vectors = [];
     for i=1:size(training,1)
         training(i,:) = enhanceContrastHE(cast(training(i,:), 'uint8'));
         sample_image = reshape(training(i,:),160,96);
         feature = hog_feature_vector(sample_image);
         feature_vectors = [feature_vectors;feature];
     end
    
    model = SVMtraining(feature_vectors,training_labels);
    
    % NN Testing
    test_feature_vectors = [];
    for i=1:size(testing,1)
        training_images(i,:) = enhanceContrastHE(cast(testing(i,:), 'uint8'));
        test_image = reshape(testing(i,:),160,96);%this gave errors with 160,96
        test_feature = hog_feature_vector(test_image);
        test_feature_vectors = [test_feature_vectors;test_feature];
    end
    
    for i=1:size(testing,1)
        
        testnumber= test_feature_vectors(i,:);
        
        classificationResult(i,1) = SVMTesting(testnumber,model);
    
    end
    
    %Evaluation
    testing_labels  = [testing;testing(1,:)];
    comparison = (testing_labels==classificationResult);
    Accuracy{i} = sum(comparison)/length(comparison);
    %     ensure different section is chosen for testing each time
    z=z+1;
end
for i=1:size(Accuracy,1)
    sum_a= Accuracy{i};
end
Avg_accuracy=sum/k_fold;













% x = [positive_images;negative_images]; 
% y = [pos_labels;neg_labels];
% images = crossvalind('Kfold',x,10);
% labels = crossvalind('Kfold',y,10);
% for i = 1:10
%     test = (images == i); 
%     train = ~test;
%     test_l = (labels == i); 
%     train_l = ~test_l;
%     model = SVMtraining(train,test);
% end