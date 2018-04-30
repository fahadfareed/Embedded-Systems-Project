%%Reads the csv values of accelerometer and gyroscope from the file in the
%%same directory as the m file. Then plots all the six values.

%Getting the current directory.
p = [mfilename('fullpath'), '\'];

%storing the whole csv data in arr
arr = csvread('abdullah6.csv');

%seperating individual channels
ax = arr(:, 1);
ay = arr(:, 2);
az = arr(:, 3);
gx = arr(:, 4);
gy = arr(:, 5);
gz = arr(:, 6);

%length of one vector
sz = 1:length(ax);

%plot
subplot(3,1,1);
plot(sz,ax);
title('Accelerometer-X');

subplot(3,1,2);
plot(sz,ay);
title('Accelerometer-Y');

subplot(3,1,3);
plot(sz,az);
title('Accelerometer-Z');

figure
subplot(3,1,1);
plot(sz,gx);
title('Gyrometer-X');

subplot(3,1,2);
plot(sz,gy);
title('Gyrometer-Y');

subplot(3,1,3);
plot(sz,gz);
title('Gyrometer-Z');
