%% DrawTracks  -  beta
%   from Epl
%   I've made a fair amount of changes
%

function DrawTracks(im,Segs,fName)
fprintf(1,'\tDrawing tracks and saving to tif\n')
fprintf(1,'\t\tframe 1')

firstRound = 1;

cmap = colormap('jet');
cmap = cmap(randperm(size(cmap,1)),:);

saveframe  = 1;

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

    Tsegs = Segs([Segs.time]==i);
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
        
        if Tsegs(ii).Label==1
            viscircles([cent(1),cent(2)],20,'Color','g');
        elseif Tsegs(ii).Label==2
            viscircles([cent(1),cent(2)],20,'Color','r');
        end 
    end
    %hold off
    drawnow
    
    
    if saveframe
        tempGca = getframe(h);
        if firstRound == 1
            imwrite(tempGca.cdata,fName,'WriteMode','overwrite')
            firstRound = 0;
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
