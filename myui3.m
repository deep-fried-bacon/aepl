function myui3
    % Create a UI figure window:
    %fig = uifigure('Position',[100 100 229 276]);

    % Create a button group and radio buttons:
    bg = uibuttongroup('Position',[56 77 123 85]);
    rb1 = uiradiobutton(bg,'Position',[10 60 91 15]);
    rb2 = uiradiobutton(bg,'Position',[10 38 91 15]);
    rb3 = uiradiobutton(bg,'Position',[10 16 91 15]);

    % Create a check box:
    cbx = uicheckbox(fig,'Position',[55 217 102 15],...
        'ValueChangedFcn',@(cbx,event) cBoxChanged(cbx,rb3));
    end

    % Create the function for the ValueChangedFcn callback:
    function cBoxChanged(cbx,rb3)
    val = cbx.Value;
    if val
        rb3.Enable = 'off';
    else
        rb3.Enable = 'on';
    end
end