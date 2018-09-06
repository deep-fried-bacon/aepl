%     global CONST
%     CONST = struct();
%     
%     CONST.PLATE_MAP_SUF = '_plate-map.csv';
%     CONST.CZI_SUF = '.czi';
%     CONST.CONDIT_DATA_SUF = '-veloc-conditions.csv';
%     CONST.WELL_DATA_SUF = '-veloc-wells.csv';
%     CONST.PLOT_SUF = '-veloc-plot.pdf';
%    
%     CONST.AVG_PREF = 'Avg';
%     CONST.MEDI_PREF = 'Median';
% 
%     
%     CONST.CZI_DIR = '';
%     CONST.CSV_DIR = 'Csv';
%     CONST.PROCESSED_DIR = 'ProcessedData';
%     CONST.ANNOTATED_TIF_DIR = 'TifsWithTracks';
%     
%     %CONST.COL_LAYOUT_VER = '4 cols';
%     CONST.COL_LAYOUT_VER = '5 cols';
%     %CONST.COL_LAYOUT = AeplUtil.GetColLayout(CONST.COL_LAYOUT_VER);
%     
%     CONST.SET_LAEOUT = [2, 3];    % [rows, columns
%     CONST.CONTROL = 'Control';
const

f16_06_23 = '/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdomyosarcoma plate movies/16-06-23 (1st plate)/16-06-23/';
f17_06_28 = '/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdomyosarcoma plate movies/17-06-28 final pi3k inhibitors/';
f17_07_13 = '/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdomyosarcoma plate movies/17-07-13 and 20170629 first plate fda screen/7.13.17 Part b/Whitney2/';
f18_06_20 = '/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdomyosarcoma plate movies/18-06-20/';
f18_03_18 = '/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdomyosarcoma plate movies/2018-3-18';
f18_08_02 = '/Volumes/baylieslab/Current Lab Members/Whitney/Whitney  8-2';

experPath = f18_03_18;
[exper,condits] = ReadCsvAsCondits(experPath);
        
