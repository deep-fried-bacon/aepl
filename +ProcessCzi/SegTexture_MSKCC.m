%%  SegTexture_MSKCC  -  Epl
%       from Epl
%       little to no changes on my part
%


function [imBWFinal,bBright] = SegTexture_MSKCC(Iin,DrawPlot)


if isempty(Iin)
    
    imBWFinal = [];
    bBright = [];
    
    return 
end 

Disk7 = strel('disk',7);
Disk3 = strel('disk',3);

MaxArea = 1500;
MinArea = 600;
MinArea2 = 50;

%% Segment
 I1 = mat2gray(Iin);
 
Igrad1 = I1;
Igrad1 = imresize(Igrad1 ,0.5);

Igrad1 = stdfilt(Igrad1);
%Igrad1 = imgradient(Igrad1);
% Igrad1 = im2uint8(Igrad1);
%Igrad1 = imopen(Igrad1,Disk3);
Igrad1 = imadjust(mat2gray(Igrad1));
Igrad1 = imresize(Igrad1,size(I1));
Igrad1 = mat2gray(Igrad1);

%% Seg Gradient 
% 
I2 = Igrad1;
[h,counts] = histcounts(I2);
h = medfilt1(h);
Imed = counts(h==max(h));
Imed = Imed(1);

%% 
testHigh = counts(h < (max(h)*0.1));
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

imBW = imclose(imBW,Disk3); 
imBW1 = imopen(imBW,Disk3);
imBW = imerode(imBW1,Disk7);


%% Find the Edges that separate the cells 
I = I1;
I = I - median(I(:));

% I(~imdilate(imBW,Disk7))=0;

I = I/std(I(:));
I = min(I,9);
I = max(I,-9);

bD = I<-2;
bD = bwareaopen(bD,10);
% bD = bD & ~imopen(imclose(bD,Disk7),Disk3);

% bL = I>4;
% bL = bwareaopen(bL,MinArea2);
% bL = bL & ~imopen(bL,Disk10);


bE = bD;

bE = bwareaopen(bE,MinArea2);
bE = imdilate(bE,strel('disk',1));
%% Mitotic
bBright = I>3;

bBright(~imBW1) = 0;

bBright = bwareaopen(bBright,MinArea2);
bBright = imclose(bBright,Disk3);
bBright = imopen(bBright,Disk3);

bBright = bwareaopen(bBright,MinArea2*2);
bBright = imdilate(bBright,Disk3);

bBrtE = imdilate(bBright,Disk7)& ~bBright;

%% Remove to make final Binary image 

bE = bE & ~bBright;

imBW = imBW & ~bBrtE;

imBWbig = bwareaopen(imBW,MaxArea);
imBWsml = imBW & ~imBWbig;
imBW = imBWsml | (imBWbig & ~bE);

imBW = bwareaopen(imBW,MinArea);

imBWFinal = imBW | bBright;
imBWFinal(1:50,1:50) = 0;
%%  Show Segmentation
if DrawPlot
    
    I3 = cat(3,imBW,bE,bBright);
    ProcessCzi.Plot6(Igrad1,testHigh,I,I1,I3)
end

end

