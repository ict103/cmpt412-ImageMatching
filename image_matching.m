%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CMPT 412 Image Matching
% Ivy Tse
% Mar 18, 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

collage = imread('SwainCollageForBackprojectionTesting.bmp');

%Testing Models
%uncomment one line for testing
%model = imread('crunchberries.sqr.128.bmp'); %No, third
%model = imread('garan.sqr.128.bmp'); %Yes
%model = imread('balloons.sqr.128.bmp'); %Yes
%model = imread('girls.sqr.128.bmp'); %No, third
%model = imread('chickensoupnoodles.sqr.128.bmp'); %Yes
model = imread('flyer.sqr.128.bmp'); %No
%model = imread('clamchowder.sqr.128.bmp'); %Yes
%model = imread('charmin.sqr.128.bmp'); %Yes
%model = imread('carebears.sqr.128.bmp'); %Yes
%model = imread('car.sqr.128.bmp'); %Yes
%model = imread('bakit.sqr.128.bmp'); %No, second
%model = imread('frankenberry.sqr.128.bmp'); %No, second

%figure, imshow(collage);
figure('Name', 'Model'), imshow(model);
%CCgray = rgb2gray(captaincrunch);
redModel = model(:, :, 1);
greenModel = model(:, :, 2);
blueModel = model(:, :, 3);

%resize the collage image so that model size is the same as each
%individual collage 
resizecol = imresize(collage, [270 512]);
collagesize = size(resizecol); 
%figure('Name', 'Image'), imshow(resizecol); %display figure one

w = collagesize(2)/4;
h = collagesize(1)/3;

%array that stores the sum of colour histogram values
regionArr = zeros(3, 4);

for i = 0:2
    for j = 0:3
        %crop each individual collage
        sub = [w*j h*i w h]; 
        subpic = imcrop(resizecol, sub);
        %figure, imshow(subpic); %display figure two
        %subpicg = rgb2gray(subpic);

        redsubpic = subpic(:, :, 1);
        greensubpic = subpic(:, :, 2);
        bluesubpic = subpic(:, :, 3);

        redMin = 0;
        greenMin = 0;
        blueMin = 0;
        
        %calculate ratio and sum of the colour histograms
        for k = 1:8
            [redmodelCount,redmodelCategories] = histcounts(redModel, 8);
            [redCount,redCategories] = histcounts(redsubpic, 8);
            Mr = redmodelCount(k);
            Ir = redCount(k);
            redRatio = Mr/Ir;
            if redRatio > 1
                redMin = redMin + 1;
            else
                redMin = redMin + redRatio;
            end
    
            [greenmodelCount,greenmodelCategories] = histcounts(greenModel, 8);
            [greenCount,greenCategories] = histcounts(greensubpic, 8);
            Mg = greenmodelCount(k);
            Ig = greenCount(k);
            greenRatio = Mg/Ig;
            if greenRatio > 1
                greenMin = greenMin + 1;
            else
                greenMin = greenMin + greenRatio;
            end
    
            [bluemodelCount,bluemodelCategories] = histcounts(blueModel, 8);
            [blueCount,blueCategories] = histcounts(bluesubpic, 8);
            Mb = bluemodelCount(k);
            Ib = blueCount(k);
            blueRatio = Mb/Ib;
            if blueRatio > 1
                blueMin = blueMin + 1;
            else
                blueMin = blueMin + blueRatio;
            end
        end
        regionArr(i+1, j+1) = redMin + greenMin + blueMin;
    end
end

%disp(regionArr);
%sort and find the top 3 colour histogram values
maxArr = reshape(regionArr.', 12, 1);
rowIndex = [0; 0; 0; 0; 1; 1; 1; 1; 2; 2; 2; 2];
columnIndex = [0; 1; 2; 3; 0; 1; 2; 3; 0; 1; 2; 3];
Unsorted = cat(2, maxArr, rowIndex, columnIndex);
sortedArr = sortrows(Unsorted);

%draw rectangles of top 3 matches
match = insertShape(resizecol, 'rectangle', [w*sortedArr(12, 3) h*sortedArr(12, 2) w h],...
    'LineWidth', 6, 'Color', 'green');
match = insertShape(match, 'rectangle', [w*sortedArr(11, 3) h*sortedArr(11, 2) w h],...
    'LineWidth', 4, 'Color', 'yellow');
match = insertShape(match, 'rectangle', [w*sortedArr(10, 3) h*sortedArr(10, 2) w h],...
    'LineWidth', 2, 'Color', 'cyan');
figure('Name','Matching Location');
imshow(match);


%{
figure('Name', 'Red');
hold on;
subplot(1,2,1);
imhist(redModel, 8);
subplot(1,2,2);
imhist(redsubpic, 8);

figure('Name', 'Green');
hold on;
subplot(1,2,1);
imhist(greenModel, 8);
subplot(1,2,2);
imhist(greensubpic, 8);

figure('Name', 'Blue');
hold on;
subplot(1,2,1);
imhist(blueModel, 8);
subplot(1,2,2);
imhist(bluesubpic, 8);
%}