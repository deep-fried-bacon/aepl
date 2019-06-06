

deathTest = 'C:\Users\eac84\OneDrive\Desktop\death_ex_for_edgar\death_ex_for_edgar';
LotsOfCells = 'D:\Google\MSK data';

[exper,condits] = ReadCsvAsCondits(experPath);

SummarizeData.RunSummarizeData(experPath,exper,condits)
PlotData.RunPlotData(experPath,exper,condits)

profile on 
ProcessCzi.RunProcessCzi(LotsOfCells)
profile viewer

