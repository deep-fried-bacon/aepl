
clear CONST
ProcessCzi.initConstants()
global CONST


rhabdoDir = '/Users/baylieslab/Documents/Amelia/data/rhabdo';

exampFramesDir = [rhabdoDir, '/miniRhabdoSet/exampFrames2/subset/okay'];


f18_11_07 = [rhabdoDir, '/rht/RH30_18-11-07.rht/Czi'];

repSet = [rhabdoDir, '/repRhabdoSet'];


ProcessCzi.RunProcessCzi(repSet)
