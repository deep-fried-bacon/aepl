addpath('../Utilities/src/MATLAB')
addpath('../aeplUtil')
addpath('../readPlotCsv')
addpath('../processCzi')


curDir = pwd;

f18_03_18 = '/Users/baylieslab/Documents/Amelia/rmsMim/18-03-18/';
f18_06_20 = '/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdomyosarcoma plate movies/18-06-20/';


f16_06_23 = '/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdomyosarcoma plate movies/16-06-23 (1st plate)/16-06-23/';

exper = struct();

%exper.folder = f16_06_23;
exper.folder = uigetdir('/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdomyosarcoma plate movies/');