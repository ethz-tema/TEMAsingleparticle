# TEMAsingleparticle

Open-source license (http://doi.org/10.5905/ethz-1007-363) 

 1.	Introduction
 
NanoFinder program designed for the sp-ICP-TOFMS user who wants to analysis transient signal (normally Nanoparticle, droplet or cell) for multi element and multi transient events simultaneously. For simplicity we going to stick to nanoparticle signal from now on here, however the same principle are also true for other transient signal. For the better understanding of the terms and abbreviations please refer to our publications listed at the end.<sup>1-4</sup>
In order to achieve the full picture, the raw data have to goes through 5 
Detection:
a)	Select elements and isotopes of interest, generate time traces of selected elements
b)	Determine critical value (LC) expressions based on compound-Poisson modelling
c)	Determine background (dissolved signal) count rates (λbkgd) for all elements
d)	Background subtract all time traces
e)	Correct all time traces for split events
f)	Find NP signals above the single-particle critical value (Lc,sp)

Concurrency: 
a)	Correct data set for particle-coincidence to remove spurious mmNP signals caused by concurrent measurement of two or more discrete particles with unique element fingerprints
Calibration:
a)	Find microdroplet/Reference nanoparticle and or dissolve standard signals
b)	Determine mass sensitivities for each element i (Sdrop,i) and sample flow rate to instrument (qplasma)
Clustering:
a)	Quantify elemental masses from detectable individual NP signals 
b)	Perform hierarchical clustering analysis of mmNP signals; discovery of conserved and non-conserved mmNP types
c)	Quantify detectable PNCs of both smNPs and mmNPs
d)	Report smNP and mmNP data

Except calibration step which needed for user to enter values from their calculation or using the complimentary software in our package DropCalib (release in 2022) the rest of the calculation done centrally in this program. Unlike the calibration steps which is user dependent and sometime need more care. The rest of the process could be done on an autonomous fashion as you will see here.

2.	Installation

You need to run the Setup.exe file form the package to installed “NanoFInder.exe” and its host software “Matlab_Runtime”. the setup file automatically downloads the free version of “Matlab_Runtime” for its installation. You do not need to have Matlab license for using this program. The only requirment is Microsoft EXCEL 2007 or later versions.

3.	Workflow

For better understanding we represent a simple example of two data files we already collect. One sample has only gold particle and the other one has Gold and silver core-shell particles. The data files are as Comma separated value (csv) But you could also use Tofwerk icpTOF HDF5(.h5).

To run this program:
a)	Place a meta_data_excel_file (MDEF) to the same directory as your raw data files.
b)	Fill the MDEF as explain in the following section.
c)	Open the NanoFinder.exe program. In the user interface of the program select the required analysis.
d)	When you ready press Run. Then there will be a pop-up file browser which need to be directed to the MDEF file.
e)	Depending on the type of the process and number of sample the program starts to run through your data and show you the progress in the user interface and in the pop-up figures.
f)	When the processed lamp next to Run bottom in the user interface turns green, it means that the program run is completed.
g)	Result are save in the same directory with different file extension such xlsx, csv, pdf, fig and etc. depending on your analysis.

References:

1. K. Mehrabi, R. Kaegi, D. Gunther and A. Gundlach-Graham, Emerging investigator series: Automated Single-Nanoparticle Quantification and Classification: A Holistic Study of Particles into and out of Wastewater Treatment Plants in Switzerland, Environ. Sci.: Nano, 2021, DOI: 10.1039/D0EN01066A.
2. A. Gundlach-Graham, L. Hendriks, K. Mehrabi and D. Gunther, Monte Carlo Simulation of Low-Count Signals in Time-of-Flight Mass Spectrometry and Its Application to Single-Particle Detection, Anal. Chem., 2018, 90, 11847-11855.
3. A. Gundlach-Graham and K. Mehrabi, Monodisperse microdroplets: a tool that advances single-particle ICP-MS measurements, J. Anal. At. Spectrom., 2020, 35, 1727-1739.
4. K. Mehrabi, D. Gunther and A. Gundlach-Graham, Single-particle ICP-TOFMS with online microdroplet calibration for the simultaneous quantification of diverse nanoparticles in complex matrices, Environmental Science-Nano, 2019, 6, 3349-3358.
