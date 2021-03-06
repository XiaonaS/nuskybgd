# nuskybgd:
## An IDL module for producing simulated background for NuSTAR.

### Overview

nuskybgd is code for simulating the NuSTAR background the Cosmix X-ray
Background (CXB). It simulates the X-rays that are focued throught the
optic as well the "stray light" from the CXB that leaks in around the
optics bench and through the aperture stop.

In /docs there is a detailed documentation and walk through. Please
read this first before attempting to use this software.

### Reference:

This code was originally written by Dan Wik, and was originally described in the
appendix of the paper here:

http://adsabs.harvard.edu/cgi-bin/bib_query?arXiv:1403.2722

If you use `nuskybgd`, please reference this paper.

### Warnings:

This code is offered "as is" for the user.

Users should be warned that using nuskbygd occasionally requires some tweaking of the scripts to work for specific cases.

If you find a problem, then please start an issue above.


### Dependencies:

Please also note that nuskbygd relies (heavily) on the [AstroLib](https://github.com/wlandsman/IDLAstro). Here we assume that you have an up-to-date version of the AstroLib and know how to put these scripts into your IDL `!path` variable.

Installation
------------

1. Clone the project from github

    `git clone https://github.com/NuSTAR/nuskybgd.git`

2. Go to the nuskybgd directory and initialize the environment variaibles

	`source initialize_nuskybgd.sh`

3. Add the the nuskybgd directory to your default IDL path.

	If you have an IDL_STARTUP file already, add the following lines to it:
	
	
	```IDL
	nuskybgd_code = getenv('NUSKYBGD')+'/pro'
	!path = expand_path('+'+nuskybgd_code)+':'+ $
                    !path
	```

	If you don't have an `IDL_STARTUP` file (i.e. if `echo $IDL_STARTUP` doesn't return anything), then create a new file somewhere (`~/idl_startup.pro`) and add the above lines to it.	
	
	Then do the following:
	
	```bash
	export IDL_STARTUP=~/idl_startup.pro
	echo "export IDL_STARTUP=~/idl_startup.pro" >> ~/.bash_profile
	```
	
	This will ensure that when you start your bash shell again that IDL will find the new IDL_STARTUP file.

4. See the [ABC Guide](ABC_Guide.md) for how to proceed.

	We generally recommend maintaining a record of your work in a separate IDL script file that can be copy and pasted to the IDL command line. `nuskbygd` is interactive enough that we do *not* generally recommend automating the analysis. 


> **NOTE**: As of 8/28/2015 the use of the 'nuabs' XSpec model has been phased out
of nuskybgd routines, so it no longer needs to be installed as a local model.
Routines now assume that the absorption has been included directly in the
response matrices. Code adjustments to address this were introduced in v0.3.

In general, this caused a % level bias at low energies, but could be important
for faint observations. The background does not have to be refit with this update;
only nuskybgd_image.pro and/or nuskybgd_spec.pro need to be rerun.
For nuskybgd_image.pro, DO NOT set the /noremakeinstr, as these files need to
be remade (but once made for a given observation, the keyword can be used again).
Please report any issues to D. Wik.

## Future work

Sometime in the (distant) future this will be ported out of IDL and into perl (for FTOOL compatibility) or python (using astropy). But this is all TBD...
