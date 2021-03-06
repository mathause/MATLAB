%$$$ 
%$$$ #undef __PR
%$$$ #include "VARIANT.h"

function c = sw_satO2(S,T)

% SW_SATO2   Satuaration of O2 in sea water
%=========================================================================
% sw_satO2 $Revision: 1.1 $  $Date: 1998/04/22 02:15:56 $
%          Copyright (C) CSIRO, Phil Morgan 1998.
%
% USAGE:  satO2 = sw_satO2(S,T,P)
%
% DESCRIPTION:
%    Solubility (satuaration) of Oxygen (O2) in sea water
%
% INPUT:  (all must have same dimensions)
%   S = salinity    [psu      (PSS-78)]
%   T = temperature [degree C (IPTS-68)]
%
% OUTPUT:
%   satO2 = solubility of O2  [ml/l] 
% 
% AUTHOR:  Phil Morgan 97-11-05  (morgan@ml.csiro.au)
%
%$$$ #include "disclaimer_in_code.inc"
%
% REFERENCES:
%    Weiss, R. F. 1970
%    "The solubility of nitrogen, oxygen and argon in water and seawater."
%    Deap-Sea Research., 1970, Vol 17, pp721-735.
%=========================================================================

% CALLER: general purpose
% CALLEE: 

%$$$ #ifdef VARIANT_PRIVATE
%$$$ %***********************************************************
%$$$ %$Id: sw_satO2.M,v 1.1 1998/04/22 02:15:56 morgan Exp $
%$$$ %
%$$$ %$Log: sw_satO2.M,v $

%$$$ %
%$$$ %***********************************************************
%$$$ #endif

%----------------------
% CHECK INPUT ARGUMENTS
%----------------------
if nargin ~=2
   error('sw_satO2.m: Must pass 2 parameters')
end %if

% CHECK S,T dimensions and verify consistent
[ms,ns] = size(S);
[mt,nt] = size(T);

  
% CHECK THAT S & T HAVE SAME SHAPE
if (ms~=mt) | (ns~=nt)
   error('sw_satO2: S & T must have same dimensions')
end %if

% IF ALL ROW VECTORS ARE PASSED THEN LET US PRESERVE SHAPE ON RETURN.
Transpose = 0;
if ms == 1  % row vector
   T       =  T(:);
   S       =  S(:);   
   Transpose = 1;
end %if

%------
% BEGIN
%------

% convert T to Kelvin
T = 273.15 + T; 

% constants for Eqn (4) of Weiss 1970
a1 = -173.4292;
a2 =  249.6339;
a3 =  143.3483;
a4 =  -21.8492;
b1 =   -0.033096;
b2 =    0.014259;
b3 =   -0.0017000;

% Eqn (4) of Weiss 1970
lnC = a1 + a2.*(100./T) + a3.*log(T./100) + a4.*(T./100) + ...
      S.*( b1 + b2.*(T./100) + b3.*((T./100).^2) );

c = exp(lnC);

return

