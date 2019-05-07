

function Icolor = MakeColor(I1,bI3)

    bI3 = double(bI3)*0.5;

bR = bI3(:,:,1);
bG = bI3(:,:,2);
bB = bI3(:,:,3);


    Icolor = repmat(imadjust(mat2gray(I1)),[1 1 3]);
    
    color = [1 -1 -1];
    for i = 1:3
    Icolor(:,:,i) = Icolor(:,:,i) +  0.5*double(bR)*color(i);
    end 
    
    color = [-1 1 -1];
    for i = 1:3
    Icolor(:,:,i) = Icolor(:,:,i) +  0.8*double(bG)*color(i);
    end 
    
    color = [-1 -1 1];
    for i = 1:3
    Icolor(:,:,i) = Icolor(:,:,i) +  0.5*double(bB)*color(i);
    end 
end 