%epochize_v1.m

%Select subjet number
sub = 39;

%Assumes original file is already loaded into EEGLAB
%Make sure to load by hand first...
%ifilnam = sprintf('/Users/dave/Data/SocialSync/NewData/social synchrony %d seg.fil.reref.matlab.mat',sub);
%fprintf('Loading data file %s\n', ifilnam);
%load(ifilnam, 'din1_Segment1')

%should read the number of epochs, now, hardcoded per subject
for epo=1:20
  fprintf('Doing Epoch %d\n', epo);
  EEG = pop_selectevent( EEG, 'epoch',epo,'deleteevents','off','deleteepochs','on','invertepochs','off');
  nam1 = sprintf('/Users/dave/Data/SocialSync/NewData/social synchrony %d_e%d seg.fil.reref.matlab',sub,epo);
  [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',nam1,'gui','off'); 
  EEG = eeg_checkset( EEG );
  nam2 = sprintf('EEGLAB/S%d/ss%d-e%d.set', sub, sub, epo);
  EEG = pop_saveset( EEG, 'filename',nam2,'filepath','/Users/dave/Documents/MATLAB/');
  [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
  ALLEEG = pop_delset( ALLEEG, [2] );
  eeglab redraw;
end