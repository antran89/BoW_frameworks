% script to low pass filter blk video data with a gaussian lpf

% load ~/s9/youtube/fl/blktrain_16x16x10_np100.mat
% load ~/s9/youtube/fl/blktrain_20x20x14_np100.mat

load ~/s4/Hollywood2/FeatLearning/hw2/blktrain_20x20x14_np200.mat

img_sz = 20; 
sigma = 1;
X = reshape(X, img_sz*img_sz, []);

Y1 = zeros(size(X));

for i = 1:size(X, 2);
    i
    img = reshape(X(:, i), img_sz, img_sz);
    filter = fspecial('gaussian', [3, 3], sigma);
    img = imfilter(img, filter, 'symmetric', 'same');
    %img = conv2(img, filter, 'same');
    Y1(:, i) = reshape(img, [], 1);
end

X = Y1; clear Y1;
save('~/s9/hw2/fl/blktrain_20x20x14_np200_smooth.mat', 'X', '-v7.3');
quit
