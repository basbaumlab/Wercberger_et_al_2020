%% Animal Data Merger 
%
% RUN THIS SCRIPT LAST. 
%
% This script will merge together data from individual images within an
% animal file, and will generate the MASTER_FILE, where each row is an
% individual animal, with data averaged across images. 
%
% This script will also produce pie (YUM!) charts (DOH!) from the MASTER 
% FILE data .  

% step up workspace 
clc, clear, close all

% filepath 
filepath = 'C:\Users\basbaum\Box Sync\PROJECTS_Projection Neurons_Racheli\Matlab-Excel Files for FOS ISH Quant\Count Files for each animal\';
filenames = dir([filepath '*table.xlsx']); 

for aa = 1:length(filenames)
    
    animal_table = readtable([filenames(aa).folder '\' filenames(aa).name]);     
    temp = cell2table(num2cell(mean(animal_table{:, 5:end},1)));     
    temp.Properties.VariableNames = animal_table.Properties.VariableNames(5:end); 
    temp = [animal_table(1,1), animal_table(1,3), animal_table(1,4), temp];
    
    if aa == 1
        exp_table =  temp; 
    else
        exp_table = [exp_table; temp]; 
    end
    
end
exp_table
writetable(exp_table,[filepath 'Master_File.xlsx'])

% Make figures 
rgbmatrix = [25, 70, 250; 160, 0, 200; 250, 0, 30; 204, 204, 204]/255; 
u_gene = unique(exp_table.gene_name); 
u_stim = unique(exp_table.stimulus); 
for aa = 1:length(u_gene)
    
    % Logical vector of gene names 
    gene_log = strcmp(exp_table.gene_name, u_gene{aa}); 
    
    for bb = 1:length(u_stim)
        
        stim_log = strcmp(exp_table.stimulus, u_stim{bb});
         
        if sum(gene_log & stim_log) == 0
            continue
        end
        
        % First slice is gene, both, fos, none, going counter clockwise 
        for_pie = mean(exp_table{gene_log & stim_log, 8:10}, 1); 
        for_pie = [for_pie(1) - for_pie(3), for_pie(3), for_pie(2) - for_pie(3), 1-(for_pie(1)+for_pie(2))]*100; 

        figure
        hPieComponentHandles = pie(for_pie); 
        for cc = 1:length(for_pie)
            set(hPieComponentHandles((cc*2)-1), 'FaceColor', rgbmatrix(cc,:), 'EdgeColor', [10, 150, 15]/250, 'LineWidth', 3);
        end
        legend
        title([u_gene{aa} ' ' u_stim{bb}])
        print([filepath 'figure ' u_gene{aa} ' ' u_stim{bb}], '-dpdf')
        close(gcf)
    end
end

