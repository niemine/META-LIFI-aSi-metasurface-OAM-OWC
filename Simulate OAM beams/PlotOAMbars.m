
% --- 1. Setup and Definitions ---
clear; 
close all; 
%clc;
% Define the parameters exactly as in the simulation
wavelengths = (1214:24:1550)';
ls = -11:11;
% Define the target modes and wavelengths for plotting
plot_modes = -2:3;
target_wavelengths = [1310, 1550];
% --- 2. Load and Prepare Data ---
% Load data for input mode l=1
load('OAMpurity_v2_l1.mat', 'purityMat');
purity_l1 = purityMat; % Rename to avoid overwriting
% Load data for input mode l=2
load('OAMpurity_v2_l2.mat', 'purityMat');
purity_l2 = purityMat; % Rename to avoid overwriting
% Find the indices (positions) of the data we need
wl_indices = find(ismember(wavelengths, target_wavelengths));
mode_indices = find(ismember(ls, plot_modes));
% Extract the relevant data slices
% For 1310 nm (first target wavelength)
purity_1310_l1 = purity_l1(wl_indices(1), mode_indices);
purity_1310_l2 = purity_l2(wl_indices(1), mode_indices);
% For 1550 nm (second target wavelength)
purity_1550_l1 = purity_l1(wl_indices(2), mode_indices);
purity_1550_l2 = purity_l2(wl_indices(2), mode_indices);
% Combine data for easy plotting with grouped bars
% Each column is a data series (l=1, l=2), each row is a mode
plot_data_1310 = [purity_1310_l1'/max(purity_1310_l1), purity_1310_l2'/max(purity_1310_l2)];
plot_data_1550 = [purity_1550_l1'/max(purity_1550_l1), purity_1550_l2'/max(purity_1550_l2)];
% --- 3. Generate Plots ---
% Figure 1: OAM Distribution at 1310 nm
h1=figure; 
bar(plot_modes, plot_data_1310);
%title('OAM Mode Purity at 1310 nm', 'FontSize', 14);
xlabel('OAM Mode', 'FontSize', 14);
ylabel('Normalized Power', 'FontSize', 14);
legend('OAM 1', 'OAM 2', 'Location', 'northwest');
grid off;
ylim([0,1])
set(gca, 'FontSize', 14);
filename_1310 = 'OAM_purity_1310nm';

savefig(h1, filename_1310)


% Figure 2: OAM Distribution at 1550 nm
h2=figure; 
bar(plot_modes, plot_data_1550);
%title('OAM Mode Purity at 1550 nm', 'FontSize', 14);
xlabel('OAM Mode', 'FontSize', 14);
ylabel('Normalized Power', 'FontSize', 14);
legend('OAM 1', 'OAM 2', 'Location', 'northwest');
grid off;
set(gca, 'FontSize', 14);
ylim([0,1])
filename_1550 = 'OAM_purity_1550nm';

savefig(h2, filename_1550)