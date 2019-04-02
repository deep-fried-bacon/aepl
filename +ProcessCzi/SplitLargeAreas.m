%% 
function imBWout = SplitLargeAreas(imBW)

    imBWout = uint8(imBW);

    tooLarge = bwareaopen(imBW, 6000);
    imBWout(tooLarge) = 0;

    L = ProcessCzi.SeparateObjects(tooLarge,3500);

    imBWout(L>0) = 2;
end
