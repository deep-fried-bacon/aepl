function options = aeplUi
% bg = uibuttongroup('Visible','off',...
%                   'Position',[0 0 .2 1],...
%                   'SelectionChangedFcn',@bselection);
% bg = uibuttongroup('Visible','off',...
%                   'SelectionChangedFcn',@bselection);
w = 400;
h = 200;

bg = figure();
%disp(bg.Parent)
bg.Position(3) = w;
bg.Position(4) = h;


padding = 10;

rw = w-2*padding;
rh = 30;


%                   'Position',[w - (rw + padding), h - 2*(rh + 10), rw, rh],...

% Create three radio buttons in the button group.

opt1 = "Process Czi and create csv files (~0.5-2 hrs)";
opt2 = "Raw csv files to summary csv files";
opt3 = "Raw csv files to figures";

buttonText = 'Run';

r1 = uicontrol(bg,'Style',...
                  'checkbox',...
                  'String', opt1,...
                  'Position',[padding, h - (rh + 10), rw, rh],...
                  'FontSize', 14,...
                  'HandleVisibility','off');
              
r2 = uicontrol(bg,'Style','checkbox',...
                  'String',opt2,...
                  'Position',[padding, h - 2*(rh + 10), rw, rh],...
                  'FontSize', 14,...
                  'HandleVisibility','off');

r3 = uicontrol(bg,'Style','checkbox',...
                  'String', opt3,...
                  'Position',[padding, h - 3*(rh + 10), rw, rh],...
                  'FontSize', 14,...
                  'HandleVisibility','off',...
                  'Callback', @idk_cb);
              

% Create push button

bw = 100;
%hw = 300

btn = uicontrol('Style', 'pushbutton', 'String', buttonText,...
                    'Position', [w - (bw + 50), h - 4*(rh + 10), bw, rh],...
                    'FontSize', 14,...
                    'Callback', @pushbutton1_Callback);     
              
                
                % Create the function for the ValueChangedFcn callback:
%     function cBoxChanged(cbx,rb3)
%         val = cbx.Value;
%         disp('k')
%         if val
%             rb3.Enable = 'off';
%         else
%             rb3.Enable = 'on';
%         end
    function idk_cb(hObject,evendtdata,handles)
       disp(hObject)
       disp(hObject.Value)
       
       %disp(eventdata)
       %disp(handles)
        
    end
%     end
% Make the uibuttongroup visible after creating child objects. 
bg.Visible = 'on';

    function pushbutton1_Callback(hObject, eventdata, handles)
        % hObject    handle to pushbutton1 (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
%         disp(hObject)
        disp(r1)
        disp(r2)
        disp(r3)
    display('Goodbye');
        %close(gcf);
    end
        
    function bselection(source,event)
       display(['Previous: ' event.OldValue.String]);
       display(['Current: ' event.NewValue.String]);
       display('------------------');
    end
end