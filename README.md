# EnvAn-WN Phase 2
Basic description: MATLAB functions and scripts for warm nose sounding and surface conditions analysis.

Repository contains functions and scripts which are designed to be used in the analysis of warm noses/melting layers and surface conditions. Files were created by Daniel Hueholt at North Carolina State University, unless otherwise specified.

For suggested bundles to download, see Toolboxes.txt. (Does not cover changes since beginning of September 2017.)

Tags: 2014b, ASOS, clouds, external, filter, IGRA toolbox, import, in progress, Mesowest toolbox, original, poster, plotting toolbox, removed phase 2, renamed, sounding, surface observations, unused, utilities, warm nose toolbox, wetbulb, winds

File descriptions:

addaxis: Functions to add multiple axes to a plot. Written by Harry Lee; found on the MATLAB file exchange.
Original link: https://www.mathworks.com/matlabcentral/profile/authors/863384-harry-lee

ASOSdownloadFiveMin: Current version (10/13/17) of MATLAB function to download Automated Surface Observation System (ASOS) five-minute data from the NCDC database. Updated 10/13/17 to squash a bug that prevented the download of a year of data to a file path other than the active dirrectory. Tags: ASOS, import, surface observations

ASOSgrabber: Current version (10/10/17) of MATLAB function to make browsing of ASOS structures easier by grabbing a section of data from a structure around a given input time. Tags: ASOS, surface observations

ASOSimportFiveMin: Current version (11/12/17) of MATLAB function to import five-minute ASOS data into MATLAB given an input file. Updated 11/12/17 to use UTC instead of local standard time. Note that predictable date issues (end of month +5 hours) are only resolved for months with 31 days and for special December case where year changes as well as day (month will not work properly though). Tags: ASOS, import, surface observations

ASOSimportOneMin: Latest version (9/6/17) of function to create a structure of one-minute ASOS data given an input file. Renamed from ASOSimport 9/15/17.  Tags: surface observations, ASOS, import, renamed

CCOWindProfile: Function to plot wind profiles in the atmosphere. Written by Laura Tomkins (github @lauratomkins) in May 2017. Tags: external, winds

cloudbaseplot: Current version (8/29/17) of function to plot cloud base as estimated from sounding relative humidity observations. Tags: sounding, plotting toolbox, clouds Requires: dewrelh

datetickzoom: Function which expands on datetick so the ticks update at different zoom levels, originally written by Christophe Lauwerys. Link: https://www.mathworks.com/matlabcentral/fileexchange/15029-datetickzoom-automatically-update-dateticks Tags: external, warm nose toolbox, utilities, external

dewrelh: Current version (9/1/17) of MATLAB function to calculate dew point and relative humidity from temperature and dew point depression. Tags: plotting toolbox, IGRA toolbox

embemo: Current version (10/9/17) of MATLAB script to demonstrate visualization of ASOS data using a toy dataset. Requires plotyyy. Tags: ASOS, surface observations, utilities

findsnd: Current version (9/1/17) of MATLAB function to find the sounding number for a particular date and time within a soundings data structure. Tags: sounding, plotting toolbox, IGRA toolbox, warm nose toolbox

fullIGRAimp: Current version (10/10/17) of MATLAB function to import IGRA v1 data and output ALL useful sounding structures. Renamed from “IGRAimpfil” in 9/3/17 push. Updated 10/10/17 to allow for variable number of inputs and outputs. Tags: renamed, sounding, IGRA toolbox, import, filter Requires: dewrelh, IGRAimpf, timefilter, levfilter, surfconfilter, nosedetect, prestogeo, precipfilter, simple_prestogeo, wnumport

IGRAimpf: Current version (9/1/17) of MATLAB function to create a structure of soundings data from raw Integrated Global Radiosonde Archive v1 .dat data. (Based on a function originally written by Megan Amanatides.) Tags: sounding, import, IGRA toolbox

levfilter: Current version (9/1/17) of MATLAB function to filter out given level types from IGRA v1 soundings data. Renamed from “levfilters” in 9/3/17 push. Tags: filter, sounding, IGRA toolbox

mesowestDecoder: Current version (8/4/17) of MATLAB function to decode present weather codes from Mesowest data. Renamed from “ASOSdecoder” in 9/3/17 push. Tags: Mesowest toolbox, surface observations

newtip: Current version (9/1/17) of MATLAB function to create a custom Data Cursor tooltip using variables from within a parent function. Must be nested within another function. This version of newtip is specifically designed to work with wnAllPlot and wnYearPlot, but the method could easily be adapted for any similar circumstance. Tags: warm nose toolbox, utilities

nosedetect: Current version (11/11/17) of MATLAB function to separate a soundings data structure into warm nose and non warm nose structures, with the warm nose structure containing a nested structure with details about said noses. Updated 11/11/17 to fix problem where some warm nose depths were calculated to be negative. Tags: sounding, IGRA toolbox Requires: findsnd, prestogeo, simple_prestogeo

