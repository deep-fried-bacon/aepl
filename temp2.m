

root = strcat('/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdo Project/',... 
    'Tissue Culture/Timelapse/Rhabdomyosarcoma plate movies/',...
    'Post-mycoplasma data (starting 9:18:18)');

if exist('rhtDirs','var') == 0 
    rhtDirs = AeplUtil.FindRhtDirs(root);
end

global CONST
if isempty(CONST)
    InitConstants
end
% disp(CONST)

if false 
    for r = 1:length(rhtDirs)
        fprintf('%d. %s\n',r,rhtDirs(r).experName)
    end
end

whichExper = 4;
disp(rhtDirs(whichExper).experName)
ProcessCzi.RunProcessCzi(rhtDirs(whichExper).fullPath)

