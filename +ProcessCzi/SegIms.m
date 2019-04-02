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

        %imBW = bwareaopen(imBW,500);

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
LMat = zeros(size(imBW,1),size(imBW,2),size(imBW,3));
Lmax = 1;

for i = 1:max(L(:))
    k =  round((CellFeats(i).Area/MeanArea));
    if k < 2
        L2(CellFeats(i).PixelIdxList)=Lmax ;
        LMat = LMat + bwperim(L2==Lmax);
        Lmax = Lmax + 1;
    else
        
        idxlist = CellFeats(i).PixelIdxList;

        
        temp = false(size(imBW,1),size(imBW,2),size(imBW,3));
        temp(idxlist) = 1;
        T1 = temp;
        
        N = 5;
        temp = imerode(temp,ones([N,N,1]));
        
        N = 10;
        [r,c] = find(temp);
        xyList = [r,c];
        xyList = xyList(1:N:end,:);
        
        %%
        try
            T = kmeans(xyList,k);
        catch e
            fprintf(2,'kmeans error, I dont know whats causing it')
            fprintf(2,"exception: " + getReport(e)+"\n")
        end
        
        Tcent = zeros(max(T(:)),2);
       
        %%
        for j = 1:max(T(:))
        Tcent(j,1) = mean(xyList(T==j,1));
        Tcent(j,2) = mean(xyList(T==j,2));
        end 
        
        
        D = bwdistgeodesic(T1, round(Tcent(:,2)), round(Tcent(:,1)));
        D(~T1) = Inf;
        L3 = watershed(D,4);
        L3(~T1) = 0;
        
        %[~,I] = pdist2(Tcent(:,[2,1]),CellFeats(i).PixelList,'euclidean','Smallest',1);
        
        for j = 1:max(L3(:))
            
            L2(L3==j)=Lmax ;
            LMat = LMat + imdilate(bwperim(L2==Lmax),ones(3,3,1));
            Lmax = Lmax + 1;
        end
        
        %%
%         imagesc(L2);
%         hold on 
%         plot(Tcent(:,2),Tcent(:,1),'ko')
        
        
    end
end

%% Seperate Touching Objects
Boundry = imdilate(LMat>1,ones([3,3,1]));
L2(Boundry) = false;
end 