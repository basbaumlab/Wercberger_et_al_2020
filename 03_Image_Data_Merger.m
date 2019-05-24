%% Image Data Merger 
%
% RUN THIS SCRIPT AFTER RUNNING GEOFENCING. 
%
% This script will merge xlsx count files from individual images after you
% have counted each image and then run the geofencing script. This will not
% work without having done the geofencing on each image within the folder.
% The output will be a table (xlsx) that contains the mean values for each
% image, for a specific animal (determined by where the directory points
% to). Data is averaged across neurons. 

% Setup workspace 
clc; clear; close all 
addpath('.\User_Functions\')

% Where are your files 
filepath = 'C:\Users\basbaum\Box Sync\PROJECTS_Projection Neurons_Racheli\Matlab-Excel Files for FOS ISH Quant\CCK\50C\M005 CCK 50C Animal 2 (RB)\';
filenames = dir([filepath '*5_table.xlsx']); 


%% Analyze output 
mouse_number = {'M005'};
gene_name = {'CCK'};
stimulus = {'50C'}; 
PN_cutoff_val = 1; % if want all, change to 0
for aa = 1:length(filenames)
    
    % filename 
    input_tbl = [filenames(aa).folder '\' filenames(aa).name]; 
     
    % Read table 
    tbl = readtable(input_tbl); 

    % Fix data 
    tbl.RB = str2num(cell2mat(tbl.RB));
    tbl(tbl.RB == PN_cutoff_val, :) = []; 
    
    % Cell count results  
    % Sum values 
    PN_sum = sum(tbl.RB > 1);
    GENE_PN_sum = sum(tbl.CCK ~= 0); 
    FOS_PN_sum = sum(tbl.FOS ~= 0);  
    BOTH_PN_sum = sum((tbl.CCK ~= 0) & (tbl.FOS ~= 0));

    % Percentage values 
    GENE_per = GENE_PN_sum/PN_sum;
    FOS_per = FOS_PN_sum/PN_sum;
    BOTH_per = BOTH_PN_sum/PN_sum;
    GENE_FOS_per = BOTH_PN_sum/GENE_PN_sum;
    
    % Geofencing results 
    % Sum values 
    sDH_sum = sum(tbl.in_sDH); 
    dDH_sum = sum(tbl.in_dDH);
    LSN_sum = sum(tbl.in_LSN);
    
    % Percentage values 
    sDH_per = sDH_sum/PN_sum; 
    dDH_per = dDH_sum/PN_sum;
    LSN_per = LSN_sum/PN_sum;
    
    % Image name
    image_name = {filenames(aa).name(1:end-4)}; 
    
    % Build table 
    temp = table(   mouse_number, image_name, gene_name, stimulus, PN_sum, GENE_PN_sum, FOS_PN_sum, BOTH_PN_sum, ...
                    GENE_per, FOS_per, BOTH_per, GENE_FOS_per, sDH_sum, dDH_sum, LSN_sum, sDH_per, dDH_per, LSN_per); 
                
    if aa == 1
        image_table = temp; 
    else
        image_table = [image_table; temp];
    end
end
image_table

% Save table 
writetable(image_table, [filepath mouse_number{1} '_' gene_name{1} '_' stimulus{1} '_table.xlsx'])




