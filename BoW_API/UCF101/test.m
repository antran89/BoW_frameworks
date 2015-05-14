for i = 1:length(all_train_files)
    action = params.actions{all_train_labels(i)};
    data_file_name = all_train_files{i};
    S = load(fullfile(params.featurepath, params.feature_type, action,...
        strcat(params.feature_type, '_', data_file_name(1:end-4), '.mat')));
    if isempty(S.feature)
        disp(data_file_name);
    end
end

for i = 1:length(all_test_files)
    action = params.actions{all_test_labels(i)};
    data_file_name = all_test_files{i};
    S = load(fullfile(params.featurepath, params.feature_type, action,...
        strcat(params.feature_type, '_', data_file_name(1:end-4), '.mat')));
    if isempty(S.feature)
        disp(data_file_name);
    end
end