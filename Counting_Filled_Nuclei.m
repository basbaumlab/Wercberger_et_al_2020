
% Setup workspace 
clc; clear; close all 

% Where are your files 
filepath = 'C:\Users\basbaum\Box Sync\Postdoctoral Work - Basbaum\PROTOCOLS_Surgery_Behavior_Breeding\SURGERY_Viral Dilution Series\AAV1-Syn-FLEX-GCaMP6f\63XOil - Good for counting\Counting Images\';
filenames = dir([filepath '*.tif']); 
imagenames = struct2cell(filenames); 
imagenames = imagenames(1,:)'; 
p = randperm(length(imagenames)); 
imagenames = imagenames(p); 

%% 
if exist([filepath 'CellCount.mat']) == 0 
    for cc = 1:length(imagenames)
        % Open file 
        img = imread([filepath imagenames{cc}],1);
        img(:,:,2) = imread([filepath imagenames{cc}],2);
        
        % Add blank third color for RGB
        info = imfinfo([filepath imagenames{cc}]); 
        img(:,:,3) = zeros(info(1).Height, info(1).Width);
        
        % Process image 
        imGPU = gpuArray(img);
        imGPU = imgaussfilt(imGPU, 2); 
        imGPUadj = imadjust(imGPU,[0 0 0; .2 .1 .1],[]);
        
        % Show image and select neurons 
        imshow(imGPUadj(:,:,2))
        [x,y] = getpts; 
        close all

        % Show individual neurons 
        figure('Units', 'Normalized', 'Position', [.15 0 .25 1])
        fitplot = 150;
        for aa = 1:length(x)

            y_img = round([y(aa)-fitplot, y(aa)+fitplot]);
            x_img = round([x(aa)-fitplot, x(aa)+fitplot]); 
            
            titles = {'Overlay', 'DAPI', 'GCaMP6f'}; 
            for bb = 1:3
            subplot(3,1,bb)
                if bb == 1
                    imshow(imGPUadj) 
                elseif bb == 2
                    imshow(imGPUadj(:,:,1))
                elseif bb == 3
                    imagesc(imGPU(:, :, 2)) 
                    caxis([0 30000])
                    axis image
                end
                axis([x_img y_img])
                title(titles{bb});
            end

            % User choice. 
            quest = 'Is the nucleus of this cell filled in?';
            address = 'Choose one';
            btn1 = 'Yes'; 
            btn2 = 'No';
            btn3 = 'N/A'; 
            defbtn = btn1; 
            answer{aa,1} = questdlg(quest,address,btn1,btn2,btn3,defbtn); 

        end

        % Count answers 
        nuc_filled(cc,1) = sum(strcmp(answer, 'Yes')); 
        nuc_unfilled(cc,1) = sum(strcmp(answer, 'No')); 
        nuc_unknown(cc,1) = sum(strcmp(answer, 'N/A')); 

        close all
        clear answer 
    end
    
    % Create table 
    T = table(imagenames, nuc_filled, nuc_unfilled, nuc_unknown);
    T.mean_count = T.nuc_filled./(T.nuc_unfilled + T.nuc_filled); 
    T = sortrows(T,1)
    save([filepath 'CellCount'], 'T')
    
else
    % Load if exist 
    load([filepath 'CellCount.mat'])
end

%% 
if exist([filepath 'ProcessedCount.mat']) == 0
    % Display table 
    idx = 0; 
    for aa = 1:2:size(T,1) 
        idx = idx + 1; 
        mouse_finder = regexp(T.imagenames(aa), '_'); 
        mouse_finder = mouse_finder{1}(4); 
        mouse_num{idx,1} = T.imagenames{aa}([mouse_finder-3:mouse_finder-1]); 
        mouse_mean(idx,1) = mean(T.mean_count(aa:aa+1)); 
        mouse_sum(idx,1) = mean([   T.nuc_filled(aa)+T.nuc_unfilled(aa), ...
                                    T.nuc_filled(aa+1)+T.nuc_unfilled(aa+1)]); 
    end
    lin_T = table(mouse_num, mouse_mean, mouse_sum); 

    viral_con = inputdlg(lin_T.mouse_num, 'What viral concentration?'); 
    viral_time = inputdlg(lin_T.mouse_num, 'How long was virus expressed?'); 

    for aa = 1:size(lin_T,1)
        lin_T.v_con(aa) = str2num(viral_con{aa});
        lin_T.v_time(aa) = str2num(viral_time{aa}); 
    end
    save([filepath 'ProcessedCount.mat'], 'lin_T')
else
    load([filepath 'ProcessedCount.mat'])
end

%% Plot everything 

figure
idx = 0; 
mdl_param = {'v_time', 'v_con'};
mdl_out = {'mouse_mean', 'mouse_sum'}; 
for aa = 1:3
    for bb = 1:2
        idx = idx + 1;
        subplot(3,2,idx)
        if aa == 1
            mdl = fitlm(lin_T, [mdl_out{bb} ' ~ 1 + v_con + v_time']); 
        else
            mdl = fitlm(lin_T, [mdl_out{bb} '~ 1 +' mdl_param{aa-1}]); 
        end
        plot(mdl)
        grid on
    end
end
print([filepath 'lin_reg'], '-dpdf', '-fillpage')

