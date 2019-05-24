%% Cell Counting Script
%
% RUN THIS FIRST!
%
% This script will allow you to count cells within your image. It will also
% create figures that show projection neurons, CCK+ projections neurons,
% and FOS+ projection neurons. 

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
    save_filename = [filenames(aa).folder '\' filenames(aa).name(1:end-4) '_processed_FOS.fig']; 
    
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
