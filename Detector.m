clear all
close all

% original attempt for detction

%We load the classification model of our choice
%////////////To be completed at STEP 2 \\\\\\\\\\\\
load detectorModel

[images, labels] = loadDatabase('I:\matlab\pedestrian\pedestrian',1);

I=images(1,:);
label = 1;

topLeftRow = 1;
topLeftCol = 1;
[bottomRightCol, bottomRightRow] = size(I);

numberRows=10;
numberColumns=10;

%Using previous information, we can calculate how tall and wide is each
%digit
I = imresize(I, [160, 96]);
I = reshape(I,160,96);
samplingX=round(size(I,1)/numberRows);
samplingY=round(size(I,2)/numberColumns);

digitCounter=0;

%Implementation of a simplified slidding window
% we will be accumulating all the predictions in this variable
predictedFullImage=[];
%for each digit within the image,
for r=1:samplingX:size(I,1)
    predictedRow=[];
    for c= 1:samplingY:size(I,2)
    % 3072, 15360, 3, 10
    if (c+samplingY-1 <= size(I,2)) && (r+samplingX-1 <= size(I,1))
        digitCounter =digitCounter+1;
%we crop the digit
        digitIm = I(r:r+samplingX-1, c:c+samplingY-1);

%All training examples were 28x28. To have any chance, we need to
%resample them into a 28x28 imaGE
        I = imresize(I, [160, 96]);
        digitIm = reshape(I,160,96);
        digitIm = hog_feature_vector(digitIm);

        %We display the individually segmented digits
        subplot(numberRows,numberColumns,digitCounter)
        imshow(digitIm)

        prediction = SVMTesting(digitIm, model);
        predictedRow=[predictedRow prediction];
        end
    end
    predictedFullImage=[predictedFullImage; predictedRow];
end

predictedFullImage;

%% Evaluation
%Groundtruth
% solutionTruth = loadPedestrian
% comparison = (predictedFullImage==solutionTruth);
% Accuracy = sum(sum(comparison))/ (size(comparison,1)*size(comparison,2));