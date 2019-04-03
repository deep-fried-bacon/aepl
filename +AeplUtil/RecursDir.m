

function dirList = RecursDir(path) 
    subDirs = dir(path);
    subDirs(~[subDirs.isdir]) = [];
    
    dirList = [];
    for s = 1:length(subDirs)
        if subDirs(s).name == '.' 
            continue
        end

        dirList = [dirList, subDirs(s), AeplUtil.RecursDir(fullfile(path,subDirs(s).name))];
    
    
    
    end
    
end

