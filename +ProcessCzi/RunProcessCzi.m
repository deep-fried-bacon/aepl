%% ProcessCzi  -  beta
%     wrapper function that calls the heavy lifters for processing czi
%
%   Does not require plate map
%


function RunProcessCzi(experPath) 
    disp('Starting RunProcessCzi')

    %% Add MATLAB Utilities for BioFormats 
    addpath('./Utilities/src/MATLAB')


    global CONST
    
    tifSaveDir = fullfile(experPath,CONST.ANNOTATED_TIF_DIR);
    if ~exist(tifSaveDir,'dir')
        mkdir(tifSaveDir)
    end

    csvSaveDir = fullfile(experPath,CONST.CSV_DIR);
    if ~exist(csvSaveDir,'dir')
        mkdir(csvSaveDir)
    end
    
    


    exper = struct();
    exper.czi = dir(fullfile(experPath,['*',CONST.CZI_SUF]));
    %exper.frameCount = 0;
    for w = 1:length(exper.czi) 
        
        try 
            wellFile = exper.czi(w).name;
            temp = strsplit(wellFile,'.');
            %disp(class(temp(1)))
            temp = strsplit(temp{1},'-');

            wellName = temp{end};


            wellTifSavePath = fullfile(tifSaveDir,strcat(wellName,'.tif'));
            %wellTifSavePath2 = fullfile(tifSaveDir,strcat(wellName,'_.tif'));

            wellCsvSavePath = fullfile(csvSaveDir,strcat(wellName,'.csv'));
            
            if ~exist(wellCsvSavePath,'file')
                disp(['Starting well ',wellName]);


                tic
                [im,imd] =  MicroscopeData.Original.ReadData(experPath,wellFile);
                fprintf(1,'\t\t')
                toc
               
                imdim = size(im);
        %         if exper.frameCount == 0 
        %             exper.frameCount = imdim(5);
        %         end
                tic
                [cells] = ProcessCzi.SegIms(im);
                fprintf(1,'\t\t')
                toc

                tic
                [cells2,edges] = ProcessCzi.GetTracks(cells,imdim);
                fprintf(1,'\t\t')
                toc




                tic
                ProcessCzi.DrawTracks(squeeze(im),cells2,wellTifSavePath) 
                fprintf(1,'\t\t')
                toc
                %ProcessCzi.DrawTracks2(squeeze(im),cells2,wellTifSavePath2);

                tic
                ProcessCzi.ExportTrackStats(cells2,imdim,wellCsvSavePath)
                fprintf(1,'\t\t')
                toc

        %         allSegs = vertcat(cells2{:});
        %         allTracks = [allSegs.Tid];
        %         tracks = unique(allTracks);
        %         cellCount = size(tracks,2);
        %         disp("well.cellCount = " + cellCount)
        %         velocs = cell(exper.frameCount,size(tracks,2));

                %ShowPlot(well.cells2,well.name,well.condition,exper.figureHandles)
            else
                disp(['Skipping well ', wellName, ', csv file already exists']);
            end
            
            
        catch e
            fprintf(2,wellName)
            fprintf(2,"exception: " + getReport(e)+"\n")
        end
        
    end


end