plotyyy: Current version (10/9/17) of MATLAB function to plot data using three y-axes. Small changes made to original function written by Denis Gilbert of the Maurice Lamontagne Institute. Tags: utilities

precipfilter: Current version (9/6/17) of MATLAB function to filter warm nose soundings data by the presence of precipitation at the surface, as shown in Mesowest data adjacent in time to the soundings in the input structure. Comment added to aid future development 9/6/17. Tags: surface observations, sounding, IGRA toolbox

prestogeo: Current version (9/1/17) of MATLAB function to calculate geopotential height given pressure and temperature. Includes a variety of bonus options which make it easier to use with other functions; for a bare-bones geopotential height calculator, see simple_prestogeo. Equation comes from Durre and Yin (2008) http://journals.ametsoc.org/doi/pdf/10.1175/2008BAMS2603.1 Tags: sounding, IGRA toolbox

rangebardemo: Demonstration of the “stacked” and “patch" methods to make ranged bar charts. Renamed from “rangebartest” in 9/3/17 push. Tags: external, utilities, renamed

RHvZ: Current version (11/30/17) of MATLAB function to generate a figure with relative humidity vs height. Updated 11/30/17 with aesthetic changes. Tags: sounding

rhumplot: Current version (9/1/17) of MATLAB function to generate a figure with charts of relative humidity vs pressure and relative humidity vs height from input sounding number and sounding data structure. Additionally, makes a guess at cloud base height. Tags: plotting toolbox, sounding, clouds

simple_prestogeo: Current version (9/1/17) of MATLAB function to calculate geopotential height given pressure and temperature. This is a no-frills calculator; see prestogeo for a calculator designed to interface with other functions. Tags: utilities, IGRA toolbox

skewT: Current version (8/4/17) of MATLAB function to generate a skew-T chart given information from a soundings structure. Adapted from code originally found at MIT OpenCourseware. Renamed from “FWOKXskew” in 9/3/17 push. Tags: plotting toolbox, sounding

soundplots: Current version (9/3/17) of MATLAB function to generate a variety of figures based on soundings data for a specific time and date. Tags: sounding, plotting toolbox Requires: dewrelh, skewT, sounding

surfacePlotter: Current version (11/30/17) of MATLAB function to visualize ASOS five-minute surface conditions data. Updated 11/30/17 with aesthetic changes. Requires external functions addaxis, tlabel, and windbarb. addaxis was originally written by Harry Lee, tlabel by Carlos Adrian Vargas Aguilera, and windbarb by Laura Tomkins. Tags: ASOS, surface observations

surfconfilter: Current version (9/3/17) of MATLAB function to filter soundings data structure based on surface conditions. Tags: surface observations, IGRA toolbox, filter, sounding

surfconfind: Current version (9/3/17) of MATLAB function to find row index of Mesowest data table corresponding to an input time. Can also return the section of said table which contains the index and its surrounding entries, with the number of surrounding entries controllable by the user. Tags: surface observations, Mesowest toolbox

timefilter: Current version (11/22/17) of MATLAB function to filter out years and months from a sounding structure. Updated 11/22/17 to update function name in the help. Tags: sounding, IGRA toolbox

tlabel: External function to improve on datetick and datetickzoom. Written by Carlos Adrian Vargas Aguilera, found on the MATLAB file exchange. Original link: https://www.mathworks.com/matlabcentral/fileexchange/19314-tlabel-m-v2-6-1--sep-2009-
Tags: external, utilities

TvZ: Current version (11/30/17) of MATLAB function to plot a temperature-height figure from soundings data given an input time. Updated 11/30/17 with aesthetic changes. Tags: sounding, plotting toolbox

TvZprint: Current version (8/19/17) of MATLAB function to plot a temperature-height figure from soundings data given an input time, with figure settings tuned to be most useful for posters. Tags: soundings, poster

windbarb: MATLAB function to plot wind barbs. Written by Laura Tomkins (github @lauratomkins) in May 2017.

wnAllPlot: Current version (8/24/17) of MATLAB function to display various kinds of warm nose plots based off a soundings structure containing warm nose data. Uses the stacked method for ranged bar graphs, which causes problems in representing some kinds of warm noses. Renamed from “wnaltplot” in 9/3/17 push. Tags: sounding, warm nose toolbox, renamed Requires: newtip, datetickzoom

wnplot: Current version (9/28/17) of MATLAB function to create warm nose plots for individual soundings given an input time and soundings data. Uses the patch method for ranged bar graphs; accurately displays all warm noses that nosedetect properly represents. Renamed from “wnaltind” in 9/3/17 push. Updated 9/28/17 to fix the y-limit between 0 and 5 km. Tags: sounding, warm nose toolbox Requires: findsnd

wnplot_poster: Current version (8/24/17) of MATLAB function to create warm nose plots for individual soundings given an input time and soundings data. Uses the patch method for ranged bar graphs; accurately displays all warm noses that nosedetect properly represents. An improved version requiring MATLAB 2014b or later will be released soon. Renamed from “wnaltindposter” in 9/3/17 push. Tags: sounding, warm nose toolbox, poster Requires: findsnd

