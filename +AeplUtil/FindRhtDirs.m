
function rhtDirs = FindRhtDirs(path) 
    
    global CONST

    subDirs = AeplUtil.RecursDir(path);
    rhtDirs = [];
    for s = 1:length(subDirs) 
%                     disp(subDirs(s))

        if endsWith(subDirs(s).name, CONST.RHT_SUF)
            rhtDirs = [rhtDirs,subDirs(s)];
        end
    end
    

end

