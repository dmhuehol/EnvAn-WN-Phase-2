# EnvAn-WN Phase 2
Basic description: MATLAB functions and scripts for sounding and surface conditions analysis, used primarily for the northeast US winter storms project at Environment Analytics.

All files were created by Daniel Hueholt at North Carolina State University unless otherwise specified.

File descriptions:

abacusDemo: Demonstrates abacus plots, the plot style used to plot ASOS precipitation type data versus time in surfacePlotter.

addaxis: Functions to add multiple axes to a plot. Written by Harry Lee; found on the MATLAB file exchange.
Original link: https://www.mathworks.com/matlabcentral/profile/authors/863384-harry-lee

addDewRH: Adds calculated dewpoint and/or relative humidity fields to a soundings data structure, as long as that structure includes dewpoint depression measurements.

addHeight: Adds a calculated geopotential height field to a soundings structure.

addWetbulb: Adds a calculated wetbulb field to a soundings structure. Runtime can be extremely long.

ASOSdownloadFiveMin: Downloads Automated Surface Observation System (ASOS) five-minute data from the NCDC database.

ASOSgrabber: Enables browsing of ASOS structures by grabbing a section of data from a structure around a given input time.

ASOSimportFiveMin: Imports five-minute ASOS data into MATLAB given an input file.

ASOSimportOneMin: Imports one-minute ASOS data into MATLAB given an input file. Output is not particularly well optimized, as one-minute data did not end up being an effective data source for this project.

CCOWindProfile: Plot wind profiles through the atmosphere. Written by Laura Tomkins (github @lauratomkins) in May 2017.

cloudbaseplot: Plot cloud base as estimated from sounding relative humidity observations. KNOWN TO BE NOT EFFECTIVE: from a function writing perspective superseded by findTheCloud + cloudplot, but also based on some incorrect assumptions regarding the relative humidity/cloud relationship that will be resolved in Phase 3.

cloudplot: Plot cloud given vertical coordinates of the cloud layers.

compositeDemo: Demonstration of composite temperature+wetbulb versus height plots using hard-coded data. See compositePlotter for actual operational version of this.

compositePlotter: Plots composites of wetbulb and/or air temperature versus height.

convection: Calculates convective parameters given an input sounding. Currently only calculates K-index and Total Totals Index.

datetickzoom: Function which expands on datetick so the ticks update at different zoom levels, originally written by Christophe Lauwerys. Link: https://www.mathworks.com/matlabcentral/fileexchange/15029-datetickzoom-automatically-update-dateticks

dewrelh: Calculates dew point and relative humidity from temperature and dew point depression.

embemo: Demonstrates visualization of ASOS data using a toy dataset. Requires plotyyy.

embemo2014bOrNewer: Identical to embemo, but uses the colorbar object which is only available starting in MATLAB 2014b.

extractWarmCloud: Extracts heights, temperature, and wetbulb temperatures corresponding to heights that are various combinations of in cloud, above freezing, and above freezing in the wetbulb temperature. Works as written, but revealed that height-matching would not work, leading to the use of polyxpoly in findTheCloud.

findsnd: Find the index number corresponding to a particular date and time within a soundings data structure.

findTheCloud: Finds cloud layers within a sounding for a given time, outputting the upper and lower bounds for use by cloudplot. Uses threshold relative humidity values to locate cloud, which is known to be a relatively poor method of locating cloud. Will be resolved in Phase 3.

fullIGRAimp: Imports IGRA v1 data and applies multiple processing methods from other functions, outputting a new sounding structure associated with each modification to the data structure. Requires IGRAimpf, timefilter, levfilter, addDewRH, dewrelh, surfconfilter, nosedetect, prestogeo, simple_prestogeo

IGRAimpf: Creates a structure of soundings data from raw Integrated Global Radiosonde Archive v1 .dat data. (Based on part of a script originally written by Megan Amanatides.)

