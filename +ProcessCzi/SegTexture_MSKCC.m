%%  SegTexture_MSKCC  -  Epl
%       from Epl
%       little to no changes on my part
%


function [imBW,bBright] = SegTexture_MSKCC(I)

showPlot = true;

if isempty(I)
    return 
end 
%% Segment
 I1 = mat2gray(I);
% filtWind = max(round(size(I)/5),1);
% I1 = mat2gray(I - imgaussfilt(I,filtWind));

Igrad1 = mat2gray(imgradient(I1));
% Igrad0 = imclose(Igrad0,strel('disk',5)); 
Igrad1 = imopen(Igrad1,strel('disk',7));

% Igrad0 = mat2gray(Igrad0 - imgaussfilt(Igrad0,filtWind));
Igrad1 = imadjust(Igrad1);
Igrad1 = mat2gray(imgaussfilt(Igrad1,3));
%  Igrad1 = mat2gray(Igrad0 );
%% Seg Gradient 
% 
% [h,counts] = histcounts(Igrad1);
% h = medfilt1(h);
% Imed = counts(h==max(h));
% Imed = Imed(1);
% 
% %% 
% testHigh = counts(h < (max(h)*0.2));
% testHigh = min(testHigh(testHigh > Imed));


I2 = Igrad1;
I2 = I2 - median(I2(:));
I2 = I2/std(I2(:));
I2 = min(I2,7);
I2 = max(I2,-7);

%% 
thresh = [0,0.8];
imBW = I2 >= thresh(2);

imBW = imclose(imBW,strel('disk',3)); 
imBW = imopen(imBW,strel('disk',3));

imBW = imerode(imBW,ones(10));

%%
I = I1;
I = I - median(I(:));
I = I/std(I(:));
I = min(I,7);
I = max(I,-7);

bD = I<-2;
% bL = I1>0.65;
% bL = bL & ~imopen(bL,strel('disk',5));

bE = bwareaopen(bD,50);
bE = imdilate(bE,strel('disk',2));

imBW = imBW & ~bE;

%% 
bBright = I>5;
bBright = bwareaopen(bBright,50);
bBright = imclose(bBright,strel('disk',3));
bBright = bwareaopen(bBright,90);
bBright = imopen(bBright,strel('disk',2));
bBright = imdilate(bBright,strel('disk',5));

bBrtE = imdilate(bBright,strel('disk',10))& ~bBright;

imBW = imBW &~bBrtE;


imBW = bwareaopen(imBW,500) | bBright;

%%  Show Segmentation
if showPlot
    subplot(2,3,1)
    histogram(Igrad1(:))
    hold on
    

    hold off
%     
    subplot(2,3,4)
    imagesc(Igrad1)
    colormap jet
    
    subplot(2,3,[2,3,5,6])
    Icolor = repmat(imadjust(mat2gray(I1)),[1 1 3]);
    bI = double(imBW)*0.5;
    bI2 =  double(bBright)*0.5;
    Icolor(:,:,1) = max(Icolor(:,:,1).*(1-bI),0) + bI;
    Icolor(:,:,2) = max(Icolor(:,:,1).*(1-bI),0) + bI2;
    Icolor(:,:,3) = max(Icolor(:,:,3).*(1-bI),0) + bE;
    imagesc(Icolor)
    
    drawnow  
end

end