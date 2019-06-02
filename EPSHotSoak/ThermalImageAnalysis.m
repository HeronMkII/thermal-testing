max_val = 0;
min_val = 0;
av_front = zeros(480,640,3);
av_back = zeros(480,640,3);
img_list = cell(1,8);
pixel_tot = 0;

% Print each image with the mask
for i = 1:8
    filename = sprintf('%s%d%s','ThermalCameraImages\image_',i,'.jpg');
    [image,cmap] = imread(filename);
    image_double = im2double(rgb2gray(image)); 
    max_val = max(image_double(:));
    min_val = min(image_double(:));
    image_double(image_double<=0.5*max_val)=nan;
    figure
    imagesc(image_double, [0.5*max_val,max_val]);
    colorbar;
    colormap(hot(256))
    axis image
    axis off
end

% Align the first four images
for i = 1:4
    filename = sprintf('%s%d%s','ThermalCameraImages\image_',i,'.jpg');
    [image,cmap] = imread(filename);
    image_double = im2double(rgb2gray(image)); 
    img_list{1,i} = image_double;
    if (i > 1)
        [optimizer,metric] = imregconfig('multimodal');
        reshaped = imregister(img_list{1,i},img_list{1,1},'rigid',optimizer,metric);
        img_list{1,i} = reshaped;
    end
end

% Get the average of the first four images (front of the board)
for i = 1:480
    for j = 1:640
        for k = 1:4
            pixel_tot = pixel_tot + img_list{1,k}(i,j);
        end
        av_pixel = pixel_tot/4;
        pixel_tot = 0;
        av_front(i,j) = av_pixel;
    end
end

% Print the average of the first four images
figure
av_front = av_front(75:480,1:520);
max_val = max(av_front(:));
min_val = min(av_front(:));
av_front(av_front<=0.5*max_val)=nan;
imagesc(av_front, [0.5*max_val,max_val]);
colormap(hot(256))
colorbar
axis image
axis off

% Same process for the back of the board
for i = 5:8
    filename = sprintf('%s%d%s','ThermalCameraImages\image_',i,'.jpg');
    [image,cmap] = imread(filename);
    image_double = im2double(rgb2gray(image)); 
    img_list{1,i} = image_double;
    if (i > 5)
        [optimizer,metric] = imregconfig('multimodal');
        reshaped = imregister(img_list{1,i},img_list{1,5},'rigid',optimizer,metric);
        img_list{1,i} = reshaped;
    end
end

for i = 1:480
    for j = 1:640
        for k = 5:8
            pixel_tot = pixel_tot + img_list{1,k}(i,j);
        end
        av_pixel = pixel_tot/4;
        pixel_tot = 0;
        av_back(i,j) = av_pixel;
    end
end

figure
av_back = av_back(75:480,1:520);
max_val = max(av_back(:));
min_val = min(av_back(:));
av_back(av_back<=0.5*max_val)=nan;
imagesc(av_back, [0.5*max_val,max_val]);
colormap(hot(256))
colorbar
axis image
axis off
