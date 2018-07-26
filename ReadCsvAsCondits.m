%% ReadCsv  -  dev
%   take path and read in each csv
%   return exper and condits
%


function [exper, condits] = ReadCsvAsCondits(experPath)
    global CONST
    [COL_LAYOUT,COL_COUNT,COLS] = GetColLayout(CONST.COL_LAYOUT_VER); 
     
    
    csvDir = fullfile(experPath, CONST.CSV_DIR);
    
    %exper = struct();
    %exper.
    plateMapFile = FindFile(experPath,CONST.PLATE_MAP_SUF);
    exper = struct();
    % could all be done in one line but it was really long
        temp = ReadPlateMap(plateMapFile);
        exper.conditions = tem(1);
        exper.conditWellMap = temp(2);
        exper.groupWellMap = temp(3);
    %
    
    
    clear condits
    exper.conditIndexMap = containers.Map();
    %condits(size(exper.conditions,2)) = struct();
    condits(length(exper.conditions)) = struct();
    %for c = 1:size(exper.conditions,2)
    for c = 1:length(exper.conditions)
        condits(c).name = exper.conditions{c};  
        exper.conditIndexMap(exper.conditions{c}) = c; 

        disp(condits(c).name)
        disp(exper.conditWellMap(exper.conditions{c}))

        conditWells = exper.conditWellMap(exper.conditions{c});
        condits(c).wells(size(conditWells)) = struct();

        %for w = 1:size(conditWells,2)
        for w = 1:length(conditWells)
            condits(c).wells(w).name = conditWells(w);
            %condits(c).wells(w).path = strcat(exper.folder,'Xls/', exper.name,'_',condits(c).wells(w).name{1}, '.csv');
            condits(c).wells(w).path = FindFile(csvDir,condits(c).wells(w).name);
            %if exist(condits(c).wells(w).path, 'file')
            if condits(c).wells(w).path

                condits(c).wells(w).raw = readtable(condits(c).wells(w).path);

                condits(c).wells(w).cellCount = width(condits(c).wells(w).raw)/COL_COUNT;

                condits(c).wells(w).raw = condits(c).wells(w).raw.Variables;

                condits(c).wells(w).cells(condits(c).wells(w).cellCount) = struct();

                for j = 1:condits(c).wells(w).cellCount
                    startCol = (j-1)*5;
                    condits(c).wells(w).cells(j).id = condits(c).wells(w).raw{1,startCol+1};

                    for k = 1:COL_COUNT
                        condits(c).wells(w).cells(j).(COLS{k}) = str2double(condits(c).wells(w).raw(5:end,startCol+COL_LAYOUT.(COLS{k})));
                        if isnan(condits(c).wells(w).cells(j).(COLS{k})(end))
                            condits(c).wells(w).cells(j).(COLS{k})(end) = [];
                        end
                    end

                end
            else 
                disp(strcat('missing csv file', condits(c).wells(w).name))
            end
        end
    end
    
    

end