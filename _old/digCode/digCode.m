function digCode(data)
% function digCode(data)
%   Sends 16 bit data to FIRSTPORTA and FIRSTPORTB of a Measurement
%   Computing card.  After setting the code, sends a strobe on the first
%   bit of FIRSTPORTC.
% Usage:
%   > digCode(1:1000); % sends the numbers 1 through 1000 sequentially
%   > digCode('abcdefghijk'); % sends the characters 'a' through 'k'