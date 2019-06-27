%%  SegIms  -  Epl
%       from Epl
%       little to no changes on my part
%
function [cellsOut] = SegIms(im,DrawPlot,videoHandle)
fprintf(1,'\tSegmenting Images\n')
%%

usePar = 1;


cells = cell(1,size(im,5));

%%
im1 = mat2gray(im);
imf = median(im1,5);
imf = imgaussfilt(imf,20);
im1 = im1 - imf;


imf = median(im1,5);
imD = imadjust(mat2gray(std(im1,[],5)));
im1 = im1 - (1-imD).*imf;
%%
%     im = permute(medfilt3(permute(im,[1 2 5 4 3]),[3,3,3]),[1 2 5 4 3]);
Fr = {};

%% Segment Cells in Parallel
if usePar && ~DrawPlot
    
    parfor t = 1:size(im,5)        % for frames     [x,y,c,s,t]?
        %for t = randi(size(im,5))
        
        I1 = im1(:,:,1,1,t);
        CC = ProcessCzi.SegTexture_MSKCC(I1,t,DrawPlot);
        cells{t} = CC;
    end
    
else
    %% Segment cells Normally
    for t = 1:size(im,5)        % for frames     [x,y,c,s,t]?
        %for t = randi(size(im,5))
        
        I1 = im1(:,:,1,1,t);
        CC = ProcessCzi.SegTexture_MSKCC(I1,t,DrawPlot);
        cells{t} = CC;
        
        
        drawnow
        F = getframe(gcf);
        F = F.cdata;
        %F = imresize(F,0.5);
        Fr{end+1} = F;
        
    end
end


cells = cells(~cellfun('isempty',cells));

cellsOut = vertcat(cells{:});

for i = 1:length(cellsOut)
    cellsOut(i).id = i;
    cellsOut(i).Tid = i;
end

if DrawPlot && exist('videoHandle','var') && ~isempty(videoHandle)
    for i = 1:length(Fr)
        writeVideo(videoHandle,Fr{i})
    end
end

end

