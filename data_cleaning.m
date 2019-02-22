clear
% read Ratios from matfile
m = matfile('JALSHRatios--PRIVILEGED-AND-CONFIDENTAIL.mat');
m.Properties.Writable = true;
JALSHRatios = m.JALSHRatios;
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
JSE_SP = outerjoin(JSE,SP,'MergeKeys',true);  
% merge tables
MergedTable = outerjoin(JALSHRatios,JSE_SP,'MergeKeys',true);  
% lag 'JSE_Close_Price'&'JSE_Total_Return' & 'JSE_Period_Return'
JSE_lagged1 = circshift(MergedTable.JSE_Close_Price,1);
JSE_lagged2 = circshift(MergedTable.JSE_Total_Return,1);
JSE_lagged3 = circshift(MergedTable.JSE_Period_Return,1);  
%merge tables
LagTable = table(JSE_lagged1,JSE_lagged2,JSE_lagged3);
% final dataset
dataReady =[MergedTable, LagTable];
