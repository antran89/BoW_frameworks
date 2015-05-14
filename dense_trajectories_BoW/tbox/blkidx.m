function blk_idx = blkidx(blk_size, zero_start_index)
%quick code to for block index manipulation
    blk_idx = blk_size*zero_start_index+1: blk_size*(zero_start_index+1);
end