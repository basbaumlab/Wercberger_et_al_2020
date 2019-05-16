
% Setup workspace 
clc; clear; close all 
addpath('.\User_Functions\')

% Where are your files 
filepath = 'C:\Users\basbaum\Box Sync\PROJECTS_Projection Neurons_Racheli\Matlab-Excel Files for FOS ISH Quant\CCK\50C\M005 CCK 50C Animal 2 (RB)\';
filenames = dir([filepath '*5.tif']); 

%% Perform data analysis 
for aa = 1:length(filenames)

    % Generate filename  
    input_img = [filenames(aa).folder '\' filenames(aa).name]; 

    % Perform counts 
    Wercberger_Counter(input_img)
    
end

%% Create figure of all projection neurons 
for aa = 1:length(filenames)    
    % Generate filename  
    input_img = [filenames(aa).folder '\' filenames(aa).name]; 
    input_tbl = [filenames(aa).folder '\' filenames(aa).name(1:end-4) '_table.xlsx']; 
    save_filename = [filenames(aa).folder '\' filenames(aa).name(1:end-4) '_processed.fig']; 
    
    if ~exist(save_filename)
        % Open
        tbl = readtable(input_tbl); 
        img = imread(input_img, 2); 
        img(:,:,2) = imread(input_img, 3);
        img(:,:,3) = imread(input_img, 4);

        % Plot 
        figure 
        imshow(img)
        hold on
        plot(tbl.X_pos, tbl.Y_pos, 'ow')
        hold off 

        % Save image 
        savefig(save_filename)
        close(gcf)
         
    end
end

%% Create figure just for CCK+ PN
for aa = 1:length(filenames)    
    % Generate filename  
    input_img = [filenames(aa).folder '\' filenames(aa).name]; 
    input_tbl = [filenames(aa).folder '\' filenames(aa).name(1:end-4) '_table.xlsx']; 
    save_filename = [filenames(aa).folder '\' filenames(aa).name(1:end-4) '_processed_CCK.fig']; 
    
    if ~exist(save_filename)
        % Open
        tbl = readtable(input_tbl); 
        img = imread(input_img, 2); 
        img(:,:,2) = imread(input_img, 3);
        img(:,:,3) = imread(input_img, 4);

        % Plot 
        figure 
        imshow(img)
        hold on
        plot(tbl.X_pos(tbl.CCK>0), tbl.Y_pos(tbl.CCK>0), 'ow')
        hold off 

        % Save image 
        savefig(save_filename)
        close(gcf)
    end
end

%% Create figure just for FOS+ PN
for aa = 1:length(filenames)    
    % Generate filename  
    input_img = [filenames(aa).folder '\' filenames(aa).name]; 
    input_tbl = [filenames(aa).folder '\' filenames(aa).name(1:end-4) '_table.xlsx']; 
    save_filename = [filenames(aa).folder '\' filenames(aa).name(1:end-4) '_processed_CCK.fig']; 
    
    if ~exist(save_filename)
        % Open
        tbl = readtable(input_tbl); 
        img = imread(input_img, 2); 
        img(:,:,2) = imread(input_img, 3);
        img(:,:,3) = imread(input_img, 4);

        % Plot 
        figure 
        imshow(img)
        hold on
        plot(tbl.X_pos(tbl.FOS>0), tbl.Y_pos(tbl.FOS>0), 'ow')
        hold off 

        % Save image 
        savefig(save_filename)
        close(gcf)
    end
end

%% Analyze output 
mouse_number = {'M005'};
gene_name = {'CCK'};
stimulus = {'50C'}; 
PN_cutoff_val = 1; % if want all, change to 0
for aa = 1:length(filenames)
    
    % filename 
    input_tbl = [filenames(aa).folder '\' filenames(aa).name(1:end-4) '_table.xlsx']; 
    
    % Read table 
    tbl = readtable(input_tbl); 
    
    % Fix data 
    tbl.RB = str2num(cell2mat(tbl.RB));
    tbl(tbl.RB == PN_cutoff_val, :) = []; 
    
    % New table values 
    PN_sum = sum(tbl.RB > 1);
    GENE_PN_sum = sum(tbl.CCK ~= 0); 
    FOS_PN_sum = sum(tbl.FOS ~= 0);  
    BOTH_PN_sum = sum((tbl.CCK ~= 0) & (tbl.FOS ~= 0));
    GENE_per = GENE_PN_sum/PN_sum;
    FOS_per = FOS_PN_sum/PN_sum;
    BOTH_per = BOTH_PN_sum/PN_sum;
    GENE_FOS_per = BOTH_PN_sum/GENE_PN_sum;
    image_name = {filenames(aa).name(1:end-4)}; 
    
    temp = table(   mouse_number, image_name, gene_name, stimulus, PN_sum, GENE_PN_sum, FOS_PN_sum, BOTH_PN_sum, ...
                    GENE_per, FOS_per, BOTH_per, GENE_FOS_per); 
                
    if aa == 1
        image_table = temp; 
    else
        image_table = [image_table; temp];
    end
end
image_table

% Save table 
writetable(image_table, [filepath mouse_number{1} '_' gene_name{1} '_' stimulus{1} '_table.xlsx'])


