function dEuc = EuclideanDistance(sample1,sample2)
dEuc = 0;
for i=1:size(sample1,2) %could also use length - samples are row vectors so you want to iterate over the columns which is why you use the 2 here
        dEuc = dEuc + (sample1(i) - sample2(i))^2;
end
dEuc = sqrt(dEuc);