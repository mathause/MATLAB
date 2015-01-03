function [spa,M2,M3]=nrelspa(time,lat,long,altitude,pressure,temperature)
%function [sza,M2,M3]=nrelspa(time,lat,long,altitude,pressure,temperature)
% 3 6 2010 JG
% NREL Solar Positioning Algorithm
% see web-site for details or report
% time is matlab time in UTC, can be vector
% lat is latitude
% long is longitude, positive going East
% station pressure in mb
% Temperature in degC
%
% returns spa=[zenith, azimuth, azimuth180, sunrise local_noon  sunset zenith_uncorrected refraction_correction]
%
% Apparent SZA=True SZA- Refraction Correction

% 3 6 2010 JG ist etwa 14 Mal langsamer als brewersza



%temperature
if nargin<6, temperature=[];end
if isempty(temperature),temperature=15;end
%pressure
if nargin<5, pressure=[];end
if isempty(pressure),pressure=1013.5;end
%altitude
if nargin<4, altitude=[];end
if isempty(altitude),altitude=0;end

%time
if nargin<1,time=[];end
if isempty(time)
    time=now;
    warning('nrelspa:time', 'Time set to ''now'' (%s)', datestr(time));
end


%latitude
if nargin<2, lat=[];end
if isempty(lat)
    lat = 46.815;
    warning('nrelspa:lat', 'Latitude set to %f', lat)
end

%longitude
if nargin<3, long=[];end
if isempty(long)
    long = 6.944;
    warning('nrelspa:lon', 'Longitude set to %f', long)
end




% altitude, pressure and temperature affect only the refraction correction...

spa=nrelspavec(time,lat,long,altitude,pressure,temperature);
spa(:,7)=90-spa(:,7);




if nargout > 1
    % airmass calculation (based on brewer software
    
    R=6370;
    hray=5;   % effective rayleigh layer,
    ho3=22;% effective ozone layer
    
    E=spa(:,1)*pi/180;  % using the refraction correction (different from brewer)
    M3=R./(R+hray).*sin(E);
    M3=1./cos(atan(M3./sqrt(1-M3.^2)));
    
    E=spa(:,7)*pi/180;   % no refraction for ozone layer...
    M2=R./(R+ho3).*sin(E);
    M2=1./cos(atan(M2./sqrt(1-M2.^2)));
end
