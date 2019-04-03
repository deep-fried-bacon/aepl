root = strcat('/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdo Project/',... 
    'Tissue Culture/Timelapse/Rhabdomyosarcoma plate movies/',...
    'Post-mycoplasma data (starting 9:18:18)');
rootLen = length(root);

rhtDirs = AeplUtil.FindRhtDirs(root);

for r = 1:length(rhtDirs) 
    fullPath = fullfile(rhtDirs(r).folder,rhtDirs(r).name);
    relPath = fullPath(rootLen+2:end-4);      % +2 to skip first /, -4 to remove .rht
%     disp(rhtDirs(r).name)
disp(strrep(relPath,'/','_'))
end