function second_show_cells(input)

imGPUadj = cat(3,   input.DAPI_img, ...
                    input.RB_img, ...
                    input.BLANK_img);
x_img = input.x_img; 
y_img = input.y_img; 

figure('Units', 'Normalized', 'Position', [.15 0 .25 1])
titles = {'G = RB / R = DAPI', 'G = CCK / R = DAPI', 'G = FOS / R = DAPI'}; 
for aa = 1:length(titles)
    subplot(length(titles),1,aa)
    if aa == 1
        imshow(imGPUadj) 
        imGPUadj(:,:,2) = input.CCK_img;
    elseif aa > 1
        imshow(imGPUadj)
        if aa == 2
            imGPUadj(:,:,2) = input.FOS_img; 
        end
    end
    hold on
    plot([mean(x_img) mean(x_img)], [0 1000], '-w')
    plot([0 1000], [mean(y_img) mean(y_img)], '-w')
    hold off 
    axis([x_img y_img])
    title(titles{aa});
end

end

