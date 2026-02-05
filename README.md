METALIFI: OAM Beam Generation and Propagation with Metasurfaces
Project Overview
This repository contains the simulation scripts, design files, and analysis tools for the METALIFI project. The code implements a complete workflow for designing amorphous silicon (a-Si) metasurfaces capable of generating Orbital Angular Momentum (OAM) beams at 1310 nm design wavelength. It covers unit cell characterization using RCWA, GDSII mask generation for lithography, and broadband farfield propagation simulations to assess mode purity and optical efficiency.

Repository Structure
The code is organized into three main modules corresponding to the physical design and simulation workflow.

1. Unit Cell Design (siunitcell)
Objective: Characterize the phase and transmission response of a-Si nanopillars across a broadband wavelength range (1214–1550 nm).

Input: Silicon Nanopillar Simulation.fsp (Geometry definition).

Execution: Broadband silicon pillar phase data creation.lsf (RCWA radius sweep).

Output: radiusData[Wavelength].mat. These files contain the lookup tables required for all subsequent steps.

2. Mask Generation (gds_generation)
Objective: Generate GDSII layout files for electron-beam lithography fabrication.

Input: radiusData files from the unit cell step.

Execution: buildFabricationPatterns.lsf. This master script automates the mapping of phase profiles to pillar geometries (buildMetaSurface.lsf), vertex creation (create_vertices.lsf), and GDS writing (createGDS.lsf).

Output: [Index]_OAM_[Mode].gds files.

3. Propagation & Analysis (oam_propagation)
Objective: Simulate the full optical performance of the metasurfaces, including far-field propagation and mode decomposition.

Input: radiusData files.

Execution:

propagate_OAMbeams_broadband.lsf: Propagates fields to the far-field.

broadbandloop_power.lsf: Calculates near-field power for efficiency normalization.

Analysis (MATLAB):

calculate_OAM_purities.m: Decomposes output beams into Laguerre-Gaussian modes.

calculate_OAM_power_fractions.m: Computes transmission and propagation efficiency.

plotOAM...m: Visualization scripts.

Usage Instructions
To replicate the results, execute the scripts in the following strict order.

Step 1: Generate Unit Cell Library
Open Ansys Lumerical.

Navigate to the siunitcell folder.

Run Broadband silicon pillar phase data creation.lsf.

Note: Ensure Silicon Nanopillar Simulation.fsp is in the same directory.

Result: This generates the radiusData1310.mat, radiusData1550.mat, etc., which form the database for the metasurface design.

Step 2: Fabrication Layout (Optional)
If generating lithography masks:

Navigate to the gds_generation folder.

Run buildFabricationPatterns.lsf.

Result: GDSII files for the specified OAM modes will be created in the directory.

Step 3: Electromagnetic Simulation
Navigate to the oam_propagation folder.

Run propagate_OAMbeams_broadband.lsf.

This stitches the unit cell responses into a full lens and propagates the field.

Result: beamData[Wavelength]l[Mode].mat files containing complex far-field data.

Run broadbandloop_power.lsf.

Result: nearFieldData[Wavelength]l[Mode].mat files containing input and lens-output power data.

Step 4: Data Analysis
Open MATLAB.

Ensure the generated .mat files from Step 3 are in the MATLAB path.

Run calculate_OAM_purities.m to generate purity matrices.

Run calculate_OAM_power_fractions.m to calculate efficiency ratios.

Run the visualization scripts (e.g., plotOAMpurity.m, powerLossPlots.m) to reproduce the manuscript figures.

Software Requirements
Ansys Lumerical FDTD/RCWA (Release 2020 or newer).

MATLAB (R2021b or newer).

Metadata
Detailed metadata describing simulation parameters, physical constants, and variable definitions can be found in the _metadata.txt files located within each subfolder. Refer to these files for precise experimental conditions.
