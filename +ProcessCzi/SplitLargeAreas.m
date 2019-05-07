%% 
function imBWout = SplitLargeAreas(imBW)

    AreaT = round(numel(imBW)*0.003);
    AreaT2 = round(numel(imBW)*0.002);

    imBWout = uint8(imBW);
    tooLarge = bwareaopen(imBW, AreaT);
    imBWout(tooLarge) = 0;
    
    bI = ProcessCzi.SeparateObjects1(tooLarge);
    
    tooLarge = bwareaopen(bI, AreaT);
    bPassed = bI & ~tooLarge;
    imBWout(bPassed) = 2;
    
    L = ProcessCzi.SeparateObjects(tooLarge,AreaT2);

    imBWout(L>0) = 2;
end
