%this function labels data with kmeans result in batches/blocks, useful for removing memory requirements

function labels = find_labels_dnc(center,X)

blksize = 1e5;
nr_desc = size(X, 1);

labels = zeros(size(X, 1),1);

nr_calculated = 0;
while(nr_calculated<nr_desc)
    nr_tocalc = min(nr_desc-nr_calculated, blksize);
    head = nr_calculated+1;
    tail = nr_calculated+nr_tocalc;
    X_blk = X(head:tail,:);
    labels(head:tail) = findvword(center, X_blk);
    nr_calculated  = nr_calculated + nr_tocalc;
end

end