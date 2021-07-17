clc
close all
clear all

a = imread('test3.jpeg');
I=rgb2gray(a); %comment this if the picture is in png
%I=a; % comment this if the picture is in other format than PNG
figure, imshow(I);
 figure, imhist(I),title('Graph of Grayscale image'); %look at the hist to get a threshold, e.g., 110
 I = imadjust(I);
figure,imshow(I),title('Increase Contrast')
 %convert to binary
bw = imbinarize(I);
bw = bwareaopen(bw,50);
figure,imshow(bw),title('Binary')
I = im2bw(bw);  % be sure your image is binary

%identify Object
cc = bwconncomp(bw,4)
cc.NumObjects
grain = false(size(bw));
grain(cc.PixelIdxList{50}) = true;
% figure,imshow(grain)
labeled = labelmatrix(cc);%visualize
whos labeled
%change to rgb
RGB_label = label2rgb(labeled,'spring','c','shuffle');


%Computer Area-Based Statistic
graindata = regionprops(cc,'basic')
grain_areas = [graindata.Area]; %holds the area measurement for each grain.
grain_areas(50) %Find the area of the 50th component.
[min_area, idx] = min(grain_areas) % the grain with the smallest area.
[max_area, idx] = max(grain_areas) % the grain with the smallest area.
grain = false(size(bw));
grain(cc.PixelIdxList{idx}) = true;

L = bwlabel(I); % label each object
%Step 2: see the label of each object
s = regionprops(L, 'Centroid');
imshow(I)
hold on
for k = 1:numel(s)
    c = s(k).Centroid;
    text(c(1), c(2), sprintf('%d', k), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
end
hold off

% Step 3: find the area of the object you want using its label
Total_value=0;
Standard=0;
Area_1=0;
figure
for k = 1:numel(s)

Obj = (L == k);   %  is the label number of the first object. 
Area_1 = regionprops(Obj,'Area') % the answer

for (k=1)
%figure
imshow(Obj);

end
%depend on the picture size
if (Area_1.Area >300)
    Total_value=Total_value + 1;
else
    Total_value=Total_value + 0;
end

if ((Area_1.Area >500)&&(Area_1.Area <800))
    Standard=Standard + 1;
else
    Standard=Standard + 0; 
end

end
close
figure,imshow(RGB_label),title('RGB')
figure,histogram(grain_areas),title('Graph Number of Grain Rice vs. Size of Rice Grain')
h = msgbox(['The total number of rice grains ' num2str(Total_value)], 'Count Rice Grain')
h = msgbox(['The total number of rice grains that fits the standards ' num2str(Standard)], 'Count Standard Rice Grain')

    
    

