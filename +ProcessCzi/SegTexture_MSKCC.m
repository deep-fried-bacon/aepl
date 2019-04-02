%%  SegTexture_MSKCC  -  Epl
%       from Epl
%       little to no changes on my part
%


function [imBWFinal,bBright] = SegTexture_MSKCC(I)

showPlot = true;

if isempty(I)
    return 
end 
%% Segment
 I1 = mat2gray(I);
% filtWind = max(round(size(I)/5),1);
% I1 = mat2gray(I - imgaussfilt(I,filtWind));

Igrad1 = mat2gray(imgradient(I1));
%    gxcjgx = imclose(Igrad0,strel('disk',5)); 
Igrad1 = imopen(Igrad1,strel('disk',7));

% Igrad0 = mat2gray(Igrad0 - imgaussfilt(Igrad0,filtWind));
Igrad1 = imadjust(Igrad1);
Igrad1 = mat2gray(imgaussfilt(Igrad1,3));
%  Igrad1 = mat2gray(Igrad0 );
%% Seg Gradient 
% 
I2 = Igrad1;
[h,counts] = histcounts(I2);
h = medfilt1(h);
Imed = counts(h==max(h));
Imed = Imed(1);

%% 
testHigh = counts(h < (max(h)*0.2));
testHigh = min(testHigh(testHigh > Imed));
thresh = [0,testHigh];

%%
% I2 = Igrad1;
% I2 = I2 - median(I2(:));
% I2 = I2/std(I2(:));
% I2 = min(I2,7);
% I2 = max(I2,-7);
% thresh = [0,0.8];
%%

imBW = I2 >= thresh(2);

imBW = imclose(imBW,strel('disk',3)); 
imBW = imopen(imBW,strel('disk',3));

imBW = imerode(imBW,ones(10));


%% Find the Edges that separate the cells 
I = I1;
I = I - median(I(:));
I = I/std(I(:));
I = min(I,9);
I = max(I,-9);

bD = I<-3;
bD = uint8(bD) + uint8(bwareaopen(bD,50));
bD = bD & ~imopen(bD,strel('disk',10));


bL = I>3;
bL = bwareaopen(bL,50);
bL = bL & ~imopen(bL,strel('disk',10));

bE = bD | bL;

bE = bwareaopen(bE,50);

%% Mitotic
bBright = I>4;
bBright = bwareaopen(bBright,50);
bBright = imclose(bBright,strel('disk',3));
bBright = bwareaopen(bBright,90);
bBright = imopen(bBright,strel('disk',2));
bBright = imdilate(bBright,strel('disk',5));

bBrtE = imdilate(bBright,strel('disk',10))& ~bBright;


%% 

bE = bE & ~bBright;

imBW = imBW & ~bBrtE;

imBWbig = bwareaopen(imBW,20000);
imBWsml = imBW & ~imBWbig;
imBW = imBWsml | (imBWbig & ~bE);


imBWFinal = bwareaopen(imBW,500) | bBright;

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
    color = [1 -1 -1];
    for i = 1:3
    Icolor(:,:,i) = Icolor(:,:,i) +  0.5*double(bI)*color(i);
    end 
    
    color = [-1 1 -1];
    for i = 1:3
    Icolor(:,:,i) = Icolor(:,:,i) +  0.5*double(bI2)*color(i);
    end 
    
    color = [-1 -1 1];
    for i = 1:3
    Icolor(:,:,i) = Icolor(:,:,i) +  0.5*double(bE)*color(i);
    end 
    
    imagesc(Icolor)
    
    drawnow  
end

end