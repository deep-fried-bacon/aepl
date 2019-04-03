 root = strcat('/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdo Project/',... 
    'Tissue Culture/Timelapse/Rhabdomyosarcoma plate movies/',...
    'Post-mycoplasma data (starting 9:18:18)'); 


% addpath('.')
% butts = recurs_dir(root);
% (butts{:})
% disp(recurs_dir(root))

tic
contents = recurs_dir(root);

toc
contents(:).name
toc


