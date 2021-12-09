function [images,labels] = loadDataset(filename,label)
%reference - https://matlab.fandom.com/wiki/FAQ#How_can_I_process_a_sequence_of_files.3F

% Specify the folder where the files live.
myFolder = filename;
% Check to make sure that folder actually exists. Warn user if it doesn't.
if ~isfolder(myFolder)
errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', myFolder);
uiwait(warndlg(errorMessage));
myFolder = uigetdir(); % Ask for a new one.
if myFolder == 0
% User clicked Cancel
return;
end
end
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.jpg'); % Change to whatever pattern you need.
theFiles = dir(filePattern);images=[];
labels =[];
numberOfImages = length(theFiles);
for k = 1 : numberOfImages
labels= [labels; label];
baseFileName = theFiles(k).name;
fullFileName = fullfile(theFiles(k).folder, baseFileName);
fprintf(1, 'Now reading %s\n', fullFileName);
% Now do whatever you want with this file name,
% such as reading it in as an image array with imread()
imageArray = imread(fullFileName);
I=imageArray;
if size(I,3)>1
    I=rgb2gray(I);
end
vector = reshape(I,1, size(I, 1) * size(I, 2));
vector = double(vector); % / 255;
images= [images; vector];
end
end

