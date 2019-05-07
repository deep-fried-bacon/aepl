function Plot6(Igrad1,testHigh,h,I,I1,I3)

subplot(4,3,2)
histogram(Igrad1(:))
hold on
plot([testHigh,testHigh], [0,max(h)])
hold off

subplot(4,3,5)
histogram(I)
hold on
plot([4,4], ylim)
plot([-2,-2], ylim)
grid on
hold off
%
subplot(2,3,3)

ID = -I;
ID(ID<0) = 0;
IL = I;
IL(IL<0) = 0;
Icolor = cat(3,mat2gray(IL),mat2gray(ID),I*0);
imagesc(Icolor)
ax = gca();
ax.Position = [2/3,0.5,1/3,0.5];

subplot(2,3,1)
imagesc(I1)
colormap gray
grid on
ax = gca();
ax.Position = [0,0.5,1/3,0.5];

subplot(2,3,4)
imagesc(Igrad1)
colormap gray
grid on
ax = gca();
ax.Position = [0,0,1/3,0.5];

subplot(2,3,5)
I1 = imresize(I1,0.5);
I3 = imresize(I3,0.5);

Icolor = ProcessCzi.MakeColor(I1,I3);

imagesc(Icolor)
ax = gca();
ax.Position = [1/3,0,1/3,0.5];
grid on
