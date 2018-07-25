
%% two parts - gui and calling code 
%       calling code - calls the heavy-lifting code
% gui -> beta, close to stable
% calling code -> dev
%
    

function aeplUi2

%% callback functions

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
    end


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
    runButt = uicontrol('Style', 'pushbutton',...
                        'String', 'Run',...
                        'Position', [padding, fh - r*(lineH + padding), bw, lineH],...
                        'FontSize', 14,...
                        'Callback', @runButt_Callback);     

        end

end




