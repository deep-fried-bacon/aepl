%%  SegIms  -  Epl
%       from Epl
%       little to no changes on my part
%
function [cellsOut] = SegIms(im,DrawPlot)
fprintf(1,'\tSegmenting Images\n')
%%

cells = cell(1,size(im,5));
UID = 1;

%%
im = mat2gray(im);
imf = median(im,5);
imf = imgaussfilt(imf,50);
im = im - imf;
%     im = permute(medfilt3(permute(im,[1 2 5 4 3]),[3,3,3]),[1 2 5 4 3]);
%%
for t = 1:size(im,5)        % for frames     [x,y,c,s,t]?
    %for t = randi(size(im,5))
    
    
    I1 = im(:,:,1,1,t);
    [imBW,bBri] = ProcessCzi.SegTexture_MSKCC(I1,DrawPlot);
    
    imBWs = imresize(imBW,0.5);
    L1 = ProcessCzi.SplitLargeAreas(imBWs);
    L1 = imresize(L1,size(imBW),'method','nearest');
    imBW = L1>0;
    imBW = bwareaopen(imBW,200);
    
    %%
    if DrawPlot
        
        subplot(2,3,6)
        
        LC = mat2gray(label2rgb(bwlabeln(L1),'jet','k','shuffle'));
        Icolor = ProcessCzi.MakeColor(im(:,:,1,1,t),LC);
        
        imagesc(Icolor)
        ax = gca();
        ax.Position = [2/3,0,1/3,0.5];
        grid on
        
        drawnow
        %imBW = bwareaopen(imBW,500);
    end
    
    
    %%
    
    [B] = bwboundaries(imBW,'noholes');
    
    CC = regionprops(imBW,double(bBri),'centroid','area','PixelList','MeanIntensity');
    CC2 = regionprops(imBW,double(L1),'MeanIntensity');
    
    
    for ii = 1:length(CC)
        CC(ii).id = UID;
        CC(ii).Tid = UID;
        CC(ii).time = t;
        CC(ii).Bound = B{ii};
        CC(ii).MitoScore = CC(ii).MeanIntensity;
        CC(ii).Label = 0;
        CC(ii).wasSplit = round( CC2(ii).MeanIntensity);
        UID = UID +1;
    end
    
    CC = rmfield(CC,'MeanIntensity');

    cells{t} = CC;
end

cellsOut = vertcat(cells{:});
end

