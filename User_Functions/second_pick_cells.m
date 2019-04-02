function [x,y] = second_pick_cells(input)

imGPUadj = cat(3,   input.DAPI_img, ...
                    input.RB_img, ...
                    input.BLANK_img);

figure
imshow(gather(imGPUadj))
axis([input.x_img input.y_img])
[x,y] = getpts;
close(gcf)

end

