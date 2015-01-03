function [ qc_flg ] = qc_check( varargin )
%QC_CHECK: simplified call of ged_qual_plot
%
%   Input:
%     the order of the input does not matter, if one is not specified, the
%     [default value] is choosen
%       category: ['SWLW'], 'UVB' , 'PFR', 'MET', 'dnic'
%       date: nothing: [yesterday], negative integer: number of days before
%       today or either a matlab datenum or yyyymmdd
%       [], 'mon', for an overwiev of several days
%  Outputs:
%     qc_flg_on : Logical scalar, true if abnormal behavior is detected
%
%   Mathias Hauser @ MeteoSwiss, Apr 2013

%input parsing
narginchk(0,3)

for ii = 1:nargin
    arg = varargin{ii};
    if iscell(arg)                  %cell  -> is category
        categories = arg;
    elseif ischar(arg)              %char  -> is category or 'mon'
        if strcmpi(arg, 'mon')
            is_month = true;
        else
            categories = {arg};
        end
    elseif arg < 0                  %.lt.0 -> is days before today
        assert(fix(arg) == arg, 'qc_c:wrong_rel_date', ...
            'Negative Date input must be an integer')
        dates = fix(now) + arg;
    elseif isfloat(arg)             %float -> is date
        %get number of digits (without decimals)
        num_dig = floor(log10(abs(arg)+1)) + 1;
        % -> matlab datenum if num_dig = 5 and first digit = 7
        % (i.e. between 1916 and 2190)
        if num_dig == 5 && fix(arg/1e5) == 7
            dates = fix(arg);
        elseif num_dig == 8 && fix(arg) == arg %is yyyymmdd
            %convert to datenum
            dates = datenum(num2str(arg), 'yyyymmdd');
        else
            error('qc_c:wrong_date_num', ...
                'Date input must be yyyymmdd or matlab date number')
        end %if
    end %if
end %for
%if category/ date was not assigned -> use default
if ~exist('categories', 'var'); categories = {'SWLW'}; end
if ~exist('is_month', 'var'); is_month = false; end
if ~exist('dates', 'var'); dates = fix(now) - 1; end; %yesterday [default]

%end input parsing


%create FilePath
if ispc
    path_prefix = 'M:\pay-proj';
elseif isunix
    path_prefix = '';
end
filePath = fullfile( path_prefix, 'pay', 'CHARM', 'D_ged_qual_eval');

%addpath(filePath); % add path of the routine ged_qual_plot

mode = 'full';


for idate = numel(dates) %loop through dates
    date_str = datestr(dates(idate), 'yyyymmdd') ;
    for icat = 1:numel(categories) %loop through categories
        %path and name of daily file
        fileName = fullfile(filePath, 'D_day', ['D_' categories{icat} '_chk'], ['qc_chk_' date_str '.mat']);
        if is_month % || isempty(dir(fileName))
            fileName = fullfile(filePath, 'D_mon', ['D_' categories{icat} '_chk'], ['qc_chk_' date_str '.mat']);
        end
        qc_flg =  ged_qual_plot(fileName, mode );
        %pause
    end %for icat
end %for idate


end

