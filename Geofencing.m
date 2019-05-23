%% Drawing out the superficial dorsal horn 

% setup workspace 
clc, clear, close all 

% File diectory 
mat_dir = 'C:\Users\basbaum\Box Sync\PROJECTS_Projection Neurons_Racheli\Matlab-Excel Files for FOS ISH Quant\CCK\50C\M005 CCK 50C Animal 2 (RB)\';

% Find files 
mat_files = dir([mat_dir '*.fig']);
tif_files = dir([mat_dir '*.tif']);
xlsx_files = dir([mat_dir '*.xlsx']);

for aa = 1:length(mat_files)
    % Points in or out? 
    tbl = readtable([xlsx_files(aa).folder '\' xlsx_files(aa).name]); 
    if size(tbl, 2) > 6
        continue
    else

        % Get image info 
        img_info = imfinfo([tif_files(aa).folder '\' tif_files(aa).name]);

        % Open figure and select points 
        openfig([mat_files(aa).folder '\' mat_files(aa).name]); 

        % Draw DH 
        [x,y] = getpts; 

        % Set new boundary for dorsal horn 
        x_DH = [  1; ...
                        x; ...
                        img_info(1).Width; ...
                        img_info(1).Width; ...
                        1; ...
                        1]; 

        y_DH = [  y(1); ... 
                        y; ...
                        y(end); ...
                        1; ...
                        1; ...
                        y(1)]; 

        DH_tbl = table(x_DH, y_DH); 

        hold on
        plot(DH_tbl.x_DH, DH_tbl.y_DH, 'r')

        % Draw LSN 
        [x,y] = getpts; 
        % Set new boundary for LSN
        if ~isempty(x)
            x_LSN = [x; x(1)]; 
            y_LSN = [y; y(1)]; 
        else
            x_LSN = [0; 0; 0; 0];
            y_LSN = [0; 0; 0; 0];
        end
        LSN_tbl = table(x_LSN, y_LSN);
        plot(LSN_tbl.x_LSN, LSN_tbl.y_LSN, 'g')
        hold off 

        pause(5)
        close(gcf)
     
        in_sDH = inpolygon(tbl.X_pos, tbl.Y_pos, DH_tbl.x_DH, DH_tbl.y_DH); 
        in_LSN = inpolygon(tbl.X_pos, tbl.Y_pos, LSN_tbl.x_LSN, LSN_tbl.y_LSN); 
        in_dDH = int8(~in_sDH & ~in_LSN); 
        in_sDH = int8(in_sDH); 
        in_LSN = int8(in_LSN); 
        
        % Read out table 
        tbl = [tbl, table(in_sDH), table(in_dDH), table(in_LSN)]; 

        % save over table 
        writetable(tbl, [xlsx_files(aa).folder '\' xlsx_files(aa).name])
    end
end





