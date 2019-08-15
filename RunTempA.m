
mini_rhabdo_set = '/Users/baylieslab/Documents/Amelia/project_workspaces/rhabdo/mini_rhabdo_set';

idk = '/Volumes/baylieslab/Current Lab Members/Whitney/Rhabdo Project/Tissue Culture/Timelapse/Rhabdomyosarcoma plate movies/Post-mycoplasma data (starting 9:18:18)/RH30/18-11-07.rht/Czi'

clear CONST
ProcessCzi.initConstants()
global CONST


ProcessCzi.RunProcessCzi(mini_rhabdo_set)


ProcessCzi.RunProcessCzi(idk)