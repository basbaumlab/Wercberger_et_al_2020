function Wercberger_Counter(input_img)

% Check for saved output 
save_filename = [input_img(1:end-4) '_table.xlsx']; 
if exist(save_filename, 'file')
    return
end

% Let user know they are working on a new image 
h = msgbox('You are working on a new image.'); 
uiwait(h)

% Open and process images  
for aa = 1:4
    
    % Open each channel within an image individually  
    temp = imread(input_img, aa);

    % Convert to gpuArray and filter  
    tempGPU = gpuArray(temp);
    tempGPU = imgaussfilt(tempGPU, .75); 
    
    % Adjust levels 
    switch aa
        case 1
            adj_levels = [0     0.3]; 
        case 2
            adj_levels = [0.03  0.25]; 
        case 3 
            adj_levels = [0     1]; 
        case 4
            adj_levels = [0     1]; 
    end
    tempGPU = imadjust(tempGPU, adj_levels, []); 
                                
    switch aa
        case 1
            input.DAPI_img = tempGPU; 
        case 2
            input.RB_img = tempGPU; 
        case 3 
            input.CCK_img = tempGPU; 
        case 4
            input.FOS_img = tempGPU; 
    end
end

% Create blank for RGB
info = imfinfo(input_img); 
input.BLANK_img = zeros(info(1).Height, info(1).Width);

% Show image and select neurons 
[x,y] = first_pick_cells(input); 

%%  Show and identify individual neurons 
fitplot = 25;
idy = 1; 
for aa = 1:length(x)

    input.y_img = round([y(aa)-fitplot, y(aa)+fitplot]);
    input.x_img = round([x(aa)-fitplot, x(aa)+fitplot]);

    % Do stuff 
    [local_answer] = identify_cells(input); 
    close(gcf)

    switch local_answer

        % If two or more cells counted on first try 
        case 'Two or more cells'

            % Try picking again 
            [x_redo, y_redo] = second_pick_cells(input); 

            % Cycle through split cells 
            for bb = 1:length(x_redo)
                input.y_img = round([y_redo(bb)-fitplot, y_redo(bb)+fitplot]);
                input.x_img = round([x_redo(bb)-fitplot, x_redo(bb)+fitplot]);
                [local_answer] = identify_cells(input);
                close(gcf)

                % Identify position 
                switch local_answer
                    case 'One Cell'
                        cells(idy).x_pos = x_redo(bb); 
                        cells(idy).y_pos = y_redo(bb);
                        idy = idy + 1; 
                end
            end

        % If not a cell 
        case 'Not a cell'
            continue

        % If one cell counted on first try 
        case 'One Cell'
            cells(idy).x_pos = x(aa); 
            cells(idy).y_pos = y(aa);
            idy = idy + 1; 
    end            
end

%% Answer questions 
for aa = 1:length(cells)
    input.x = round(cells(aa).x_pos,1); 
    input.y = round(cells(aa).y_pos,1); 
    input.y_img = round([   cells(aa).y_pos - fitplot, ...
                            cells(aa).y_pos + fitplot]);
    input.x_img = round([   cells(aa).x_pos - fitplot, ...
                            cells(aa).x_pos + fitplot]);
    [answers] = interrogate_cells(input); 

    if aa == 1
        table_out = answers; 
    else
        table_out = [table_out; answers];
    end
    close(gcf)
end

% Save output 
writetable(table_out, save_filename)

end

