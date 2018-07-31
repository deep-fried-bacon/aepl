%% DrawTracks  -  beta
%   from Epl
%   I've made a fair amount of changes
%

function DrawTracks(im,Segs,fName)
fprintf(1,'\tDrawing tracks and saving to tif\n')
fprintf(1,'\t\tframe 1')

firstRound = 0;

cmap = colormap('jet');
cmap = cmap(randperm(size(cmap,1)),:);

saveframe  = 1;
AllSegs = vertcat(Segs{:});

% AllTracks = [AllSegs.Tid];
% Tracks = unique(AllTracks);
% counts = hist(AllTracks,Tracks);

% Fr = cell(1,size(im,3));
%h = figure('Visible', 'off');
h = figure();
for i = 1:size(im,3)
    clf(h,'reset')
    %set(h, 'Visible', 'off')
    %h = figure('Visible', 'off');
    %h = figure();

    Tsegs = AllSegs([AllSegs.time]==i);
    % put break on next line to step through outlined cells
    TTracks = [Tsegs.Tid];
    
    imagesc(im(:,:,i))
    colormap gray
    Axis = gca;
    Axis.Position = [0 ,0, 1, 1];
    axis equal
    axis off
    hold on
    for ii = 1:length(TTracks)
        
        pts = vertcat(Tsegs(ii).Bound);
        cid = mod(TTracks(ii),64)+1;
        plot(pts(:,2),pts(:,1),'-','Color',cmap(cid,:))
        cent = Tsegs(ii).Centroid;
        text(cent(1),cent(2),num2str(Tsegs(ii).Tid),'Color',cmap(cid,:),'FontSize',10)
        
    end
    %hold off
    drawnow
    
    
    if saveframe
        tempGca = getframe(h);
        if firstRound == 0
            imwrite(tempGca.cdata,fName)
            firstRound = 1;
        else
            imwrite(tempGca.cdata,fName,'WriteMode','append') 
        end
    end
    for j = 1:log10(i) + 1
        fprintf(1,'\b')
    end
    fprintf(1,num2str(i+1))

    %close(h)
end
fprintf(1,'\n')
close(h)

end
