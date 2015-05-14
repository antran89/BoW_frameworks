function print_network(network)

network
network = struct2cell(network);

for i = 1:length(network)
    
   subnetwork = network{i};
   if isstruct(subnetwork)      
       print_network(subnetwork);
   end
    
end
    
end