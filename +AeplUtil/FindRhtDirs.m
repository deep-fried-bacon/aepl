
function rhtDirs = FindRhtDirs(path) 
    
    global CONST

    subDirs = AeplUtil.RecursDir(path);
    rhtDirs = [];
    for s = 1:length(subDirs) 

        if endsWith(subDirs(s).name, CONST.RHT_SUF)
            rhtDirs = [rhtDirs,subDirs(s)];
           
        end
    end
    
    for r = 1:length(rhtDirs) 
        rhtDirs(r).fullPath = fullfile(rhtDirs(r).folder,rhtDirs(r).name);
        rhtDirs(r).relPath = rhtDirs(r).fullPath(length(path)+2:end-length(CONST.RHT_SUF));      % +2 to skip first /, -4 to remove .rht
        rhtDirs(r).experName = strrep(rhtDirs(r).relPath,'/','_');
    end
    

end

