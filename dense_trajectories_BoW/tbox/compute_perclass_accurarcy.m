% Copyright (C) 2014 Tran Lam An.
% This code is for research, please do not distribute it.

function [perclass_accuracy] = compute_perclass_accurarcy(predicted_label, ground_truth, l)
%compute_perclass_accurarcy Summary of this function goes here
%   Detailed explanation goes here
%   load features of a video from a mat file
%   Input:  predicted_label
%           ground_truth
%           l : number of action classes
%  
perclass_accuracy = zeros(l, 1);
all_acc = predicted_label == ground_truth;
for i = 1 : l
    class_position = (ground_truth == i);
    perclass_accuracy(i) = sum(all_acc(class_position)) / sum(class_position);
end
end