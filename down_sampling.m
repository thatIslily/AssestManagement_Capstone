clear
filename = 'JALSHRatios--PRIVILEGED-AND-CONFIDENTAIL.mat';
m = matfile(filename);
m.Properties.Writable = true;
JALSHRatios = rmmissing(m.JALSHRatios,2,'MinNumMissing',100);
[nrows,ncols] = size(JALSHRatios);

%Get the header
header = JALSHRatios.Properties.VariableNames';

%Filter out the header with key words
target = [];
for i = 1:ncols
     expression = ['\w*ASSET\w*|\w*LIB\w*|\w*CASH\w*|\w*RATIO\w*|\w*PX\w*|\w*SH\w*|\w*EV\w*|'...
    '\w*BOOK\w*|\w*CAPITAL\w*|\w*CAP\w*|\w*EARN\w*|\w*EPS\w*|\w*EARN\w*|\w*EPS\w*|\w*EBITDA\w*|'...
    '\w*TO\w*|\w*EQUITY\w*|\w*MARGIN\w*'];
    matchStr = regexp(header(i),expression,'match');
    target= [target;matchStr];
end
columns_to_tailor_index = find(~cellfun(@isempty,target));

for i=1: length(columns_to_tailor_index)
    theCol_index = columns_to_tailor_index(i);
    theCol = table2array(JALSHRatios(:,theCol_index));
    row_to_tailor_index = find(abs(diff(theCol))<0.01);
    [theCol(row_to_tailor_index)]= deal(NaN);
    JALSHRatios(:,theCol_index)= array2table(theCol);
end


writetable(JALSHRatios,'alinged_JALSHR.csv')   