function startup


% Script startup.m
%   Matlab init file.

% colordef none
% set(0,'DefaultFigurePosition',[100 200 900 600]);

% if isunix,
%     SACRaM_dir = fullfile( filesep, 'proj', 'pay' );
%     home_dir = fullfile( filesep, 'home', 'pay' );
% elseif ispc,
     SACRaM_dir = fullfile( filesep, 'pay' );
     SACRaM_dir = [ 'M:\pay-proj' SACRaM_dir ];
%     home_dir = fullfile( filesep, 'pay' );
%     home_dir = [ 'M:\pay-home' home_dir ];
% else
%     error( 'unrecognized system' )
% end

addpath( fullfile(SACRaM_dir, 'var', 'tools', 'CHARM', 'gedora'));

% if exist( [ home_dir filesep 'users' filesep 'luv' filesep 'matlab' filesep 'Dbin' ], 'dir' ) == 7,
%     path(...
%         [ home_dir filesep 'users' filesep 'luv' filesep 'matlab' filesep 'Dbin' ],...
%         path );
% end
clear SACRaM_dir home_dir
% 
% minmax = @(x)[ min( x ) max( x ) ];


addpath('M:\pay-proj\pay\CHARM\')


if ispc
    path_prefix = 'M:\pay-proj';
elseif isunix
    path_prefix = ''; 
end
filePath = fullfile( path_prefix, 'pay', 'CHARM', 'D_ged_qual_eval');

addpath(filePath); % add path of the routine ged_qual_plot


%add my personal scripts
filePaths = genpath('C:\Users\mah\Documents\MATLAB\General');
addpath(filePaths)

%add qcd
filePath = 'C:\Users\mah\Documents\MATLAB\General\qcd';
addpath(filePath)


%add nrelspa
filePath = 'C:\Users\mah\Documents\MATLAB\nrelspa';
addpath(filePath)



%add path of intercomparison
filePath = 'C:\Users\mah\Documents\Intercomparison';
addpath(filePath)

% run dni_startup script

dni_startup()

%add path of CloudCam
filePath = 'C:\Users\mah\Documents\CloudCam';
addpath(filePath)

cloudcam_startup()


cd('C:\Users\mah\Documents')




end