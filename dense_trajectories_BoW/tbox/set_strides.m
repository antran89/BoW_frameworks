function network = set_strides(network, params)
%set stride and convolution parameters for the ISA network

for i = 1: params.num_isa_layers-1
    network.isa{i}.spatial_stride = params.stride{i}.spatial_stride;
    network.isa{i}.temporal_stride = params.stride{i}.temporal_stride;
    
    numsamplesper_spcol = floor((network.isa{i+1}.fovea.spatial_size - network.isa{i}.fovea.spatial_size)/network.isa{i}.spatial_stride+1);
    numsamplesper_tpcol = floor((network.isa{i+1}.fovea.temporal_size - network.isa{i}.fovea.temporal_size)/network.isa{i}.temporal_stride+1);

    network.isa{i}.numsamplesper_spcol = numsamplesper_spcol;
    network.isa{i}.numsamplesper_tpcol = numsamplesper_tpcol;
    network.isa{i}.num_subsamples = numsamplesper_spcol^2*numsamplesper_tpcol;
end
end