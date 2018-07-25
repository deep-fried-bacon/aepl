
%% RunAepl  -  beta | dev
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
% options code - sets path and which functions to run,
%     consists of a gui or hard coded for development
% gui -> beta, close to stable
% calling code -> dev
%
    

function RunAepl
%% options code
    dev = true;
    
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
    
    if ~dev

    %% gui
    
        


    %% define some constants for layout

        fw = 500;       % figure width
        fh = 250;       % figure height

        lineH = 30;     % line height

        padding = 10;

        bw = 100;       % button width

    %% make figure

        set(0,'DefaultFigureWindowStyle','docked')
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
        
        options.experPath = '';
        
        options.procCzi = 0;
        options.summar = 0;
        options.makePlots = 0;
        
        
    end
    
%% end of options code
%% calling code

    if options.procCzi 
        MakeData.ProcessCzi.Run(options.experPath)
    end
    if options.summar
        ReadData.SummarizeData.Run(options.experPath)
    end
    if options.makePlots
        ReadData.MakePlots.Run(options.experPath)
    end
                    
                    
end