wnumport: Current version (8/28/17) of MATLAB function to create a structure of surface observations data given a raw Mesowest csv file. Tags: surface observations, IGRA toolbox, Mesowest toolbox

wnYearPlot: Current version (9/3/17) of MATLAB function to create warm nose plots for an input year. Uses the stacked method for ranged bar graphs, which causes problems in representing some kinds of warm noses. Renamed from “wnaltyearplot” in 9/3/17 push. Tags: sounding, warm nose toolbox Requires: datetickzoom, newtip

In Progress:

abacusDemo: Current (11/13/17) version of MATLAB script demonstrating the abacus plot for visualizing weather codes over time. Needs better formatting and documentation to be completed.

addHeight: Current (11/30/17) version of MATLAB function to add a calculated geopotential height field to a soundings structure. Needs documentation. Tags: in progress, sounding

addWetbulb: Current (11/27/17) version of MATLAB function to add a wetbulb temperature field to a soundings structure. Currently runs properly, but is incredibly time consuming due to inefficient construction. Tags: in progress, soundings, wetbulb

ASOSimportFiveMin: Current (9/21/17) version of MATLAB function to import ASOS five-minute data from a .dat file. Updated 9/21/17 with continuing development.

cloudplot: Current (11/20/18) version of MATLAB function to plot cloud locations, when provided with the time and cloud bounds. Tags: in progress, soundings, clouds

convection: Current (5/31/17) version of MATLAB function to find relevant meteorological variables necessary to calculate basic properties relevant to convection and stability. Currently just a code skeleton from Megan Amanatides’s original script. Tags: unused, original, in progress

embemo_2014bOrNewer: Current (10/10/17) version of MATLAB script to demonstrate visualization of ASOS data, using techniques only available in MATLAB 2014b or newer. Requires plotyyy. Tags: 2014b, ASOS, surface observations, utilities, in progress

findTheCloud: Current (11/30/17) version of MATLAB function to establish cloud boundaries given a sounding data structure. Tags: in progress, soundings, clouds

haha: Current (11/30/17) version of MATLAB script to draw just the nose portion of soundings. Currently hacked together with hardcoded data. Tags: in progress, soundings

makeWarmCloud: Current (11/30/17) version of MATLAB function to determine what part of a profile is above freezing, in cloud, and/or both. Tags: in progress, soundings, wetbulb

newNoseDetect: Current (11/12/17) version of MATLAB function to detect warm noses, writtent to be quicker, more flexible, and more powerful than nosedetect is currently. Updated with further development pursuing the diff function method; now properly treats all potential types of noses.  Tags: sounding, in progress

noseplotfind: Current version (8/17/17) of MATLAB function to detect and display warm noses. Current displays TvP, TvZ, and skew-T charts. See “to be added” section near end of function help for features in development. Tags: in progress, sounding Requires: prestogeo

numwarmnose: Current version (8/18/17) of MATLAB script to divide up soundings data by the number and type of warm noses present. Tags: sounding, in progress, warm nose toolbox

precipfilterASOS: Current version (9/28/17) of MATLAB function to filter a soundings structure by presence of precipitation as detected by ASOS. Currently in very early stages of development. Tags: in progress, ASOS, sounding, filter

represamWn: Current version (11/30/17) of MATLAB function to properly do what haha does. Tags: in progress, soundings

surfAnalysisLI: Current version (11/27/17) of MATLAB function to make a local surface analysis over the greater Long Island area using ASOS data. Currently in early stages of development; fed toy data for now. Tags: in progress, ASOS

TTwvZ: Current version (11/30/17) of MATLAB function to generate a plot of temperature and wetbulb temperature vs height. Tagged as in progress because it was written in a crazy hurry and probably full of issues. Updated with aesthetic changes. Tags: in progress, sounding, wetbulb

viewSound: Current version (12/4/17) of MATLAB script to display a month of soundings. Tags: in progress, soundings

wetbulb: Current version (11/27/17) of MATLAB function to calculate wetbulb temperature given pressure, dewpoint, and temperature. Uses vpasolve function to numerically evaluate the wetbulb, since the wetbulb has no closed algebraic form. Soon to be made operational. Tags: in progress, wetbulb

wetNosedetect: Current version (12/4/17) of MATLAB function to detect warmnoses in the wetbulb temperature field. Tags: in progress, wetbulb, soundings

windplot: Current version (10/30/17) of MATLAB script demonstrating wind barb plotting over time, as used in surfacePlotter. Uses windbarb function to create windbarbs. windbarb was originally written by Laura Tomkins. Full documentation still needs to be added. Tags: in progress, utilities

Quick tools

IrlHope: finds inversions, but badly

sanityCheck: adds some other soundings

viewer: loops and displays TTwvZ for a time period with little flexibility

Other files:

Station list: Annotated list of ASOS stations and sounding launches near Stony Brook University

wetSound12315: Soundings structure with wetbulb temperatures added for January, February, and March 2015. This way addWetbulb and its 45 minute runtime can be avoided as much as possible.
