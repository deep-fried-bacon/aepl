%% GetTracks  - Epl
%   frpm epl
%   little to no changes
%


function [Segs,Edges] = getTracks(Segs,dims)
fprintf(1,'\tGetting Tracks from segmentation\n')

Edges = cell(1,length(Segs));

Tracks = [];
for t = 1:length(Segs)
    newTracks =  [[Segs{t}.id];[Segs{t}.time]]';
    Tracks = [Tracks;newTracks];
end

TimeWindow = 10;

for t = 1:length(Segs)-1
    TakenA = 0;
    TakenB = 0;
    
    T0 = Segs{t};
    Trange = t+1:min(  t+TimeWindow , length(Segs));
    
    T1 = vertcat(Segs{Trange});
    
    Edges{t} = MakeEdgeT(T0,T1,Tracks,dims,100);
end

EdgesT = vertcat(Edges{:});
[~,idx] = sort(EdgesT(:,3),1);
SortT = EdgesT(idx,:);

SegVect  = vertcat(Segs{:});
TrackVect = [SegVect.id;SegVect.Tid]';
%% Assign Tracks


for ii = 1:size(SortT,1)
    
    id0 = SortT(ii,1);
    id1 = SortT(ii,2);
    
    if id0 == 0; continue; end
    
    if any(TakenA==id0) || any(TakenB==id1)
        continue
    end
    
    if id1 < 0 || id0 < 0
        continue
    end
    
    TakenA = [TakenA,id0];
    TakenB = [TakenB,id1];
    
    TrkA = TrackVect(TrackVect(:,1)==id0,2);
    TrkB = TrackVect(TrackVect(:,1)==id1,2);
    
    TrackVect(TrackVect(:,2)==TrkB,2) = TrkA;

end

for i = 1:length(Segs)
    S = Segs{i};
    for ii = 1:length(S)
        sid = S(ii).id;
        Tid = TrackVect(TrackVect(:,1)==sid,2);
        S(ii).Tid = Tid;
    end 
    Segs{i}=S;
end 

end
%%

function EdgeList = MakeEdgeT(T0,T1,Tracks,dims,maxDist)

EdgeList = [0,0,0];
idx = 1;
for i = 1:length(T0)
    
    if any(EdgeList(:,1) == T0(i).id)
        continue
    end
    C1 = T0(i);
    
    StartTime = Tracks(Tracks(:,1)==C1.Tid,2);
    for j = 1:length(T1)
        
        C2 = T1(j);
        
        dist =  sqrt(sum((C1.Centroid-C2.Centroid).^2,2));
        
        if dist>maxDist
            continue;
        end
        
        dist = dist/maxDist;
        deltaT = abs(C1.time - C2.time);
        dist = dist + StartTime*deltaT;
        %% Add Match to List
        EdgeList(idx,:) = [C1.id,C2.id,dist];
        idx = idx+1;
    end
    
end

%% Calculate Escape Costs;

% for i = 1:length(T0)
%  C1 = T0(i);
%  dist1 = 2*C1.Centroid;
%  dist2 = 2*dims(1:2) - C1.Centroid;
%  dist = min([dist1,dist2]);
%  if dist > maxDist; continue; end
%  dist = dist/maxDist;
%  EdgeList(idx,:) = [C1.id,-1,dist];
%  idx = idx+1;
%
% end
%
% for i = 1:length(T1)
%  C2 = T1(i);
%  dist1 = 2*C2.Centroid;
%  dist2 = 2*dims(1:2) - C2.Centroid;
%  dist = min([dist1,dist2]);
%  if dist > maxDist; continue; end
%  dist = dist/maxDist;
%  EdgeList(idx,:) = [-1,C2.id,dist];
%  idx = idx+1;
% end

end

