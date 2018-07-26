%%  SegTexture_MSKCC  -  Epl
%       from Epl
%       little to no changes on my part
%


function [imBW,I1] = SegTexture_MSKCC(I)

showPlot = false;

if isempty(I)
    return 
end 
%% Segment
I1 = mat2gray(I);

filtWind = max(round(size(I)/10),1);
%I1 = mat2gray(I - imgaussfilt(I,filtWind));

Igrad1 = imadjust(mat2gray(imgradient(I1)));

% Igrad0 = imclose(Igrad0,strel('disk',5)); 
% Igrad0 = imopen(Igrad0,strel('disk',3));

% Igrad0 = mat2gray(Igrad0 - imgaussfilt(Igrad0,filtWind));

Igrad1 = mat2gray(imgaussfilt(Igrad1,3));
%  Igrad1 = mat2gray(Igrad0 );
%% Seg Gradient 
[h,counts] = histcounts(Igrad1);
h = medfilt1(h);
Imed = counts(h==max(h));
Imed = Imed(1);

%% 
testLow = counts(h < (max(h)*0.05));
testLow = max([testLow(testLow < Imed),0]);
testHigh = counts(h < (max(h)*0.05));
testHigh = min(testHigh(testHigh > Imed));

%% 
thresh = [testLow,testHigh];
imBW = Igrad1 >= thresh(2);

imBW = imclose(imBW,strel('disk',5)); 
imBW = imopen(imBW,strel('disk',3));

%% Seg Image
% I1 = mat2gray(I1 - imgaussfilt(I1,filtWind));
% [h2,counts2] = histcounts(I1);
% 
% h2 = medfilt1(h2);
% Imed = counts2(h2==max(h2));
% Imed = Imed(1);
% ILow = counts2(h2 < (max(h2)*0.02));
% ILow = max([ILow(ILow < Imed),0]);
% imD = I1 <= ILow;
% imD = bwareaopen(imD,50);
% 
% imBW = imBW & ~imD;
imBW = imerode(imBW,ones(12));
imBW = bwareaopen(imBW,500);

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
    
    subplot(2,3,[2,3,5,6])
    Icolor = repmat(imadjust(mat2gray(I1)),[1 1 3]);
    bI = double(imBW)*0.3;
    Icolor(:,:,1) = Icolor(:,:,1).*(1-bI) + bI;
    Icolor(:,:,2) = Icolor(:,:,1).*(1-bI);
    Icolor(:,:,3) = Icolor(:,:,3).*(1-bI);
    imagesc(Icolor)
    
    drawnow  
end

end