levfilter: Removes an input level type from a soundings data structure.

mesowestDecoder: Decodes present weather codes from Mesowest data.

newtip: Creates a custom Data Cursor tooltip using variables from within a parent function. Must be nested within another function. This version of newtip is specifically designed to work with wnAllPlot and wnYearPlot, but the method could easily be adapted for any similar circumstance.

nosedetect: Separates a soundings data structure into warm nose and non warm nose structures, with the warm nose structure containing a nested structure with details about said noses. Effective at what it does, but has many underlying problems: only detects layers above freezing, does not look specifically for inversions, does not have enough categories to accurately represent real profiles, terminology used inside the function is obsolete.

plotyyy: Plots data using three y-axes. Small changes made to original function written by Denis Gilbert of the Maurice Lamontagne Institute. Link to original function: https://www.mathworks.com/matlabcentral/fileexchange/1017-plotyyy

precipfilter: Filters a soundings data structure by the presence of precipitation at the surface, as shown in Mesowest data adjacent in time to the soundings in the input structure.

precipfilterASOS: Filters a soundings data structure by whether precipitation was occurring near the time of the sounding, as determined by ASOS 5-minute observations.

prestogeo: Calculates geopotential height given pressure and temperature. Includes a variety of bonus options which make it easier to use with other functions; for a bare-bones geopotential height calculator, see simple_prestogeo. Equation comes from Durre and Yin (2008) http://journals.ametsoc.org/doi/pdf/10.1175/2008BAMS2603.1 

rangebardemo: Demonstration of the “stacked” and “patch" methods to make ranged bar charts.

rhumplot: Generate a figure with charts of relative humidity vs pressure and relative humidity vs height from input sounding number and sounding data structure.

RHvZ: Makes a simple plot of relative humidity vs height.

simple_prestogeo: Calculates geopotential height given pressure and temperature. This is a no-frills calculator; see prestogeo for a calculator designed to interface with other functions.

skewT: Generate a skew-T chart given information for input humidity, temperature, pressure, and dewpoitn data. Adapted from code found at MIT OpenCourseware. Link to original site:
https://ocw.mit.edu/courses/earth-atmospheric-and-planetary-sciences/12-811-tropical-meteorology-spring-2011/tools/

skewtIGRA: Generate a skew-T chart for an input sounding. Adapted from code originally found at MIT OpenCourseware. Link to original site: https://ocw.mit.edu/courses/earth-atmospheric-and-planetary-sciences/12-811-tropical-meteorology-spring-2011/tools/

soundplots: Generates a variety of figures (TvZ, TvP, RHvZ, RHvP, skew-T) based on soundings data for a specific time and date. Requires: dewrelh, skewtIGRA, rhumplot

surfacePlotter: Visualizes ASOS five-minute surface conditions data on two figures: one displaying temperature, pressure, dewpoint, humidity, wind, and wind character; the second is an abacus plot of precipitation type. Requires external functions addaxis, tlabel, and windbarb. addaxis was originally written by Harry Lee, tlabel by Carlos Adrian Vargas Aguilera, and windbarb by Laura Tomkins. Tags: ASOS, surface observations
addaxis original link: https://www.mathworks.com/matlabcentral/fileexchange/9016-addaxis
tlabel original link: https://www.mathworks.com/matlabcentral/fileexchange/19314-tlabel-m-v2-6-1--sep-2009-
Laura Tomkins can be found on github @lauratomkins

surfAnalysisDemo: Demonstrates the creation of a local surface analysis using toy data. Development on surface analysis functions beyond this has been delayed to Phase 3.

surfconfilter: Filters a soundings data structure based on surface  relative humidity and/or temperature.

surfconfind: Finds row index of Mesowest data table corresponding to an input time. Can also return the section of said table which contains the index and its surrounding entries, with the number of surrounding entries controllable by the user.

timefilter: Removes input years and months from a sounding structure.

