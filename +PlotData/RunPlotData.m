%% PlotData  -  alpha
%   wrapper function for calling the heavy-lifters that make plots
%
%   assumes plate map has groups
%


function RunPlotData(experPath)
    global CONST
    
%     csvDir = fullfile(experPath, CONST.CSV_DIR);
%     
%     %exper = struct();
%     %exper.
%     plateMapFile = AeplUitl.FindFile(experPath,CONST.PLATE_MAP_SUF);
%     
%     % could all be done in one line but it was really long
%         temp = ReadPlateMap(plateMapFile);
%         exper.conditions = tem(1);
%         exper.conditWellMap = temp(2);
%         exper.groupWellMap = temp(3);
    %
    [exper,condits] = ReadCsvAsCondits(experPath);
    

    %function [exper,condits2] = plotCondits(exper,condits)
    %SUB_DIR = 'pdfPlots';
    %PLOT_SUF = '-plot.pdf';

    procDir = fullfile(experPath, CONST.PROCESSED_DIR);
    if ~exist(procDir,'dir')
        mkdir(procDir)
    end    

    exper.t_int = (1/6):(1/6):(exper.frames+10/6);

    exper.ylimit = 20;
    
    groups = exper.groupWellMap.keys()
   
    condits2(length(condits)) = struct('name','','wells',[],'mat',[]);

    for group = groups
        gCondits = exper.groupWellMap(group{1});
        plotCount = length(gCondits);
        %laeout = makeLaeout(plotCount);
        laeout = AeplUtil.MakeLaeout(plotCount);
        
        figure
        plotNum = 1;
        for conditNamee = gCondits
            conditName = conditNamee{1};
            cond = exper.conditIndexMap(conditName);
%              try
               %temp  = makeConditMat(condits(cond));
               temp = AeplUtil.MakeConditMat(condits(cond));
               condits2(cond)= temp;
%             catch e
%                 disp(conditName)
%                 disp(e.getReport)
%             end
            subplot(laeout(1),laeout(2), plotNum)
            title(conditName)
            
            %plottyPlot(condits2(cond).mat,exper);
            PlotData.MakeConditSubplot(condits2(cond).mat,exper)
            plotNum = plotNum + 1;
        end
        h = gcf;
%         set(h, 'PaperUnits','inches','PaperPosition',[0 0 11 8.5],'PaperOrientation','landscape')
%         
%         
%         fname = [exper.name,'_',group{1},PLOT_SUF];
%         
        fname = [group{1},CONST.PLOT_SUF];
        
        print(h,fullfile(procDir,fname),'-dpdf')
%         close(h)
    end
    %condits = condits2;
end
    
