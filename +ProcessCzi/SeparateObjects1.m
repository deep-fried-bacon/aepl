
function bOut = SeparateObjects1(imBW)


L = bwlabel(imBW);
if nnz(imBW)==0
    bOut = imBW;
    return
end

N = 1;
Erode = imerode(imBW,ones([N,N,1]));
Erode = bwareaopen(Erode,10);

D = bwdistgeodesic(imBW, Erode);
D(~imBW) = Inf;
L3 = watershed(D,8);
L3(~imBW) = 0;

bOut = L3>0;
%bOut = imerode(bOut,1);

end