%%wetbulb
%Function to calculate wetbulb temperature
%Written by Daniel Hueholt
%Last updated 11/21/17

function [wetbulbTemp] = wetbulb(P,Td,T)

epsilon = 0.622;
Lv = 2.5*10^6; %J/kg
Cp = 1005; %J/kg
psychro = (Cp.*P)./(epsilon.*Lv);
syms Tw
%T, P, e
eAct = 6.11*10.^((7.5.*Td)./(237.3+Td)); %Actual vapor pressure is calculated from dewpoint

wetbulbTemp = vpasolve(eAct == 6.11*10.^((7.5.*Tw)./(237.3+Tw))-psychro.*(T-Tw),Tw,[-100 50]);

end