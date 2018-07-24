function myui2
bg = uibuttongroup('Visible','off',...
                  'Position',[0 0 .2 1],...
                  'SelectionChangedFcn',@bselection);
              
% Create three radio buttons in the button group.
r1 = uicontrol(bg,'Style',...
                  'checkbox',...
                  'String','Option 1',...
                  'Position',[10 350 100 30],...
                  'HandleVisibility','off');
              
r2 = uicontrol(bg,'Style','checkbox',...
                  'String','Option 2',...
                  'Position',[10 250 100 30],...
                  'HandleVisibility','off');

r3 = uicontrol(bg,'Style','checkbox',...
                  'String','Option 3',...
                  'Position',[10 150 100 30],...
                  'HandleVisibility','off',...
                  'Callback', @idk_cb);
              

% Create push button
btn = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
                    'Position', [20 20 50 20],...
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