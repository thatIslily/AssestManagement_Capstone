clear

% read Ratios from matfile
m = matfile('JALSHRatios--PRIVILEGED-AND-CONFIDENTAIL.mat');
m.Properties.Writable = true;
JALSHRatios = m.JALSHRatios;

% drop empty columns
JALSHRatios = rmmissing(JALSHRatios,2,'MinNumMissing',100);

% read index prices from excel
JSE = xlsread('JSE_Price_Return_Daily.xlsx');
SP = xlsread('SP500_Price_Return_Daily.xlsx');

% align the order of date series in two files
JSE = flip(array2table(JSE, 'VariableNames', {'Dates','JSE_Close_Price','JSE_Total_Return','JSE_Period_Return'}));
SP = flip(array2table(SP, 'VariableNames', {'Dates','SP_Close_Price','SP_Total_Return','SP_Period_Return'}));

% convert excel time value to matlab time value
JSE.Dates = x2mdate(JSE.Dates,0);
JSE.Dates = datetime(JSE.Dates,'ConvertFrom','datenum');
SP.Dates = x2mdate(SP.Dates,0);
SP.Dates = datetime(SP.Dates,'ConvertFrom','datenum');
JSE_SP = outerjoin(SP,JSE,'MergeKeys',true);  

% merge tables
MergedTable = outerjoin(JALSHRatios,JSE_SP,'MergeKeys',true);  

% lag 'JSE_Close_Price'&'JSE_Total_Return' & 'JSE_Period_Return
MergedTable(2:end,84:86)=MergedTable(1:end-1,84:86);
MergedTable{1,84:86}= NaN([1,3]);

%save the table to matfile
save('MergedTable.mat','MergedTable')

%read matfile
m = matfile('MergedTable.mat');
m.Properties.Writable = true;

% drop empty columns
dataReady = m.MergedTable;
[nrows,ncols] = size(dataReady);

% get the header of dataset
header = dataReady.Properties.VariableNames';

% filter out the header with key words
target = [];
for i = 1:ncols
    expression = ['\w*PX\w*|\w*RETURN\w*|\w*EV\w*'];
    matchStr = regexp(header(i),expression,'match');
    target= [target;matchStr];
end
columns_to_tailor_index = find(~cellfun(@isempty,target));

% replace fixed values with NaN
for i=1: length(columns_to_tailor_index)
    theCol_index = columns_to_tailor_index(i);
    theCol = table2array(dataReady(:,theCol_index));
    row_to_tailor_index = find(abs(diff(theCol))<0.05);
    [theCol(row_to_tailor_index)]= deal(NaN);
    dataReady(:,theCol_index)= array2table(theCol);
end

% save prepared data
writetable(dataReady,'JALSH.csv') ;