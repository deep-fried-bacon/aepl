%% ProcessCzi  -  dev
%     wrapper function that calls the heavy lifters for processing czi


function RunProcessCzi(experPath) 
    %PLATE_MAP_SUF = '_plate-map.csv';
    %CZI_SUF = '.czi';
    disp('Starting RunProcessCzi')

    %% Add MATLAB Utilities for BioFormats 
    addpath('./Utilities/src/MATLAB')
        %addpath('./+ProcessCzi')


    global CONST

    %addpath('../aeplClasses')


    %% Directory 
   %curDir = pwd;
    %guiGetDir = @uigetdir;

    %f18_03_18 = '/Users/baylieslab/Documents/Amelia/rmsMim/18-03-18/';
    %f18_06_20 = '/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdomyosarcoma plate movies/18-06-20/';


    %f16_06_23 = '/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdomyosarcoma plate movies/16-06-23 (1st plate)/16-06-23/';

    exper = struct();
    %exper.folder = f16_06_23;

    %exper.folder = guiGetDir('/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdomyosarcoma plate movies/');

    %%
    %tic

    %[~,exper.name] = fileparts(exper.folder(1:end-1));


    %exper.plateMapFile = fullfile(exper.folder,[exper.name,PLATE_MAP_SUF]);

    %[exper.conditions,exper.conditDict] = MakeConditDict(exper.plateMapFile);


    exper.czi = dir(fullfile(experPath,['*',CONST.CZI_SUF]));
    %disp(exper.czi)
    %temp =dir(experPath);
    %disp(temp(100))
    exper.frameCount = 0;
    for w = 1:length(exper.czi) 
        wellFile = exper.czi(w).name;
        temp = strsplit(wellFile,'.');
        %disp(class(temp(1)))
        temp = strsplit(temp{1},'-');
       
        wellName = temp{end}
        
        [im,imd] =  MicroscopeData.Original.ReadData(experPath,wellFile);

        imdim = size(im);
        if exper.frameCount == 0 
            exper.frameCount = imdim(5);
        end

        [cells] = ProcessCzi.SegIms(im);


        [cells2,edges] = ProcessCzi.GetTracks(cells,imdim);


        %[P,F,~] = fileparts(Name);
        tifSaveDir = fullfile(experPath,CONST.ANNOTATED_TIF_DIR);
        if ~exist(tifSaveDir,'dir')
            mkdir(tifSaveDir)
        end
        
        csvSaveDir = fullfile(experPath,CONST.CSV_DIR);
        if ~exist(csvSaveDir,'dir')
            mkdir(csvSaveDir)
        end
        
        %XlsName = fullfile(P2,[F,'.csv']);
        wellTifSavePath = fullfile(tifSaveDir,strcat(wellName,'.tif'));
        ProcessCzi.DrawTracks(squeeze(im),cells2,wellTifSavePath);
        
        wellCsvSavePath = fullfile(csvSaveDir,strcat(wellName,'.csv'));
        ProcessCzi.ExportTrackStats(cells2,imdim,wellCsvSavePath)

%         allSegs = vertcat(cells2{:});
%         allTracks = [allSegs.Tid];
%         tracks = unique(allTracks);
%         cellCount = size(tracks,2);
%         disp("well.cellCount = " + cellCount)
%         velocs = cell(exper.frameCount,size(tracks,2));

        %ShowPlot(well.cells2,well.name,well.condition,exper.figureHandles)


    end


end





