fprintf(1,'frame 1')

for i = 1:1100
    pause(.01)
    for j = 1:log10(i) + 1
        fprintf(1,'\b')
    end
    fprintf(1,num2str(i+1))
        
end
    fprintf(1,'\n')