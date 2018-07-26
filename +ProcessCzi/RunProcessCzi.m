%% ProcessCzi  -  alpha
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

            wellName = temp{end}


            wellTifSavePath = fullfile(tifSaveDir,strcat(wellName,'_.tif'));
            wellCsvSavePath = fullfile(csvSaveDir,strcat(wellName,'.csv'));
            
            if ~exist(wellCsvSavePath,'file')



                [im,imd] =  MicroscopeData.Original.ReadData(experPath,wellFile);

                imdim = size(im);
        %         if exper.frameCount == 0 
        %             exper.frameCount = imdim(5);
        %         end

                [cells] = ProcessCzi.SegIms(im);


                [cells2,edges] = ProcessCzi.GetTracks(cells,imdim);





                ProcessCzi.DrawTracks(squeeze(im),cells2,wellTifSavePath);

                ProcessCzi.ExportTrackStats(cells2,imdim,wellCsvSavePath)

        %         allSegs = vertcat(cells2{:});
        %         allTracks = [allSegs.Tid];
        %         tracks = unique(allTracks);
        %         cellCount = size(tracks,2);
        %         disp("well.cellCount = " + cellCount)
        %         velocs = cell(exper.frameCount,size(tracks,2));

                %ShowPlot(well.cells2,well.name,well.condition,exper.figureHandles)
            
            end
            
            
        catch e
            fprintf(2,wellName)
            fprintf(2,"exception: " + getReport(e)+"\n")
        end
        
    end


end





