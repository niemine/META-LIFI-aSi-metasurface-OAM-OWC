% --- 1. Setup and Definitions ---
clear; 
close all; 
clc;

% Define the simulation and plot parameters
wavelengths = (1214:24:1550)';
ls = -11:11;          
input_modes = 1:5;  

% Define the wavelength ranges for the two plots
wl_range_1310 = 4:8;  
wl_range_1550 = 11:15; 

% --- DEFINING MARKERS ---
% A list of distinct markers to cycle through: 
% Circle, Square, Diamond, Triangle Up, Triangle Down
markers = {'o', 'v', '*', 'x', 'square'}; 

% --- 2. Create and Prepare Figures ---
h_fig1 = figure;
ax1 = gca;
hold(ax1, 'on'); 

h_fig2 = figure;
ax2 = gca;
hold(ax2, 'on'); 

% --- 3. Loop Through OAM Modes ---
counter = 1; % Initialize a counter to pick the marker

for l_in = input_modes
    % Find the COLUMN index for the mode purity we want.
    mode_col_idx = find(ls == l_in);
    
    % --- Load Purity Data ---
    filename_purity = sprintf('OAMpurity_v2_l%d.mat', l_in);
    if ~exist(filename_purity, 'file')
        warning('Purity file %s not found. Skipping.', filename_purity);
        continue;
    end
    load(filename_purity, 'purityMat');
    
    % --- Load Power Ratio Data ---
    filename_power = sprintf('powerLoss_l%d.mat', l_in);
    if ~exist(filename_power, 'file')
        warning('Power file %s not found. Skipping.', filename_power);
        continue;
    end
    load(filename_power, 'powerRatioVector');
    
    % --- Calculate Total Optical Efficiency ---
    current_mode_purity = purityMat(:, mode_col_idx);
    total_efficiency = current_mode_purity .* powerRatioVector;

    % --- Select the marker for this loop iteration ---
    current_marker = markers{counter};

    % --- Plot on Figure 1 (1310 nm range) ---
    % Notice the 'Marker' property is now dynamic
    plot(ax1, wavelengths(wl_range_1310), total_efficiency(wl_range_1310) * 100, ...
         '-', 'Marker', current_marker, 'MarkerSize', 8, 'LineWidth', 2);
         
    % --- Plot on Figure 2 (1550 nm range) ---
    plot(ax2, wavelengths(wl_range_1550), total_efficiency(wl_range_1550) * 100, ...
         '-', 'Marker', current_marker, 'MarkerSize', 8, 'LineWidth', 2);
     
    % Increment counter for the next mode
    counter = counter + 1;
end

% --- 4. Finalize and Format the Plots ---

% Define the legend entries using LaTeX
legend_entries = {'$\ell=1$', '$\ell=2$', '$\ell=3$', '$\ell=4$', '$\ell=5$'};

% Format Figure 1 (1310 nm)
xlabel(ax1, 'Wavelength (nm)');
ylabel(ax1, 'Total Efficiency [%]');
xline(ax1, 1310, 'k--', 'LineWidth', 1.5);
ylim(ax1, [0, 100]);
grid(ax1, 'on');
legend(ax1, legend_entries, 'Location', 'best', 'Interpreter', 'latex'); 
set(ax1, 'FontSize', 14);
xlim(ax1, [min(wavelengths(wl_range_1310)), max(wavelengths(wl_range_1310))]);

% Format Figure 2 (1550 nm)
xlabel(ax2, 'Wavelength (nm)');
ylabel(ax2, 'Total Efficiency [%]');
ylim(ax2, [0, 100]);
grid(ax2, 'on');
legend(ax2, legend_entries, 'Location', 'best', 'Interpreter', 'latex');
set(ax2, 'FontSize', 14);
xlim(ax2, [min(wavelengths(wl_range_1550)), max(wavelengths(wl_range_1550))]);

% --- 5. Save the Figures ---
filename1 = 'OAM_OpticalEfficiency_1310nm_Range';  
savefig(h_fig1, filename1)

filename2 = 'OAM_OpticalEfficiency_1550nm_Range';    
savefig(h_fig2, filename2)

fprintf('Figures saved as %s and %s.\n', filename1, filename2);