function aeplUi
global options
global path
w = 400;
h = 250;

bg = figure();
bg.Position(3) = w;
bg.Position(4) = h;


padding = 10;

rw = w-2*padding;
rh = 30;

opt1 = "Process Czi and create csv files (~0.5-2 hrs)";
opt2 = "Raw csv files to summary csv files";
opt3 = "Raw csv files to figures";

buttonText = 'Run';


r1 = uicontrol('Style',...
                  'checkbox',...
                  'String', opt1,...
                  'Position',[padding, h - 2*(rh + 10), rw, rh],...
                  'FontSize', 14,...
                  'HandleVisibility','off');
              
r2 = uicontrol('Style','checkbox',...
                  'String',opt2,...
                  'Position',[padding, h - 3*(rh + 10), rw, rh],...
                  'FontSize', 14,...
                  'HandleVisibility','off');

r3 = uicontrol('Style','checkbox',...
                  'String', opt3,...
                  'Position',[padding, h - 4*(rh + 10), rw, rh],...
                  'FontSize', 14,...
                  'HandleVisibility','off',...
              'Callback', @text_Callback);
              

bw = 100;

btn = uicontrol('Style', 'pushbutton', 'String', buttonText,...
                    'Position', [w - (bw + 50), h - 5*(rh + 10), bw, rh],...
                    'FontSize', 14,...
                    'Callback', @pushbutton1_Callback);     

btn = uicontrol('Style', 'pushbutton', 'String', "path",...
                    'Position', [10, h - (rh + 10), bw, rh],...
                    'FontSize', 14,...
                    'Callback', @text_Callback); 
                
text = uicontrol('Style', 'edit', 'String', '',...
    'Position', [120, h - (rh + 10), rw, rh],...
    'FontSize', 14,...
    'ButtonDownFcn', @text_Callback);     

    function text_Callback(hObject,eventdata, handles) 
       
    end

              
                

% Make the uibuttongroup visible after creating child objects. 
bg.Visible = 'on';

    function pushbutton1_Callback(hObject, eventdata, handles)
        % hObject    handle to pushbutton1 (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
%         disp(hObject)
         
        %disp(r1)
        %disp(r2)
        %disp(r3)
        %display('Goodbye');
        %disp(handles).
        %disp(hObject.Parent)
        hObject.Parent.UserData = [r1.Value r2.Value r3.Value];
        %options = [r1.Value r2.Value r3.Value];
        %options = btn.UserData;

        %get(hObject)
        

        hide(gcf);
    end
%uiwait()
%options = bg.UserData;
%close(gcf)
end




