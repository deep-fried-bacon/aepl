function labelVersion(path)

GIT = tdfread('.git/logs/HEAD');
Y = GIT.clone0x3A_from_https0x3A0x2F0x2Fgithub0x2Ecom0x2Fdeep0x2Dfried0;
X = GIT.x0000000000000000000000000000000000000000_542fa38aff1b597ceb0fa;

x = X(end,:);
y = Y(end,:);

fileID = fopen(fullfile(path,'Commit Stamp.txt'),'w');
fprintf(fileID,x);
fprintf(fileID,'    ');
fprintf(fileID,y);

fclose(fileID);
end 

