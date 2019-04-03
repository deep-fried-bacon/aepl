

function dirList = RecursDir(path) 
    subdirs = dir(path);
    subdirs(~[subdirs.isdir]) = [];
    
    dirList = [];
    for s = 1:length(subdirs)
        if subdirs(s).name == '.' 
            continue
        end

        dirList = [dirList, subdirs(s), RecursDir(fullfile(path,subdirs(s).name))];
    
    
    
    end
    
end

