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

[h,counts] = histcounts(Igrad1);
h = medfilt1(h);
Imed = counts(h==max(h));
Imed = Imed(1);

%% 
testHigh = counts(h < (max(h)*0.2));
testHigh = min(testHigh(testHigh > Imed));

%% 
thresh = [0,testHigh];
imBW = Igrad1 >= thresh(2);

imBW = imclose(imBW,strel('disk',3)); 
imBW = imopen(imBW,strel('disk',3));

imBW = imerode(imBW,ones(10));

%%
bD = I1<0.2;
% bL = I1>0.65;
% bL = bL & ~imopen(bL,strel('disk',5));

bE = bwareaopen(bD,20);
bE = imdilate(bE,strel('disk',2));

imBW = imBW & ~bE;


%% 
bBright = I1>0.65;
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
    plot(counts(1:end-1),h);
    hold on
    
    plot([thresh(2),thresh(2)],[0,0.5*max(h(:))])
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