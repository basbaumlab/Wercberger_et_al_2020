function first_show_cells(input)

imGPUadj = cat(3,   input.DAPI_img, ...
                    input.RB_img, ...
                    input.BLANK_img);
x_img = input.x_img; 
y_img = input.y_img; 

figure('Units', 'Normalized', 'Position', [.15 0 .25 1])
titles = {'Overlay', 'DAPI', 'RB'}; 
for aa = 1:size(imGPUadj,3)
    subplot(size(imGPUadj,3),1,aa)
    if aa == 1
        imshow(imGPUadj) 
    elseif aa > 1
        imshow(gather(imGPUadj(:,:,aa-1)))
    end
    hold on
    plot([mean(x_img) mean(x_img)], [0 1000], '-w')
    plot([0 1000], [mean(y_img) mean(y_img)], '-w')
    hold off 
    axis([x_img y_img])
    title(titles{aa});
end

end

