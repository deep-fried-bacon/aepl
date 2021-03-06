

function verInfo = MakeVersion(productName, forceVersion, dependencyPaths)

    %% Template for the Dev.VersionInfo command
    funcString = {
        '%% versionInfo = VersionInfo()'
        '%% Return the version info structure'
        '%%'
        '%% Note: This file is autogenerated by build script DO NOT MODIFY!!'
        ''
        'function versionInfo = VersionInfo()'
        '    jsonVer = ''%s'';'
        '    '
        '    versionInfo = Utils.ParseJSON(jsonVer);'
        'end'};
    
    if ( ~exist('forceVersion', 'var') )
        forceVersion = '';
    end
    
    if ( ~exist('dependencyPaths', 'var') )
        dependencyPaths = {};
    end
    
    fallbackFile = 'version.json';
    
    %% Load version info from git tags
    verInfo = Dev.LoadVersion();
    if ( isempty(verInfo) )
        error('Unable to load git version information');
    end
    
    % Force name to be the passed in product name
    verInfo.name = productName;
    
    %% If we are forcing a specific version number
    if ( ~isempty(forceVersion) )
        verString = ['v' forceVersion];
        
        [majorVer,minorVer] = Dev.ParseVerTag(verString);
        if ( isempty(majorVer) )
            error('Invalid version string %s', verString);
        end
        
        verInfo.majorVersion = majorVer;
        verInfo.minorVersion = minorVer;
    end
    
    %% Get a timestamp build-number
    c = clock();
    verInfo.buildNumber = sprintf('%d.%02d.%02d.%02d', c(1), c(2), c(3), c(4));
    
    %% Get machine ID
    [status,buildMachine] = system('hostname');
    if ( status ~= 0 )
        fprintf('WARNING: There was an error retrieving hostname:\n %s\n', buildMachine);
    else
        verInfo.buildMachine = strtrim(buildMachine);
    end
    
    %% Make sure local path is not in the list
    localPath = pwd();
    bHasLocal = strcmp(localPath,dependencyPaths);
    dependencyPaths = dependencyPaths(~bHasLocal);
    
    %% Add all other dependent commit hashes to list
    hashStrings = cell(length(dependencyPaths),1);
    for i=1:length(dependencyPaths)
        [repoName,commitHash] = Dev.GetCommitInfo(dependencyPaths{i});
        hashStrings{i} = [repoName ' : ' commitHash];
    end
    
    verInfo.commitHash = [verInfo.commitHash; hashStrings];
    
    %% Create +Dev/VersionInfo.m for use in compiled files
    % Concatenate the template function lines into one giant string
    templateString = [];
    for i=1:length(funcString)
        templateString = [templateString funcString{i} '\n'];
    end

    % Now insert all our arguments into the template and write to a file.
    if ( ~exist('+Dev','dir') )
        mkdir('+Dev');
    end
    
    fid = fopen(fullfile('+Dev','VersionInfo.m'), 'wt');
    if ( fid <= 0 )
        error('Unable to open +Dev/VersionInfo.m for writing');
    end

    jsonVer = Utils.CreateJSON(verInfo,false);
    fprintf(fid, templateString, jsonVer);

    fclose(fid);

    %% Update fallback file if we used git to retrieve version info.
    jsonStr = Utils.CreateJSON(verInfo);
    fid = fopen(fallbackFile, 'wt');
    if ( fid <= 0 )
        return;
    end

    fprintf(fid, '%s\n', jsonStr);
    fclose(fid);
end