tlabel: External function to improve on datetick and datetickzoom. Written by Carlos Adrian Vargas Aguilera, found on the MATLAB file exchange. Original link: https://www.mathworks.com/matlabcentral/fileexchange/19314-tlabel-m-v2-6-1--sep-2009-

TTwvZ: Plots temperature and wetbulb temperature against height given an input time and soundings data structure.

TvZ: Plots temperature vs height from soundings data given an input time.

TvZbasic: Plots temperature vs height from soundings data given an input time, with figure settings set up for maximum ease in customization. Renamed from TvZprint in final push.

viewer: Sequentially displays all soundings for an input span of time in either temperature vs height or temperature+wetbulb vs height format. Block of code to save all images is commented out. Suffers from the issue that prestogeo has when the first entry in a soundings temperature vector is NaN and therefore geopotential height cannot be calculated. In Phase 3, this function (and likely all vZ functions) will be changed to use the geopotential field included in IGRA v2 data.

weatherCodeSearch: Locates all times that an input weather code is observed in an ASOS data structure.

wetbulb: Numerically evaluates the wetbulb temperature given dewpoint, pressure, and temperature.

wetNosedetect: Functions exactly as nosedetect, but for wetbulb temperature.

windbarb: Plots wind barbs. Written by Laura Tomkins (github @lauratomkins) in May 2017.

windbarbForSurfAn: Very lightly modified version of windbarb to make it plot correctly on ASOS surface analyses. windbarb function was written by Laura Tomkins (github @lauratomkins) in May 2017.

windplot: Demonstrates how to make a wind barb time series as used in surfacePlotter. Requires windbarb. windbarb function was written by Laura Tomkins (github @lauratomkins) in May 2017.

wnAllPlot: Displays various kinds of warm nose plots based off a soundings structure containing warm nose data. Uses the stacked method for ranged bar graphs, which causes problems in representing some kinds of warm noses.

wnplot: Creates warm nose plots for individual soundings given an input time and soundings data. Uses the patch method for ranged bar graphs; accurately displays all warm noses that nosedetect properly represents.

wnplot_poster: Creates warm nose plots for individual soundings given an input time and soundings data. Uses the patch method for ranged bar graphs; accurately displays all warm noses that nosedetect properly represents. Aesthetics are slightly different than wnplot in ways that optimize the figures for poster printing.

wnumport: Creates a structure of surface observations data given a raw Mesowest csv file.

wnYearPlot: Creates warm nose plots for an input year. Uses the stacked method for ranged bar graphs, which causes problems in representing some kinds of warm noses.

Nonfunctional, but retained:

newNoseDetect: Attempt to create a new function to detect warm noses; method did not work and development was abandoned.

noseplotfind: Supposed to detect and display warm noses within a dataset; written badly and essentially superseded by viewer.

numwarmnose: Script to divide up soundings data by the number and type of warm noses present. Has the same underlying problems as nosedetect and other "nose" software.

represamWn: Make composite wetbulb vs height plots for input soundings; superseded by compositePlotter.

sanityPlea: temporary file storing a few commands

Other files:

license.txt: License accompanying addaxis and its related functions.

Readme.txt: Readme file associated with the addaxis6 functions listing recent modifications and some other notes.

Station list.txt: Annotated list of ASOS stations and sounding launches near Stony Brook University

wetBIS.mat: IGRA v1 soundings data from Bismarck, ND, including wetbulb temperature. Has errors that make it difficult to use for any large-scale projects.

wetNose.mat: 2015-2016 winter soundings, processed for wetbulb temperature and for warm noses, although not for wetbulb warm noses.

wetSound1231516: Soundings structure with wetbulb temperatures added for January, February, and March 2015 and 2016. This way addWetbulb and its 45 minute runtime can be avoided as much as possible.

wetSound111214: Soundings from November-December 2014 processed for wetbulb temperature.
