%%  SegIms  -  Epl
%       from Epl
%       little to no changes on my part
%
function [cellsOut] = SegIms(im)
    fprintf(1,'\tSegmenting Images\n')

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

        [imBW,bBri] = ProcessCzi.SegTexture_MSKCC(im(:,:,1,1,t));
 
        L1 = ProcessCzi.SplitLargeAreas(imBW);

        %imBW = bwareaopen(imBW,500);
        
       imBW = L1>0;

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

