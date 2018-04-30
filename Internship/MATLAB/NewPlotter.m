%%Reads the csv values of accelerometer and gyroscope from the file in the
%%same directory as the m file. Then plots all the six values.

%Getting the current directory.
p = [mfilename('fullpath'), '\'];

%storing the whole csv data in arr
arr = csvread('capture.csv');

%seperating individual channels
ax = arr(:, 1);
ay = arr(:, 2);
az = arr(:, 3);
gx = arr(:, 4);
gy = arr(:, 5);
gz = arr(:, 6);

R1 = asin((az)/sqrt((ay.^2)+(ax.^2)+(az.^2)))
R2 = asin((gz)/sqrt((gy.^2)+(gx.^2)+(gz.^2)))
%length of one vector
sz = 1:length(R1);

%plot
plot(sz,R1);
legend('accX', 'accY', 'accZ');
title('Accelerometer');

figure
plot(sz, R2);
legend('gyrX', 'gyrY', 'gyrZ');
title('Gyro');
