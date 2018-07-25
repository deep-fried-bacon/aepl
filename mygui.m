function mygui
handles.f = figure; %create figure
handles.edit = uicontrol('style','edit',...
   'callback',{@my_callback}); %create editbox
guidata(handles.f,handles) %save handles structure to figure
function my_callback(h,evt)
    disp(h)
    disp(evt)
end

end

