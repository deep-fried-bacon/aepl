%% 
function imBWout = SplitLargeAreas(BW)

%     AreaT = round(numel(BW)*0.004);
%     AreaT2 = round(numel(BW)*0.002);
    AreaT3 = 1500;
    AreaT2 = 1200;
    AreaT1 = 600;

    imBW = imresize(BW,0.5);
    
    imBWout = uint8(imBW);
    tooLarge = bwareaopen(imBW, AreaT2);
    imBWout(tooLarge) = 0;
    
    bI = ProcessCzi.SeparateObjects1(tooLarge);
    
    tooLarge = bwareaopen(bI, AreaT3);
    bPassed = bI & ~tooLarge;
    imBWout(bPassed) = 2;
    
    L = ProcessCzi.SeparateObjects(tooLarge,AreaT1);

    imBWout(L>0) = 2;
    
    imBWout = imresize(imBWout,size(BW),'method','nearest');
end
