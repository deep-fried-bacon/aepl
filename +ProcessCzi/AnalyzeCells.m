function [cellsOut] = AnalyzeCells(cells)

TIDs = [cells.Tid];
CIDs = [cells.id];

for tid = 2:max(TIDs)
    
  C = cells(TIDs==tid);  
  mitScore = [C.MitoScore];
  mitScore = medfilt1(mitScore,3);
  bMitotic = mitScore>0.07;

  %% Got Some Signal 
if nnz(bMitotic)>3
    
   %TrkPrps = regionprops(bMitotic,'area');
    
   locs = vertcat(C.Centroid);
   dist = sum(abs(diff(locs)),2);
   
   isDead = 0; 
   
   n1 = max(length(bMitotic)-20,1);
   
   if nnz(bMitotic(n1:end)) > 15; isDead = 1; end 
   if nnz(bMitotic) > 20; isDead = 2; end 
   if mean(dist(n1:end)) < 10; isDead = isDead+1; end 
   
   if isDead > 1
       
      ids = [C(bMitotic).id];
      for i = ids
      cells(CIDs==i).Label = 2;
      end 
   else 
      ids = [C(bMitotic).id];
      for i = ids   
      cells(CIDs==i).Label = 1;
      end 
      
   end 

end  

end
cellsOut = cells;
end 


