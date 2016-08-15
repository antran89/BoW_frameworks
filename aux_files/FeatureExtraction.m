%% extracting dense trajectories features from video
% using Dense Trajectories software to extract trajectory, HOG, HOF,
% MBHx, MBHy descriptors
% use default parameters as provided in the paper
% %% KTH dataset
% clear all;
% class = {'boxing', 'handclapping', 'handwaving', 'jogging', 'running', 'walking'};
% datasetFolder = '/home/tranlaman/Desktop/data/video/KTH/';
% featureFolder = '/home/tranlaman/Desktop/data/video/features/ImprovedDenseTrajectories/KTH/';
% for ind = 1:length(class)
%     datasetClassFolder = fullfile(datasetFolder, class{ind});
%     featureClassFolder = fullfile(featureFolder, class{ind});
%     if ~exist(featureClassFolder, 'dir')
%         mkdir(featureClassFolder);
%     end
%     if ~exist(fullfile(featureClassFolder, 'Trajectory'), 'dir')
%         mkdir(fullfile(featureClassFolder, 'Trajectory'));
%     end
%     if ~exist(fullfile(featureClassFolder, 'HOG'), 'dir')
%         mkdir(fullfile(featureClassFolder, 'HOG'));
%     end
%     if ~exist(fullfile(featureClassFolder, 'HOF'), 'dir')
%         mkdir(fullfile(featureClassFolder, 'HOF'));
%     end
%     if ~exist(fullfile(featureClassFolder, 'MBH'), 'dir')
%         mkdir(fullfile(featureClassFolder, 'MBH'));
%     end
%     cmdStr = './DenseTrack ';
%     files = dir(fullfile(datasetClassFolder, '*.avi'));
%     for i = 1:length(files)
%         file = files(i).name;
%         [~, fileName, ~] = fileparts(file);
%         inputFile = fullfile(datasetClassFolder, file);
%         % check if there is a file already
%         destFolder = fullfile(featureClassFolder, 'Trajectory/');
%         outputFile = fullfile(destFolder, strcat('Trajectory_', fileName, '.mat'));
%         if exist(outputFile, 'file')
%             continue;
%         end
%         % execute commands
%         cmd = horzcat(cmdStr, inputFile);
%         stt = system(cmd);
%         if stt ~= 0
%             disp('An error occured.')
%             return;
%         end
%         data = load('features.txt');
%         % Trajectory feature
%         feature = single(data(:, 8:37));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % HOG feature
%         feature = single(data(:, 38:133));
%         destFolder = fullfile(featureClassFolder, 'HOG/');
%         outputFile = fullfile(destFolder, strcat('HOG_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % HOF feature
%         feature = single(data(:, 134:241));
%         destFolder = fullfile(featureClassFolder, 'HOF/');
%         outputFile = fullfile(destFolder, strcat('HOF_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % MBH feature
%         feature = single(data(:, 242:433));
%         destFolder = fullfile(featureClassFolder, 'MBH/');
%         outputFile = fullfile(destFolder, strcat('MBH_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature data;
%         %     % delete out files
%         cmd = horzcat('rm features.txt');
%         system(cmd);
%         %toc
%     end
% end

% %% Hollywood2 dataset
% clear all;
% if matlabpool('size')==0
%     matlabpool open 4      % using parallel computing to accelerate
% end
% datasetFolder = '/home/tranlaman/Desktop/data/Hollywood2/Hollywood2/AVIClips';
% featureFolder = '/home/tranlaman/Desktop/data/features/DenseTrajectories/Hollywood2/';
% if ~exist(fullfile(featureFolder, 'Trajectory'), 'dir')
%     mkdir(fullfile(featureFolder, 'Trajectory'));
% end
% if ~exist(fullfile(featureFolder, 'HOG'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOG'));
% end
% if ~exist(fullfile(featureFolder, 'HOF'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOF'));
% end
% if ~exist(fullfile(featureFolder, 'MBH'), 'dir')
%     mkdir(fullfile(featureFolder, 'MBH'));
% end
% cmdStr = './release/DenseTrack ';
% files = dir(fullfile(datasetFolder, '*.avi'));
% errStt = zeros(length(files), 1); 
% parfor i = [201:962 964:length(files)]
%     file = files(i).name;
%     if exist(fullfile(featureFolder, 'Trajectory/', file), 'file')
%         continue;
%     end
%     [~, fileName, ~] = fileparts(file);
%     inputFile = fullfile(datasetFolder, file);
%     out = strcat(num2str(i),'.features');
%     cmd = horzcat(cmdStr, inputFile, ' > ', out);
%     stt = system(cmd);
%     if stt ~= 0
%         disp('An error occured.')
%         errStt(i) = 1;
%         continue;
%     end
%     data = load(out);
%     % delete out files
%     cmd = horzcat('rm ', out);
%     system(cmd);
%     % Trajectory feature
%     feature = data(:, 8:37);
%     destFolder = fullfile(featureFolder, 'Trajectory/');
%     outputFile = fullfile(destFolder, strcat('Trajectory_', fileName, '.mat'));
%     iSave(outputFile, feature);
%     %clear feature;
%     % HOG feature
%     feature = data(:, 38:133);
%     destFolder = fullfile(featureFolder, 'HOG/');
%     outputFile = fullfile(destFolder, strcat('HOG_', fileName, '.mat'));
%     iSave(outputFile, feature);
%     %clear feature;
%     % HOF feature
%     feature = data(:, 134:241);
%     destFolder = fullfile(featureFolder, 'HOF/');
%     outputFile = fullfile(destFolder, strcat('HOF_', fileName, '.mat'));
%     iSave(outputFile, feature);
%     %clear feature;
%     % MBH feature
%     feature = data(:, 242:433);
%     destFolder = fullfile(featureFolder, 'MBH/');
%     outputFile = fullfile(destFolder, strcat('MBH_', fileName, '.mat'));
%     iSave(outputFile, feature);
%     %clear feature;
%     %toc
% end


% %% Hollywood2 dataset
% % extract dense features for training set
% clear all;
% % if matlabpool('size')==0
% %     matlabpool open 4      % using parallel computing to accelerate
% % end
% datasetFolder = '/home/tranlaman/Desktop/data/video/Hollywood2/Hollywood2/AVIClips';
% featureFolder = '/home/tranlaman/Desktop/data/video/features/ImprovedDenseTrajectories/Hollywood2/';
% infoFolder = '/home/tranlaman/Desktop/data/video/Hollywood2/Hollywood2/ClipSets';
% bbFolder = '/home/tranlaman/Desktop/data/video/bb_file/Hollywood2';
% if ~exist(featureFolder, 'dir')
%     mkdir(featureFolder);
% end
% cmdStr = './DenseTrackStab ';
% fid = fopen(fullfile(infoFolder, 'actions_train.txt'));
% trainFiles = textscan(fid, '%s %*d\n', Inf);
% fclose(fid);
% % fid = fopen(fullfile(infoFolder, 'actions_test.txt'));
% % testFiles = textscan(fid, '%s %*d\n', Inf);
% % fclose(fid);
% % files = [trainFiles{1} ; testFiles{1}];
% files = trainFiles{1};
% errStt = zeros(length(files), 1, 'uint8'); 
% for i = 1:length(files)
%     fileName = files{i};
%     % check if there is a file already
%     outputFile = fullfile(featureFolder, strcat(fileName, '.mat'));
%     if exist(outputFile, 'file')
%         continue;
%     end
%     
%     % execute commands
%     inputFile = fullfile(datasetFolder, strcat(fileName, '.avi'));
%     bbFile = fullfile(bbFolder, [fileName, '.bb']);
%     cmd = horzcat(cmdStr, inputFile, ' -H ', bbFile);
%     stt = system(cmd);
%     if stt ~= 0
%         disp('An error occured.')
%         errStt(i) = 1;
%         continue;
%     end
%     
%     data = load('features.txt');
% %     % delete out files
% %     cmd = horzcat('rm ', out);
% %     system(cmd);
%     % Trajectory feature
%     feature = single(data);
%     clear data;
%     save(outputFile, 'feature', '-v7.3');
%     clear feature;
%     
%     % delete out files
%     delete('features.txt');
%     %toc
% 
% end
% 
% if any(errStt)
%     disp('There are some errors occurred')
% else
%     disp('There is no error.')
% end


%% HMDB51 dataset
% extract dense features for training set
clear all;
% if matlabpool('size')==0
%     matlabpool open 4      % using parallel computing to accelerate
% end
datasetFolder = '/home/beahacker/Public/data/video/HMDB/Video';
featureFolder = '/home/beahacker/Public/data/video/features/iDT/HMDB2';
bbFolder = '/home/beahacker/Public/data/video/bb_file/HMDB51';
if ~exist(fullfile(featureFolder, 'OrgTraj'), 'dir')
    mkdir(fullfile(featureFolder, 'OrgTraj'));
end
if ~exist(fullfile(featureFolder, 'Trajectory'), 'dir')
    mkdir(fullfile(featureFolder, 'Trajectory'));
end
if ~exist(fullfile(featureFolder, 'HOG'), 'dir')
    mkdir(fullfile(featureFolder, 'HOG'));
end
if ~exist(fullfile(featureFolder, 'HOF'), 'dir')
    mkdir(fullfile(featureFolder, 'HOF'));
end
if ~exist(fullfile(featureFolder, 'MBH'), 'dir')
    mkdir(fullfile(featureFolder, 'MBH'));
end
cmdStr = './newIDT ';
d = dir(datasetFolder);
actions = {d(:).name}';
actions(ismember(actions, {'.','..'})) = [];
for ind = 1:10
    files = dir(fullfile(datasetFolder, actions{ind}, '*.avi'));
    errStt = zeros(length(files), 1); 
    for i = 1:length(files)
        file = files(i).name;
        [~, fileName, ~] = fileparts(file);
        % check if there is a file already
        destFolder = fullfile(featureFolder, 'HOG/');
        outputFile = fullfile(destFolder, strcat('HOG_', fileName, '.mat'));
        if exist(outputFile, 'file')
            continue;
        end
        % execute commands
        inputFile = fullfile(datasetFolder, actions{ind}, strcat(fileName, '.avi'));
        bbFile = fullfile(bbFolder, [fileName, '.bb']);
        cmd = horzcat(cmdStr, '''',  inputFile, '''', ' -H ', '''', bbFile, ''''); % print one ', we need four ''''
        stt = system(cmd);
        if stt ~= 0
            disp('An error occured.')
            errStt(i) = 1;
            continue;
        end
        data = load('features.txt');

%         % Trajectory feature
%         if size(data, 1) > 0
%             feature = single(data(:, 11:40));
%         else
%             feature = single([]);
%         end
%         destFolder = fullfile(featureFolder, 'Trajectory/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('Trajectory_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
        % HOG feature
        if size(data, 1) > 0 
            feature = single(data(:, 41:136));
        else
            feature = single([]);
        end
        destFolder = fullfile(featureFolder, 'HOG/');
        outputFile = fullfile(destFolder, strcat('HOG_', fileName, '.mat'));
        save(outputFile, 'feature', '-v7.3');
        clear feature;
        % HOF feature
        if size(data, 1) > 0
            feature = single(data(:, 137:244));
        else
            feature = single([]);
        end
        destFolder = fullfile(featureFolder, 'HOF/');
        outputFile = fullfile(destFolder, strcat('HOF_', fileName, '.mat'));
        save(outputFile, 'feature', '-v7.3');
        clear feature;
        % MBH feature
        if size(data, 1) > 0
            feature = single(data(:, 245:436));
        else
            feature = single([]);
        end
        destFolder = fullfile(featureFolder, 'MBH/');
        outputFile = fullfile(destFolder, strcat('MBH_', fileName, '.mat'));
        save(outputFile, 'feature', '-v7.3');
        clear feature;
        % original trajectories
        if size(data, 1) > 0
            feature = single(data(:, [1, 437:end]));
        else
            feature = single([]);
        end
        destFolder = fullfile(featureFolder, 'OrgTraj/');
        outputFile = fullfile(destFolder, strcat('OrgTraj_', fileName, '.mat'));
        save(outputFile, 'feature', '-v7.3');
        clear feature data;

        % delete out files
        delete('features.txt');
        %toc

    end

    if any(errStt)
        disp('There are some errors occurred')
    else
        disp('There is no error.')
    end

end

exit

% %% UCF50 dataset
% % extract dense features for training set
% clear all;
% % if matlabpool('size')==0
% %     matlabpool open 4      % using parallel computing to accelerate
% % end
% datasetFolder = '/home/beahacker/Public/data/video/UCF50';
% featureFolder = '/media/beahacker/B228169828165BA3/features/UCF50/';
% bbFolder = '/home/beahacker/Public/data/video/bb_file/UCF50';
% if ~exist(fullfile(featureFolder, 'OrgTraj'), 'dir')
%     mkdir(fullfile(featureFolder, 'OrgTraj'));
% end
% if ~exist(fullfile(featureFolder, 'Trajectory'), 'dir')
%     mkdir(fullfile(featureFolder, 'Trajectory'));
% end
% if ~exist(fullfile(featureFolder, 'HOG'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOG'));
% end
% if ~exist(fullfile(featureFolder, 'HOF'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOF'));
% end
% if ~exist(fullfile(featureFolder, 'MBH'), 'dir')
%     mkdir(fullfile(featureFolder, 'MBH'));
% end
% cmdStr = './DenseTrackStab ';
% d = dir(datasetFolder);
% actions = {d(:).name}';
% actions(ismember(actions, {'.','..'})) = [];
% for ind = 1:50
%     files = dir(fullfile(datasetFolder, actions{ind}, '*.avi'));
%     if ~exist(fullfile(featureFolder, 'OrgTraj', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'OrgTraj', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'Trajectory', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'Trajectory', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'HOG', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'HOG', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'HOF', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'HOF', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'MBH', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'MBH', actions{ind}));
%     end
%     errStt = zeros(length(files), 1); 
%     for i = 1:length(files)
%         file = files(i).name;
%         [~, fileName, ~] = fileparts(file);
%         % check if there is a file already
%         destFolder = fullfile(featureFolder, 'Trajectory/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('Trajectory_', fileName, '.mat'));
%         if exist(outputFile, 'file')
%             continue;
%         end
%         % execute commands
%         inputFile = fullfile(datasetFolder, actions{ind}, strcat(fileName, '.avi'));
%         bbFile = fullfile(bbFolder, [fileName, '.bb']);
%         cmd = horzcat(cmdStr, '''',  inputFile, '''', ' -H ', '''', bbFile, ''''); % print one ', we need four ''''
%         stt = system(cmd);
%         if stt ~= 0
%             disp('An error occured.')
%             errStt(i) = 1;
%             continue;
%         end
%         data = load('features.txt');
% 
%         % Trajectory feature
%         if size(data, 1) > 0
%             feature = single(data(:, 11:40));
%         else
%             feature = [];
%         end
%         destFolder = fullfile(featureFolder, 'Trajectory/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('Trajectory_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % HOG feature
%         if size(data, 1) > 0
%             feature = single(data(:, 41:136));
%         else
%             feature = [];
%         end
%         destFolder = fullfile(featureFolder, 'HOG/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('HOG_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % HOF feature
%         if size(data, 1) > 0
%             feature = single(data(:, 137:244));
%         else
%             feature = [];
%         end
%         destFolder = fullfile(featureFolder, 'HOF/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('HOF_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % MBH feature
%         if size(data, 1) > 0
%             feature = single(data(:, 245:436));
%         else 
%             feature = [];
%         end
%         destFolder = fullfile(featureFolder, 'MBH/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('MBH_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % original trajectories
%         if size(data, 1)
%             feature = single(data(:, [1, 437:end]));
%         else
%             feature = [];
%         end
%         destFolder = fullfile(featureFolder, 'OrgTraj/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('OrgTraj_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature data;
% 
%         % delete out files
%         delete('features.txt');
%         %toc
% 
%     end
% 
%     if any(errStt)
%         disp('There are some errors occurred')
%     else
%         disp('There is no error.')
%     end
% 
% end

% %% UCF sports dataset
% % extract dense features for training set
% clear all;
% % if matlabpool('size')==0
% %     matlabpool open 4      % using parallel computing to accelerate
% % end
% datasetFolder = '/home/beahacker/Public/data/video/UCF-Sports_avi';
% featureFolder = '/home/beahacker/Public/data/video/features/ImprovedDenseTrajectories/UCF-Sports/';
% if ~exist(fullfile(featureFolder, 'OrgTraj'), 'dir')
%     mkdir(fullfile(featureFolder, 'OrgTraj'));
% end
% if ~exist(fullfile(featureFolder, 'Trajectory'), 'dir')
%     mkdir(fullfile(featureFolder, 'Trajectory'));
% end
% if ~exist(fullfile(featureFolder, 'HOG'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOG'));
% end
% if ~exist(fullfile(featureFolder, 'HOF'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOF'));
% end
% if ~exist(fullfile(featureFolder, 'MBH'), 'dir')
%     mkdir(fullfile(featureFolder, 'MBH'));
% end
% 
% fid = fopen(fullfile(datasetFolder, 'classes.txt'), 'r');
% actions = textscan(fid, '%s\n');
% actions = actions{1};
% fclose(fid);
% 
% cmdStr = './DenseTrackStab ';
% 
% for ind = 1:length(actions)
%     files = dir(fullfile(datasetFolder, actions{ind}, '*.avi'));
%     if ~exist(fullfile(featureFolder, 'OrgTraj', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'OrgTraj', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'Trajectory', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'Trajectory', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'HOG', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'HOG', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'HOF', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'HOF', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'MBH', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'MBH', actions{ind}));
%     end
%     errStt = zeros(length(files), 1); 
%     for i = 1:length(files)
%         file = files(i).name;
%         [~, fileName, ~] = fileparts(file);
%         % check if there is a file already
%         destFolder = fullfile(featureFolder, 'Trajectory/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('Trajectory_', fileName, '.mat'));
%         if exist(outputFile, 'file')
%             continue;
%         end
%         % execute commands
%         inputFile = fullfile(datasetFolder, actions{ind}, strcat(fileName, '.avi'));
%         cmd = horzcat(cmdStr, '''',  inputFile, ''''); % print one ', we need four ''''
%         stt = system(cmd);
%         if stt ~= 0
%             disp('An error occured.')
%             errStt(i) = 1;
%             continue;
%         end
%         data = load('features.txt');
% 
%         % Trajectory feature
%         feature = single(data(:, 11:40));
%         destFolder = fullfile(featureFolder, 'Trajectory/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('Trajectory_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % HOG feature
%         feature = single(data(:, 41:136));
%         destFolder = fullfile(featureFolder, 'HOG/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('HOG_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % HOF feature
%         feature = single(data(:, 137:244));
%         destFolder = fullfile(featureFolder, 'HOF/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('HOF_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % MBH feature
%         feature = single(data(:, 245:436));
%         destFolder = fullfile(featureFolder, 'MBH/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('MBH_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % original trajectories
%         feature = single(data(:, [1, 437:end]));
%         destFolder = fullfile(featureFolder, 'OrgTraj/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('OrgTraj_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature data;
% 
%         % delete out files
%         delete('features.txt');
%         %toc
% 
%     end
% 
%     if any(errStt)
%         disp('There are some errors occurred')
%     else
%         disp('There is no error.')
%     end
% 
% end

% %% UCF101 dataset
% % extract dense features for training set
% clear all;
% % if matlabpool('size')==0
% %     matlabpool open 4      % using parallel computing to accelerate
% % end
% datasetFolder = '/home/beahacker/Public/data/video/UCF101/UCF-101';
% featureFolder = '/home/beahacker/Public/data/video/features/ImprovedDenseTrajectories/UCF101/';
% if ~exist(fullfile(featureFolder, 'OrgTraj'), 'dir')
%     mkdir(fullfile(featureFolder, 'OrgTraj'));
% end
% if ~exist(fullfile(featureFolder, 'Trajectory'), 'dir')
%     mkdir(fullfile(featureFolder, 'Trajectory'));
% end
% if ~exist(fullfile(featureFolder, 'HOG'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOG'));
% end
% if ~exist(fullfile(featureFolder, 'HOF'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOF'));
% end
% if ~exist(fullfile(featureFolder, 'MBH'), 'dir')
%     mkdir(fullfile(featureFolder, 'MBH'));
% end
% cmdStr = './DenseTrackStab ';
% d = dir(datasetFolder);
% actions = {d(:).name}';
% actions(ismember(actions, {'.','..'})) = [];
% for ind = 1:101
%     files = dir(fullfile(datasetFolder, actions{ind}, '*.avi'));
%     if ~exist(fullfile(featureFolder, 'OrgTraj', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'OrgTraj', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'Trajectory', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'Trajectory', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'HOG', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'HOG', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'HOF', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'HOF', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'MBH', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'MBH', actions{ind}));
%     end
%     errStt = zeros(length(files), 1); 
%     for i = 1:length(files)
%         file = files(i).name;
%         [~, fileName, ~] = fileparts(file);
%         % check if there is a file already
%         destFolder = fullfile(featureFolder, 'Trajectory/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('Trajectory_', fileName, '.mat'));
%         if exist(outputFile, 'file')
%             continue;
%         end
%         % execute commands
%         inputFile = fullfile(datasetFolder, actions{ind}, strcat(fileName, '.avi'));
%         cmd = horzcat(cmdStr, '''', inputFile, ''''); % print one ', we need four ''''
%         stt = system(cmd);
%         if stt ~= 0
%             disp('An error occured.')
%             errStt(i) = 1;
%             continue;
%         end
%         data = load('features.txt');
% 
%         % Trajectory feature
%         if size(data, 1) > 0
%             feature = single(data(:, 11:40));
%         else
%             feature = single([]);
%         end
%         destFolder = fullfile(featureFolder, 'Trajectory/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('Trajectory_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % HOG feature
%         if size(data, 1) > 0 
%             feature = single(data(:, 41:136));
%         else
%             feature = single([]);
%         end
%         destFolder = fullfile(featureFolder, 'HOG/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('HOG_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % HOF feature
%         if size(data, 1) > 0
%             feature = single(data(:, 137:244));
%         else
%             feature = single([]);
%         end
%         destFolder = fullfile(featureFolder, 'HOF/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('HOF_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % MBH feature
%         if size(data, 1) > 0
%             feature = single(data(:, 245:436));
%         else
%             feature = single([]);
%         end
%         destFolder = fullfile(featureFolder, 'MBH/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('MBH_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % original trajectories
%         if size(data, 1) > 0
%             feature = single(data(:, [1, 437:end]));
%         else
%             feature = single([]);
%         end
%         destFolder = fullfile(featureFolder, 'OrgTraj/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('OrgTraj_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature data;
% 
%         % delete out files
%         delete('features.txt');
%         %toc
% 
%     end
% 
%     if any(errStt)
%         disp('There are some errors occurred')
%     else
%         disp('There is no error.')
%     end
% 
% end

% %% Penn_Action dataset
% % extract dense features for training set
% clear all;
% % if matlabpool('size')==0
% %     matlabpool open 4      % using parallel computing to accelerate
% % end
% datasetFolder = '/home/beahacker/Public/data/video/Penn_Action/frames';
% featureFolder = '/home/beahacker/Public/data/video/features/ImprovedDenseTrajectories/Penn_Action/';
% if ~exist(fullfile(featureFolder, 'OrgTraj'), 'dir')
%     mkdir(fullfile(featureFolder, 'OrgTraj'));
% end
% if ~exist(fullfile(featureFolder, 'Trajectory'), 'dir')
%     mkdir(fullfile(featureFolder, 'Trajectory'));
% end
% if ~exist(fullfile(featureFolder, 'HOG'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOG'));
% end
% if ~exist(fullfile(featureFolder, 'HOF'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOF'));
% end
% if ~exist(fullfile(featureFolder, 'MBH'), 'dir')
%     mkdir(fullfile(featureFolder, 'MBH'));
% end
% cmdStr = './DenseTrackStab ';
% d = dir(datasetFolder);
% actions = {d(:).name}';
% actions(ismember(actions, {'.','..'})) = [];
% 
% errStt = zeros(2326, 1); 
% for i = 1:2326
%     fileName = num2str(i, '%04d');
%     % check if there is a file already
%     destFolder = fullfile(featureFolder, 'Trajectory/');
%     outputFile = fullfile(destFolder, strcat('Trajectory_', fileName, '.mat'));
%     if exist(outputFile, 'file')
%         continue;
%     end
%     
%     % create video.avi from jpg files
%     videoObj = VideoWriter('video.avi');
%     videoObj.FrameRate = 25;
%     videoObj.open();
%     % check if exist jpeg files in the folder
%     imnames = dir(fullfile(datasetFolder, fileName, '*.jpg'));
%     for idx = 1:length(imnames)
%         im = imread(fullfile(datasetFolder, fileName, imnames(idx).name));
%         videoObj.writeVideo(im);
%     end
%     videoObj.close();
%     
%     % execute commands
%     cmd = horzcat(cmdStr, 'video.avi'); % print one ', we need four ''''
%     stt = system(cmd);
%     if stt ~= 0
%         disp('An error occured.')
%         errStt(i) = 1;
%         continue;
%     end
%     data = load('features.txt');
% 
%     % Trajectory feature
%     if size(data, 1) > 0
%         feature = single(data(:, 11:40));
%     else
%         feature = [];
%     end
%     destFolder = fullfile(featureFolder, 'Trajectory/');
%     outputFile = fullfile(destFolder, strcat('Trajectory_', fileName, '.mat'));
%     save(outputFile, 'feature', '-v7.3');
%     clear feature;
%     % HOG feature
%     if size(data, 1) > 0 
%         feature = single(data(:, 41:136));
%     else
%         feature = [];
%     end
%     destFolder = fullfile(featureFolder, 'HOG/');
%     outputFile = fullfile(destFolder, strcat('HOG_', fileName, '.mat'));
%     save(outputFile, 'feature', '-v7.3');
%     clear feature;
%     % HOF feature
%     if size(data, 1) > 0
%         feature = single(data(:, 137:244));
%     else
%         feature = [];
%     end
%     destFolder = fullfile(featureFolder, 'HOF/');
%     outputFile = fullfile(destFolder, strcat('HOF_', fileName, '.mat'));
%     save(outputFile, 'feature', '-v7.3');
%     clear feature;
%     % MBH feature
%     if size(data, 1) > 0
%         feature = single(data(:, 245:436));
%     else
%         feature = [];
%     end
%     destFolder = fullfile(featureFolder, 'MBH/');
%     outputFile = fullfile(destFolder, strcat('MBH_', fileName, '.mat'));
%     save(outputFile, 'feature', '-v7.3');
%     clear feature;
%     % original trajectories
%     if size(data, 1) > 0
%         feature = single(data(:, [1, 437:end]));
%     else
%         feature = [];
%     end
%     destFolder = fullfile(featureFolder, 'OrgTraj/');
%     outputFile = fullfile(destFolder, strcat('OrgTraj_', fileName, '.mat'));
%     save(outputFile, 'feature', '-v7.3');
%     clear feature data;
% 
%     % delete out files
%     delete('features.txt');
%     delete('video.avi');
%     %toc
% 
% end
% 
% if any(errStt)
%     disp('There are some errors occurred')
% else
%     disp('There is no error.')
% end

% %% UCF Youtube dataset
% % extract dense features for training set
% clear all;
% % if matlabpool('size')==0
% %     matlabpool open 4      % using parallel computing to accelerate
% % end
% datasetFolder = '/home/beahacker/Public/data/video/UCF_Youtube/action_youtube_naudio/';
% featureFolder = '/home/beahacker/Public/data/video/features/ImprovedDenseTrajectories/UCF_Youtube/';
% if ~exist(fullfile(featureFolder, 'OrgTraj'), 'dir')
%     mkdir(fullfile(featureFolder, 'OrgTraj'));
% end
% if ~exist(fullfile(featureFolder, 'Trajectory'), 'dir')
%     mkdir(fullfile(featureFolder, 'Trajectory'));
% end
% if ~exist(fullfile(featureFolder, 'HOG'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOG'));
% end
% if ~exist(fullfile(featureFolder, 'HOF'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOF'));
% end
% if ~exist(fullfile(featureFolder, 'MBH'), 'dir')
%     mkdir(fullfile(featureFolder, 'MBH'));
% end
% cmdStr = './DenseTrackStab ';
% 
% fid = fopen(fullfile(datasetFolder, 'classes.txt'), 'r');
% actions = textscan(fid, '%s\n');
% actions = actions{1};
% fclose(fid);
% 
% for ind = 1:length(actions)
%     d = dir(fullfile(datasetFolder, actions{ind}));
%     groups = {d(:).name}';
%     groups(ismember(groups, {'.','..'})) = [];
%     assert(length(groups) == 25)
%     for group_id = 1:length(groups)
%         files = dir(fullfile(datasetFolder, actions{ind}, groups{group_id}, '*.avi'));
%         if ~exist(fullfile(featureFolder, 'OrgTraj', actions{ind}), 'dir')
%             mkdir(fullfile(featureFolder, 'OrgTraj', actions{ind}));
%         end
%         if ~exist(fullfile(featureFolder, 'Trajectory', actions{ind}), 'dir')
%             mkdir(fullfile(featureFolder, 'Trajectory', actions{ind}));
%         end
%         if ~exist(fullfile(featureFolder, 'HOG', actions{ind}), 'dir')
%             mkdir(fullfile(featureFolder, 'HOG', actions{ind}));
%         end
%         if ~exist(fullfile(featureFolder, 'HOF', actions{ind}), 'dir')
%             mkdir(fullfile(featureFolder, 'HOF', actions{ind}));
%         end
%         if ~exist(fullfile(featureFolder, 'MBH', actions{ind}), 'dir')
%             mkdir(fullfile(featureFolder, 'MBH', actions{ind}));
%         end
%         errStt = zeros(length(files), 1); 
%         for i = 1:length(files)
%             file = files(i).name;
%             [~, fileName, ~] = fileparts(file);
%             % check if there is a file already
%             destFolder = fullfile(featureFolder, 'Trajectory/');
%             outputFile = fullfile(destFolder, actions{ind}, strcat('Trajectory_', fileName, '.mat'));
%             if exist(outputFile, 'file')
%                 continue;
%             end
%             % execute commands
%             inputFile = fullfile(datasetFolder, actions{ind}, groups{group_id}, files(i).name);
%             cmd = horzcat(cmdStr, '''', inputFile, ''''); % print one ', we need four ''''
%             stt = system(cmd);
%             if stt ~= 0
%                 disp('An error occured.')
%                 errStt(i) = 1;
%                 continue;
%             end
%             data = load('features.txt');
% 
%             % Trajectory feature
%             if size(data, 1) > 0
%                 feature = single(data(:, 11:40));
%             else
%                 feature = single([]);
%             end
%             destFolder = fullfile(featureFolder, 'Trajectory/');
%             outputFile = fullfile(destFolder, actions{ind}, strcat('Trajectory_', fileName, '.mat'));
%             save(outputFile, 'feature', '-v7.3');
%             clear feature;
%             % HOG feature
%             if size(data, 1) > 0 
%                 feature = single(data(:, 41:136));
%             else
%                 feature = single([]);
%             end
%             destFolder = fullfile(featureFolder, 'HOG/');
%             outputFile = fullfile(destFolder, actions{ind}, strcat('HOG_', fileName, '.mat'));
%             save(outputFile, 'feature', '-v7.3');
%             clear feature;
%             % HOF feature
%             if size(data, 1) > 0
%                 feature = single(data(:, 137:244));
%             else
%                 feature = single([]);
%             end
%             destFolder = fullfile(featureFolder, 'HOF/');
%             outputFile = fullfile(destFolder, actions{ind}, strcat('HOF_', fileName, '.mat'));
%             save(outputFile, 'feature', '-v7.3');
%             clear feature;
%             % MBH feature
%             if size(data, 1) > 0
%                 feature = single(data(:, 245:436));
%             else
%                 feature = single([]);
%             end
%             destFolder = fullfile(featureFolder, 'MBH/');
%             outputFile = fullfile(destFolder, actions{ind}, strcat('MBH_', fileName, '.mat'));
%             save(outputFile, 'feature', '-v7.3');
%             clear feature;
%             % original trajectories
%             if size(data, 1) > 0
%                 feature = single(data(:, [1, 437:end]));
%             else
%                 feature = single([]);
%             end
%             destFolder = fullfile(featureFolder, 'OrgTraj/');
%             outputFile = fullfile(destFolder, actions{ind}, strcat('OrgTraj_', fileName, '.mat'));
%             save(outputFile, 'feature', '-v7.3');
%             clear feature data;
% 
%             % delete out files
%             delete('features.txt');
%             %toc
% 
%         end
% 
%         if any(errStt)
%             disp('There are some errors occurred')
%         else
%             disp('There is no error.')
%         end
%     end
% end
% 
% exit

% %% SSBD dataset
% % extract dense features for training set
% clear all;
% % if matlabpool('size')==0
% %     matlabpool open 4         % using parallel computing to accelerate
% % end
% addpath('/home/beahacker/Desktop/workspace/mytoolbox')
% datasetFolder = '/home/beahacker/Public/data/video/ssbd';
% featureFolder = '/home/beahacker/Public/data/video/features/iDT/SSBD/';
% annotationFolder = '/home/beahacker/Desktop/workspace/dense_trajectories_BoW/ssbd-release/Annotations/';
% if ~exist(fullfile(featureFolder, 'OrgTraj'), 'dir')
%     mkdir(fullfile(featureFolder, 'OrgTraj'));
% end
% if ~exist(fullfile(featureFolder, 'Trajectory'), 'dir')
%     mkdir(fullfile(featureFolder, 'Trajectory'));
% end
% if ~exist(fullfile(featureFolder, 'HOG'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOG'));
% end
% if ~exist(fullfile(featureFolder, 'HOF'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOF'));
% end
% if ~exist(fullfile(featureFolder, 'MBH'), 'dir')
%     mkdir(fullfile(featureFolder, 'MBH'));
% end
% 
% fid = fopen(fullfile(datasetFolder, 'classes.txt'), 'r');
% actions = textscan(fid, '%s\n');
% actions = actions{1};
% fclose(fid);
% 
% cmdStr = './DenseTrackStab ';
% 
% counter = 0;
% for ind = 1:length(actions)
%     files = dir(fullfile(datasetFolder, actions{ind}, '*.avi'));
%     if ~exist(fullfile(featureFolder, 'OrgTraj', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'OrgTraj', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'Trajectory', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'Trajectory', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'HOG', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'HOG', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'HOF', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'HOF', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'MBH', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'MBH', actions{ind}));
%     end
%     assert(length(files) == 25);
%     errStt = zeros(length(files), 1); 
%     for i = 1:length(files)
%         counter = counter + 1;
%         fileName = num2str(counter);
%         % check if there is a file already
%         destFolder = fullfile(featureFolder, 'Trajectory/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('Trajectory_', fileName, '.mat'));
%         if exist(outputFile, 'file')
%             continue;
%         end
%         % find the start and end of stimming activity in the video
%         s = xml2struct(fullfile(annotationFolder, ['v_' actions{ind} '_' num2str(i, '%02d') '.xml']));
%         if length(s.video.behaviours.behaviour) == 1    % only one stimming action
%             timeText = s.video.behaviours.behaviour.time.Text;
%         else
%             timeText = s.video.behaviours.behaviour{1}.time.Text;
%         end
%         t = sscanf(timeText, '%d:%d');
%         
%         % execute commands
%         inputFile = fullfile(datasetFolder, actions{ind}, strcat(fileName, '.avi'));
%         % compute frame rate, for some video, fps provided by OpenCV is not
%         % accurate. So we need to compute it manually.
%         duration = sscanf(s.video.duration.Text, '%ds');
%         noFrames = mex_countNoFrames(inputFile);
%         fps = noFrames/duration;
%         S = floor(t(1)/100) * 60 + mod(t(1), 100);  % convert time into seconds
%         S = floor(fps * S);
%         E = floor(t(2)/100) * 60 + mod(t(2), 100);
%         E = floor(fps * E);
%         cmd = horzcat(cmdStr, '''',  inputFile, '''', sprintf(' -S %d -E %d', S, E)); % print one ', we need four ''''
%         stt = system(cmd);
%         if stt ~= 0
%             disp('An error occured.')
%             errStt(i) = 1;
%             continue;
%         end
%         data = load('features.txt');
%         if isempty(data)
%             continue;
%         end
% 
%         % Trajectory feature
%         feature = single(data(:, 11:40));
%         destFolder = fullfile(featureFolder, 'Trajectory/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('Trajectory_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % HOG feature
%         feature = single(data(:, 41:136));
%         destFolder = fullfile(featureFolder, 'HOG/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('HOG_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % HOF feature
%         feature = single(data(:, 137:244));
%         destFolder = fullfile(featureFolder, 'HOF/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('HOF_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % MBH feature
%         feature = single(data(:, 245:436));
%         destFolder = fullfile(featureFolder, 'MBH/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('MBH_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % original trajectories
%         feature = single(data(:, [1, 437:end]));
%         destFolder = fullfile(featureFolder, 'OrgTraj/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('OrgTraj_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature data;
% 
%         % delete out files
%         delete('features.txt');
%         %toc
% 
%     end
% 
%     if any(errStt)
%         disp('There are some errors occurred')
%     else
%         disp('There is no error.')
%     end
% 
% end
% 
% exit


% %% SSBD dataset
% % extract dense features for training set
% clear all;
% % if matlabpool('size')==0
% %     matlabpool open 4      % using parallel computing to accelerate
% % end
% datasetFolder = '/home/beahacker/Public/data/video/ssbd_avi';
% featureFolder = '/home/beahacker/Public/data/video/features/iDT/SSBD';
% if ~exist(fullfile(featureFolder, 'OrgTraj'), 'dir')
%     mkdir(fullfile(featureFolder, 'OrgTraj'));
% end
% if ~exist(fullfile(featureFolder, 'Trajectory'), 'dir')
%     mkdir(fullfile(featureFolder, 'Trajectory'));
% end
% if ~exist(fullfile(featureFolder, 'HOG'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOG'));
% end
% if ~exist(fullfile(featureFolder, 'HOF'), 'dir')
%     mkdir(fullfile(featureFolder, 'HOF'));
% end
% if ~exist(fullfile(featureFolder, 'MBH'), 'dir')
%     mkdir(fullfile(featureFolder, 'MBH'));
% end
% cmdStr = './DenseTrackStab ';
% 
% fid = fopen(fullfile(datasetFolder, 'classes.txt'), 'r');
% actions = textscan(fid, '%s\n');
% actions = actions{1};
% fclose(fid);
% 
% for ind = 1:length(actions)
%     files = dir(fullfile(datasetFolder, actions{ind}, '*.avi'));
%     if ~exist(fullfile(featureFolder, 'OrgTraj', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'OrgTraj', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'Trajectory', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'Trajectory', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'HOG', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'HOG', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'HOF', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'HOF', actions{ind}));
%     end
%     if ~exist(fullfile(featureFolder, 'MBH', actions{ind}), 'dir')
%         mkdir(fullfile(featureFolder, 'MBH', actions{ind}));
%     end
%     errStt = zeros(length(files), 1); 
%     for i = 1:length(files)
%         file = files(i).name;
%         [~, fileName, ~] = fileparts(file);
%         % check if there is a file already
%         destFolder = fullfile(featureFolder, 'Trajectory/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('Trajectory_', fileName, '.mat'));
%         if exist(outputFile, 'file')
%             continue;
%         end
%         % execute commands
%         inputFile = fullfile(datasetFolder, actions{ind}, strcat(fileName, '.avi'));
%         cmd = horzcat(cmdStr, '''', inputFile, ''''); % print one ', we need four ''''
%         stt = system(cmd);
%         if stt ~= 0
%             disp('An error occured.')
%             errStt(i) = 1;
%             continue;
%         end
%         data = load('features.txt');
% 
%         % Trajectory feature
%         if size(data, 1) > 0
%             feature = single(data(:, 11:40));
%         else
%             feature = single([]);
%         end
%         destFolder = fullfile(featureFolder, 'Trajectory/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('Trajectory_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % HOG feature
%         if size(data, 1) > 0 
%             feature = single(data(:, 41:136));
%         else
%             feature = single([]);
%         end
%         destFolder = fullfile(featureFolder, 'HOG/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('HOG_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % HOF feature
%         if size(data, 1) > 0
%             feature = single(data(:, 137:244));
%         else
%             feature = single([]);
%         end
%         destFolder = fullfile(featureFolder, 'HOF/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('HOF_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % MBH feature
%         if size(data, 1) > 0
%             feature = single(data(:, 245:436));
%         else
%             feature = single([]);
%         end
%         destFolder = fullfile(featureFolder, 'MBH/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('MBH_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature;
%         % original trajectories
%         if size(data, 1) > 0
%             feature = single(data(:, [1, 437:end]));
%         else
%             feature = single([]);
%         end
%         destFolder = fullfile(featureFolder, 'OrgTraj/');
%         outputFile = fullfile(destFolder, actions{ind}, strcat('OrgTraj_', fileName, '.mat'));
%         save(outputFile, 'feature', '-v7.3');
%         clear feature data;
% 
%         % delete out files
%         delete('features.txt');
%         %toc
% 
%     end
% 
%     if any(errStt)
%         disp('There are some errors occurred')
%     else
%         disp('There is no error.')
%     end
% 
% end
% exit
