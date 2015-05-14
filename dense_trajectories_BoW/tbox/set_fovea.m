function network = set_fovea(network, network_params)

for i = 1:network_params.num_isa_layers
   network.isa{i}.fovea = network_params.fovea{i}; 
end

end