
clc
clear all;
close all;

% select an image from available images

[J P]=uigetfile('*.*','Select an Input Rice Image');

I = imread(strcat(P,J));

subplot(2,3,1),imshow(I),title('Original Image')

% convert into gray scale format 

Igray = rgb2gray(I);

subplot(2,3,2),imshow(Igray),title('Gray Scale Image')

% figure,imhist(Igray)
% Extract the edges of the rice grains
BW = edge(Igray,'sobel');
subplot(2,3,3),imshow(BW),title('edge detected Image')

% apply morphological operations

se90 = strel('line', 2, 90);
se0 = strel('line', 2, 0);
BW2 = imdilate(BW,[se90 se0]);
BWfill = imfill(BW2,'holes');
seD = strel('diamond',3);
BWfinal = imerode(BWfill,seD);
subplot(2,3,4),imshow(BW),title('Binary Image after Morphology')

% calculate the number of rice grains

bw = bwareaopen(BWfinal,50);
subplot(2,3,5),imshow(bw),title('Binary Image')
cc = bwconncomp(bw,4);
total_rice_grains=cc.NumObjects


% Measure the statistics(length and width) of the rice grains

stats = regionprops(BWfinal,{'MajorAxisLength','MinorAxisLength'})
stats = struct2table(stats)
% lengths=stats(:,1);
% widths=stats(:,2);

% calculate the L/B ratio for an image

MajorAxisLength = cat(1, stats.MajorAxisLength);
MinorAxisLength = cat(2, stats.MinorAxisLength);

L_B_Ratio=(MajorAxisLength./MinorAxisLength)

% imshow(BW)
% hold on
% plot(MajorAxisLength(:,1),MinorAxisLength(:,2), 'b*')
% hold off
% Show the result in image
% figure
% imshow(I)
% hold on

% for kk = 1:height(stats)
%  text(stats.MinorAxisLength(kk,1)+1, stats.MinorAxisLength(kk,2),...
%       num2str(stats.MajorAxisLength(kk)))
% end

% classification of rice grains depending on L/B ratio
for ii=1:total_rice_grains 
    
    rice_no=ii;
    
if (L_B_Ratio(ii)>=3)
   type='slender';

elseif(L_B_Ratio(ii)>=2.1 && L_B_Ratio(ii)<3)
    type='medium';
    
elseif(L_B_Ratio(ii)>=1.1 && L_B_Ratio(ii)<2.1)
    type='bold';
else
    type='round';
end
X = sprintf('  Rice Grain Number %d is of type %s .',rice_no,type);
disp(X)
end 

