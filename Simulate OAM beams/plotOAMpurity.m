% --- 1. Setup and Definitions ---
clear; 
close all; 
clc;

% Define the simulation and plot parameters
wavelengths = (1214:24:1550)';
ls = -11:11;          % The full range of OAM modes calculated
input_modes = 1:5;  % The modes we will loop through and plot

% Define the wavelength ranges for the two plots
wl_range_1310 = 4:8;  % Corresponds to 1286 nm to 1358 nm
wl_range_1550 = 11:15; % Corresponds to 1454 nm to 1550 nm

% --- 2. Create and Prepare Figures ---

% Create the first figure for the 1310 nm range
h_fig1 = figure;
ax1 = gca;
hold(ax1, 'on'); % Allow multiple plots on this axis

% Create the second figure for the 1550 nm range
h_fig2 = figure;
ax2 = gca;
hold(ax2, 'on'); % Allow multiple plots on this axis

% --- 3. Loop Through OAM Modes and Plot Data ---

for l_in = input_modes
    % Find the COLUMN index for the mode purity we want.
    mode_col_idx = find(ls == l_in);
    
    % Construct the filename and load the data
    filename = sprintf('OAMpurity_v2_l%d.mat', l_in);
    
    if ~exist(filename, 'file')
        warning('File %s not found. Skipping.', filename);
        continue;
    end
    load(filename, 'purityMat');
    
    % --- Plot on Figure 1 (1310 nm range) ---
    % 'DisplayName' has been removed from here.
    plot(ax1, wavelengths(wl_range_1310), purityMat(wl_range_1310, mode_col_idx) * 100, ...
         '.-', 'MarkerSize', 25, 'LineWidth', 2);
         
    % --- Plot on Figure 2 (1550 nm range) ---
    plot(ax2, wavelengths(wl_range_1550), purityMat(wl_range_1550, mode_col_idx) * 100, ...
         '.-', 'MarkerSize', 25, 'LineWidth', 2);
end

% --- 4. Finalize and Format the Plots ---

% Define the legend entries manually
legend_entries = {'OAM 1', 'OAM 2', 'OAM 3', 'OAM 4', 'OAM 5'};

% Format Figure 1 (1310 nm)
xlabel(ax1, 'Wavelength (nm)');
ylabel(ax1, 'Mode Purity [%]');
xline(ax1, 1310, 'k--', 'LineWidth', 1.5);
ylim(ax1, [0, 100]);
grid(ax1, 'on');
legend(ax1, legend_entries, 'Location', 'best'); % Use the manual legend
set(ax1, 'FontSize', 14);
xlim(ax1,[min(wavelengths(wl_range_1310)),max(wavelengths(wl_range_1310))]);

% Format Figure 2 (1550 nm)
xlabel(ax2, 'Wavelength (nm)');
ylabel(ax2, 'Mode Purity [%]');
%xline(ax2, 1550, 'k--', 'LineWidth', 1.5);
ylim(ax2, [0, 100]);
grid(ax2, 'on');
legend(ax2, legend_entries, 'Location', 'best'); % Use the manual legend
set(ax2, 'FontSize', 14);
xlim(ax2,[min(wavelengths(wl_range_1550)),max(wavelengths(wl_range_1550))]);

% --- 5. Save the Figures in Multiple Formats ---

% Save Figure 1
filename1 = 'OAM_Purity_1310nm_Range';
savefig(h_fig1, filename1)

% Save Figure 2
filename2 = 'OAM_Purity_1550nm_Range';
savefig(h_fig2, filename2)

