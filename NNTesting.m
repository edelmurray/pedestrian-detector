function prediction = NNTesting(testImage,modelNN)
smallest_distance = EuclideanDistance(testImage, modelNN.neighbours(1,:));%column vector so every image in first row and every column
smallest_index = 1;
prediction = modelNN.labels(1,1);
for i=1:size(modelNN.neighbours,1) %modelNN(1:i)? i.e. from first image to however many images there are
    distance =EuclideanDistance(testImage, modelNN.neighbours(i,:)); %go through every row for the first column which is images - second column labels? model(:,1) how to iterate through this?
    if distance < smallest_distance
        smallest_distance = distance;
        smallest_index = i;
    end
end
prediction = modelNN.labels(smallest_index);