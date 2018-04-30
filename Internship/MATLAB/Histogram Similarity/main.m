file1 = 'D:\University\Internship\MATLAB\Histogram Similarity\test\danial1.csv';
file2 = 'D:\University\Internship\MATLAB\Histogram Similarity\test\danial2.csv';
file3 = 'D:\University\Internship\MATLAB\Histogram Similarity\test\elaaf1.csv';
file4 = 'D:\University\Internship\MATLAB\Histogram Similarity\test\elaaf2.csv';

[binsA1, countsA1, binsG1, countsG1] = getHist(file1);
[binsA2, countsA2, binsG2, countsG2] = getHist(file2);

[binsA3, countsA3, binsG3, countsG3] = getHist(file3);
[binsA4, countsA4, binsG4, countsG4] = getHist(file4);


distA1 = abs(countsA1-countsA2);
distG1 = abs(countsG1-countsG2);

distA2 = abs(countsA3-countsA4);
distG2 = abs(countsG3-countsG4);

sumA1 = sum(distA1)
sumG1 = sum(distG1)

sumA2 = sum(distA2)
sumG2 = sum(distG2)

%sumA3 = sum(distA3)
%sumG3 = sum(distG3)

