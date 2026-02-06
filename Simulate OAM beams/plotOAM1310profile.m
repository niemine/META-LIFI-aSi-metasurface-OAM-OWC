% Clean the workspace and close any open figures
clear
close all

% --- Define the range of files to process ---
file_indices = 1:5; % Processes files for i = 1, 2, 3, 4, 5

for i = file_indices
    % 1. Construct the input filename for the current loop iteration
    input_filename = sprintf('beamData1310l%d.mat', i);

    % Check if the data file exists before trying to load it
    if ~exist(input_filename, 'file')
        fprintf('File %s not found. Skipping to the next file.\n', input_filename);
        continue; % Go to the next iteration of the loop
    end

    % 2. Load data and perform calculations
    fprintf('Processing file: %s\n', input_filename);
    load(input_filename); % Loads the 'EH' and 'Ef' variables

    x = EH.x;
    y = EH.y;
    E = Ef.'; % Transpose the electric field matrix

    % Normalize the electric field
    Ecirc = E;
    [X,Y] = meshgrid(x,y);
    R = sqrt(X.^2+Y.^2);
    Ecirc(R>max(x)) = 0;

    N = trapz(y, trapz(x, Ecirc .* conj(Ecirc), 2));
    E = sqrt(N^-1) * E;

    % Calculate the intensity (modulus squared) and phase
    moduE = abs(E).^2;
    phaseE = angle(E) + pi;

    % --- 3. Create, save, and close the PROFILE figure ---
    profile_filename = sprintf('OAM%d_profile', i);
    h1 = figure(); % Create a figure but keep it hidden

    imagesc(x*1e6, y*1e6, moduE/max(moduE(:)));
    set(gca, "FontSize", 15);
    axis image; % Ensure correct aspect ratio
    xlabel('x [micron]');
    ylabel('y [micron]');
    %title(strrep(profile_filename, '_', ' ')); % Add a title for clarity
    colormap hot;
    c=colorbar;
    c.Ticks = 0:0.2:1;

    savefig(h1,profile_filename)
    %close(h1); % Close the figure to save memory

    

    % --- 4. Create, save, and close the PHASE figure ---
    phase_filename = sprintf('OAM%d_phase', i);
    h2 = figure(); % Create another hidden figure

    imagesc(x*1e6, y*1e6, phaseE);
    set(gca, "FontSize", 15);
    axis image;
    xlabel('x [micron]');
    ylabel('y [micron]');
    %title(strrep(phase_filename, '_', ' '));
    colormap jet;
    colorbar;

    savefig(h2,phase_filename)
    %close(h2);

    
end

fprintf('--- All files processed successfully! ---\n');
