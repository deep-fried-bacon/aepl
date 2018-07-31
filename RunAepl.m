 
%% RunAepl  -  beta 
% two parts - options code and calling code
%     options code   (beta)
%         get path and options from user
%         fields of struct options
%         experPath - file path of experiment files
%         procCzi - run ProcessCzi (bool)
%         summar - run SummarizeData (bool)
%         makePlots - run MakePlots (bool)
%         
%         based on boolean dev,
%         either runs a gui to get options from the user
%         or uses options hard coded in
%     
%     calling code    (dev)
%         based on options calls the appropriate functions
% 
% calling code - calls the heavy-lifting code
% options code - sets path and 2which functions to run,
%     consists of a gui or hard coded for development
% gui -> beta, close to stable
% calling code -> dev
%
    

function RunAepl
%% options code
    global CONST
    CONST = struct();
    
    CONST.PLATE_MAP_SUF = '_plate-map.csv';
    CONST.CZI_SUF = '.czi';
    CONST.CONDIT_DATA_SUF = '-veloc-conditions.csv';
    CONST.WELL_DATA_SUF = '-veloc-wells.csv';
    CONST.PLOT_SUF = '-veloc-plot.pdf';
   
    CONST.AVG_PREF = 'Avg';
    CONST.MEDI_PREF = 'Median';

    
    CONST.CZI_DIR = '';
    CONST.CSV_DIR = 'Csv';
    CONST.PROCESSED_DIR = 'ProcessedData';
    CONST.ANNOTATED_TIF_DIR = 'TifsWithTracks';
    
    %CONST.COL_LAYOUT_VER = '4 cols';
    CONST.COL_LAYOUT_VER = '5 cols';
    %CONST.COL_LAYOUT = AeplUtil.GetColLayout(CONST.COL_LAYOUT_VER);
    
    
    
    %% callback functions for gui

    function dirDialog_Callback(hObject,eventdata, handles) 
        pathBox.String = uigetdir();
    end

    function runButt_Callback(hObject,eventdata, handles) 
        temp = struct();
        temp.experPath = pathBox.String;
        temp.procCzi = procCzi.Value;
        temp.summar = summar.Value;
        temp.makePlots = makePlots.Value;

        guidata(f,temp)
        uiresume()
    end
    
    dev = true;

    if ~dev

    %% gui
    
        


    %% define some constants for layout

        fw = 500;       % figure width
        fh = 250;       % figure height

        lineH = 30;     % line height

        padding = 10;

        bw = 100;       % button width

    %% make figure

        %set(0,'DefaultFigureWindowStyle','docked')
        f = figure();


    %% make each uicontrol
    %   path button + path text edit box
    %   3 checkboxes
    %   run button
    %
    %   r is incremented with each line
    %   and used to set the vertical layout so everything is spaced equally

        r=1;
        pathButt = uicontrol(...
            'Style', 'pushbutton',...
            'String', 'Path :',...
            'Position',[padding, fh-r*(lineH + padding), bw, lineH],...
            'FontSize', 14,...  
            'Callback', @dirDialog_Callback...
        );


        pathBox = uicontrol(...
            'Style', 'edit',...
            'String', 'enter path here',...
            'Position', [padding + bw, fh - r*(lineH + padding), fw-2*(padding) - bw, lineH],...
            'FontSize', 14 ... 
        );

        r = r + 1;
        procCzi = uicontrol(...
            'Style','checkbox',...
            'String','Process czi',...
            'Position',[padding, fh - r*(lineH + padding), fw-2*(padding), lineH],...
            'FontSize',14,...
            'HandleVisibility','off'...
        );

        r = r + 1;
        summar = uicontrol(...
            'Style','checkbox',...
            'String','Make summary csv files',...
            'Position',[padding, fh - r*(lineH + padding), fw-2*(padding), lineH],...
            'FontSize',14,...
            'HandleVisibility','off'...
        );

        r = r + 1;
        makePlots = uicontrol(...
            'Style','checkbox',...
            'String','create plots',...
            'Position',[padding, fh - r*(lineH + padding), fw-2*(padding), lineH],...
            'FontSize',14,...
            'HandleVisibility','off'...
        );


        r = r + 1;
        runButt = uicontrol(...
            'Style', 'pushbutton',...
            'String', 'Run',...
            'Position', [padding, fh - r*(lineH + padding), bw, lineH],...
            'FontSize', 14,...
            'Callback', @runButt_Callback...
        );     

        %% end of gui
        uiwait()
        
        options = guidata(f);
    
    else
        options = struct();
        
        f17_06_28 = '/Volumes/baylieslab-1/Current Lab Members/Whitney/Rhabdomyosarcoma plate movies/17-06-28 final pi3k inhibitors/';
        f17_07_13 = '/Volumes/baylieslab-1/Current Lab Members/Whitney/Rhabdomyosarcoma plate movies/17-07-13 and 20170629 first plate fda screen/7.13.17 Part b/Whitney2/';
        f18_06_20 = '/Volumes/baylieslab-1/Current Lab Members/Whitney/Rhabdomyosarcoma plate movies/18-06-20/';
        f18_03_18 = '/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdomyosarcoma plate movies/2018-3-18';
        
        options.experPath =  f18_03_18;
        
        
        options.procCzi = 0;
        options.summar = 0;
        options.makePlots = 1;
        
        
    end
    
%% end of options code
%% calling code

    if options.procCzi 
        ProcessCzi.RunProcessCzi(options.experPath)
    end
    if options.summar
        SummarizeData.RunSummarizeData(options.experPath)
    end
    if options.makePlots
        PlotData.RunPlotData(options.experPath)
    end
                    
                    
end






