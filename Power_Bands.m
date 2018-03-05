% Power_Bands.m
% assumes eeg lab started in Matlab
pid = 39;
subdir = sprintf('/Users/dave/Documents/MATLAB/EEGLAB/S%d', pid);
%subdir = sprintf('/Users/dave/Data/dft/S%d', pid);
sub = sprintf('ss%d', pid);
coi = 1;

% load the dinfile
dinfile = sprintf('%s/s%d_dins.txt', subdir, pid);
[Epo, Cod, Rep] = importfile(dinfile);
Num_epo = numel(Epo);

% get a file to write
filnam1 = sprintf('%s/%s_tlt_Power.txt', subdir, sub);
%filnam1 = sprintf('%s/%s_tlt_Power2.txt', subdir, sub); %Power2 if rej
fileID1 = fopen(filnam1,'w');
filnam2 = sprintf('%s/%s_Power.txt', subdir, sub);
fileID2 = fopen(filnam2,'w');
fprintf('Writing file = %s\n', filnam1);

% Format: Subject, Epoch, Code, Repeat, Channel, COI (Channel of Interest), delta, theta, alphaL, alphaH, beta
% write header
fprintf(fileID2, 'Subject, Epoch, Code, Repeat, Channel, COI (Channel of Interest), deltaPower, thetaPower, alphaLPower, alphaHPower, betaPower\n');
fprintf(fileID1, 'Subject, Epoch, Code, Repeat, Channel, COI (Channel of Interest), tlt_deltaPower, tlt_thetaPower, tlt_alphaLPower, tlt_alphaHPower, tlt_betaPower\n');

for k=1:Num_epo
  epo = k;
  code = Cod{k};
  repeat = Rep(k);
  
  % get the data
  ifilnam = sprintf('%s-e%d.set', sub, epo);
  %ifilnam = sprintf('%s_e%d_rej_js1.set', sub, epo);
  fprintf('Getting data from %s %s \n', subdir, ifilnam);

  EEG = pop_loadset('filename',ifilnam,'filepath',subdir);
  EEG = eeg_checkset( EEG );
  [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off');

  % Calculate the spectrum
  fprintf('Calculating Spectrum for subject = %s, Epoch = %d\n', sub, epo);
  [spectrum freqs] = pop_spectopo(EEG, 1, [EEG.xmin EEG.xmax]*1000, 'EEG' , 'percent', 100);
  tltspect = 10.^(spectrum/10);
  
  % Pull the power bands
  fprintf('Extracting Power\n');
  % delta (1-3 Hz)
  [tmp minind] = min(abs(freqs-1));
  [tmp maxind] = min(abs(freqs-3));
  deltaPower = mean(spectrum(:, minind:maxind),2);
  tltdeltaPower = mean(tltspect(:, minind:maxind),2);

  % theta (4-7 Hz), 
  [tmp minind] = min(abs(freqs-4));
  [tmp maxind] = min(abs(freqs-7));
  thetaPower = mean(spectrum(:, minind:maxind),2);
  tltthetaPower = mean(tltspect(:, minind:maxind),2);

  % alphaL (8-10 Hz), 
  [tmp minind] = min(abs(freqs-8));
  [tmp maxind] = min(abs(freqs-10));
  alphaLPower = mean(spectrum(:, minind:maxind),2);
  tltalphaLPower = mean(tltspect(:, minind:maxind),2);

  % alphaH (10-12 Hz), 
  [tmp minind] = min(abs(freqs-10));
  [tmp maxind] = min(abs(freqs-12));
  alphaHPower = mean(spectrum(:, minind:maxind),2);
  tltalphaHPower = mean(tltspect(:, minind:maxind),2);

  % beta (13-35 Hz), 
  [tmp minind] = min(abs(freqs-13));
  [tmp maxind] = min(abs(freqs-35));
  betaPower = mean(spectrum(:, minind:maxind),2);
  tltbetaPower = mean(tltspect(:, minind:maxind),2);

  % gamma (35-100 Hz)
  % Don't do for now, spectrum seems not stable over ~50Hz

  % Write the result
  
  % write data
  for i=1:65
    fprintf(fileID1, '%s, %d, %s, %d, %d, %d, %8.2f, %8.2f, %8.2f, %8.2f, %8.2f \n', sub, epo, code, repeat, i, coi, deltaPower(i), thetaPower(i),alphaLPower(i), alphaHPower(i), betaPower(i));
    fprintf(fileID2, '%s, %d, %s, %d, %d, %d, %8.2f, %8.2f, %8.2f, %8.2f, %8.2f \n', sub, epo, code, repeat, i, coi, tltdeltaPower(i), tltthetaPower(i), tltalphaLPower(i), tltalphaHPower(i), tltbetaPower(i));
  end

  
  ALLEEG = pop_delset( ALLEEG, [1] );

% kill the matlab window???

end

%close the output file
fclose(fileID1);
fclose(fileID2);

%the end
fprintf('The End, Thanks for playing along...\n');




