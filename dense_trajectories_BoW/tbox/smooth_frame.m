function frame = smooth_frame(input)

sigma = 1; 
filter = fspecial('gaussian', [3, 3], sigma);
frame = imfilter(input, filter, 'symmetric', 'same');
