function prediction = KNNTesting(testImage,modelNN, K)
N = size(modelNN.neighbours, 1);
distances = zeros(N,1);
for i=1:N %modelNN(1:i)? i.e. from first image to however many images there are
    distances(i) =EuclideanDistance(testImage, modelNN.neighbours(i,:)); %go through every row for the first column which is images - second column labels? model(:,1) how to iterate through this?
end
[d,index] = sort(distances); %d is the distances in ascending order, index is the index for each value in the unsorted array where it appears in the sorted result
index_closest = index(1:K);
model_val_closest = modelNN.neighbours(index_closest,:);
nearest_labels = modelNN.labels(index_closest,:);
prediction = mode(nearest_labels,1);

%if k is 3 prediciton returns the 3 most so store all distances sort them
%then use mode or take top 3?
%see KNN on edge favourites