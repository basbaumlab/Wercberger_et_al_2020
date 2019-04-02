
% Setup workspace 
clc; clear; close all 
addpath('.\User_Functions\')

% Where are your files 
filepath = 'C:\Users\basbaum\Box Sync\PROJECTS_Projection Neurons_Racheli\TIFF Images for Fos ISH Quantification\CCK CQ Animal 2 (RB)\';
filenames = dir([filepath '*.tif']); 

%% Perform data analysis 
for aa = 1:length(filenames)

    % Generate filename  
    input_img = [filenames(aa).folder '\' filenames(aa).name]; 

    % Perform counts 
    Wercberger_Counter(input_img)
    
end

