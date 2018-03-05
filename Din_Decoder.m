% Bin_Decoder.m

% load data file
sub = 39;
ifilnam = sprintf('/Users/dave/Data/SocialSync/NewData/social synchrony %d.seg.fil.reref.mat',sub);
fprintf('Loading data file %s\n', ifilnam);
load(ifilnam, 'DIN_1')

item = cell(30,1);


% get a file to write
filnam = sprintf('/Users/dave/Documents/MATLAB/EEGLAB/S%d/s%d_dins.txt', sub, sub);
fileID = fopen(filnam,'w');
fprintf('Writing file = %s\n', filnam);

% Write header
fprintf(fileID, 'Epoch, Code, Repeat\n');

counter = zeros(9);
items = 1;
for i=1:size(DIN_1,2)
  code = DIN_1{1,i};
  % have we seen this code?
  found = 0;
  for j=1:items-1;
    if(strcmp(code,item(j)))
        counter(j)=counter(j)+1;
        idx = j;
        found = 1;
    end
  end
  if(found == 0)
       % New item
       item{items} =  code;
       counter(items) = counter(items)+1;
       idx = items;
       items = items + 1;
  end        
  fprintf(fileID, '%d, %s, %d \n',i, code, counter(idx));
end

fclose(fileID);
