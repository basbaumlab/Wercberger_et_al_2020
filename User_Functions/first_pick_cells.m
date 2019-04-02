function [x,y] = first_pick_cells(input)

figure('Units', 'Normalized', 'Position', [0.1 0.1 .8 .8])
imshow(input.RB_img)
[x,y] = getpts; 
close(gcf)

end

