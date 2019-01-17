%% RunProcessCzi  -  beta / almost stable
%     wrapper function that calls the heavy lifters for processing czi
%
%   Does not require plate map
%

function RunProcessCzi(experPath) 
    disp('Starting RunProcessCzi')

    %% Add MATLAB Utilities for BioFormats 
    addpath('./Utilities/src/MATLAB')
    if ~exist('experPath','var')
        experPath = uigetdir();
    end

    global CONST
    if isempty(CONST)
        initConstants
    end 
    %% Make tif dir and csv dir if they don't exist
    tifSaveDir = fullfile(experPath,CONST.ANNOTATED_TIF_DIR);
    if ~exist(tifSaveDir,'dir')
        mkdir(tifSaveDir)
    end

    csvSaveDir = fullfile(experPath,CONST.CSV_DIR);
    if ~exist(csvSaveDir,'dir')
        mkdir(csvSaveDir)
    end
    
    %% intialize exper
    exper = struct();
    exper.czi = dir(fullfile(experPath,['*',CONST.CZI_SUF]));
    %exper.frameCount = 0;
    
    for w = 1:length(exper.czi) 
        
        try 
            %% parse name
            wellFile = exper.czi(w).name;
            temp = strsplit(wellFile,'.');
            temp = strsplit(temp{1},'-');

            wellName = temp{end};

            
            %% initialize paths for saving well data
            wellTifSavePath = fullfile(tifSaveDir,strcat(wellName,'.tif'));
            
            % used when doing one frame and DrawTracks2
            % wellTifSavePath2 = fullfile(tifSaveDir,strcat(wellName,'_.tif'));

            wellCsvSavePath = fullfile(csvSaveDir,strcat(wellName,'.csv'));
            
            %% Process well czi
            %   only if a csv for that well doesn't already exist
            if ~exist(wellCsvSavePath,'file')
                disp(['Starting well ',wellName]);

                
                %% Open and load Image 
                tic
                [im,imd] =  MicroscopeData.Original.ReadData(experPath,wellFile);
                imdim = size(im);
                fprintf(1,'\t\t')
                toc
               
                
                
                %% The heavy lifting - segment (or process) the image (series)
                tic
                [cells] = ProcessCzi.SegIms(im);
                fprintf(1,'\t\t')
                toc

                %% from the raw data about every segmented cell from every frame,
                %   get tracks for each cell over all frames
                %       (I'm not sure if the matching up of cells from frame to
                %       frame happens in SegIms and is recorded or is actually
                %       done in GetTracks, I think the former because GetTracks
                %       doesn't take the image itself)
                
                tic
                [cells2,edges] = ProcessCzi.getTracks(cells,imdim);
                fprintf(1,'\t\t')
                toc

                
                %% Create the annotated tifs
                %   important for manual validation and checking
                %   takes about 20 sec per well
                %   wells take about 40 sec total 
                

                tic
                ProcessCzi.DrawTracks(squeeze(im),cells2,wellTifSavePath) 
                %ProcessCzi.DrawTracks2(squeeze(im),cells2,wellTifSavePath2);
                fprintf(1,'\t\t')
                toc
                
                %% Save (x, y) coords in csv
                %   I do this after DrawTracks because I use this as the
                %   test for whether or not a well has already been run,
                %   and DrawTracks is more likely to fail
                tic
                
                %ProcessCzi.ExportTrackStats(cells2,imdim,wellCsvSavePath)
                ProcessCzi.ExportTrackStatsSmall(cells2,imdim,wellCsvSavePath)
                fprintf(1,'\t\t')
                toc

            else
                disp(['Skipping well ', wellName, ', csv file already exists']);
            end
            
            
        catch e
            fprintf(2,wellName)
            fprintf(2," exception: " + getReport(e)+"\n")
            
            
            
            s = {{[experPath,':']}, join({wellName,'failed'}), join({'exception:', getReport(e)})};
            % sendmail('brown.amelia@gmail.com','Update from matlab: RunProcessCzi',[s{:}])
            fprintf(2, "should have email\n")
            fprintf(2, datestr(datetime('now')) + "\n")

        
        end
        
    end
    
    
    
    %sendmail('brown.amelia@gmail.com','Matlab Finished: RunProcessCzi')

    try 
        %[exper,condits] = ReadCsvAsCondits(experPath);


        SummarizeData.RunSummarizeData(experPath)
    catch
        
    end
    
    


end





