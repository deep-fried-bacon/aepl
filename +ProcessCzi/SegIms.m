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

        imBW = SplitLargeAreas(imBW);

        [B] = bwboundaries(imBW,'noholes');

        CC = regionprops(imBW,double(bBri),'centroid','area','PixelList','MeanIntensity');
        for ii = 1:length(CC)
            CC(ii).id = UID;
            CC(ii).Tid = UID;
            CC(ii).time = t;
            CC(ii).Bound = B{ii};
            CC(ii).MitoScore = CC(ii).MeanIntensity;
            CC(ii).Label = 0;
            UID = UID +1;
        end
       CC = rmfield(CC,'MeanIntensity');
        cells{t} = CC;
    end 
    
    cellsOut = vertcat(cells{:});
end 



%% 
function imBWout = SplitLargeAreas(imBW)

    imBWout = imBW;

    tooLarge = bwareaopen(imBW, 6000);
    imBWout(tooLarge) = false;

    L = SeparateObjects(tooLarge,3500);

    imBWout(L>0) = true;
end

function L2 = SeparateObjects(imBW,MeanArea)


L = bwlabel(imBW);
L2 = zeros(size(L));
if nnz(imBW)==0
    return 
end 
CellFeats = regionprops(imBW,'Area','PixelList','PixelIdxList');
LMat = false(size(imBW,1),size(imBW,2),size(imBW,3),3*length(CellFeats));
Lmax = 1;
for i = 1:max(L(:))
    k =  round((CellFeats(i).Area/MeanArea));
    if k < 2
        L2(CellFeats(i).PixelIdxList)=Lmax ;
        LMat(:,:,:,Lmax) = L2==Lmax;
        Lmax = Lmax + 1;
    else
        try
            T = kmeans(CellFeats(i).PixelList,k);
        catch e
            fprintf(2,'kmeans error, I dont know whats causing it')
            fprintf(2,"exception: " + getReport(e)+"\n")
        end
        for j = 1:max(T(:))
            L2(CellFeats(i).PixelIdxList(T==j))=Lmax ;
            LMat(:,:,:,Lmax) = L2==Lmax;
            Lmax = Lmax + 1;
        end
    end
end

%% Seperate Touching Objects
LMat = imdilate(LMat,ones([3,3,1,1]));

Boundry = sum(LMat,4)>1;
L2(Boundry) = false;
end 