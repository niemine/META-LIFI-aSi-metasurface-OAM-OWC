% --- Setup and Definitions ---
clear; 
close all; 

% Define the range of wavelengths and OAM modes
wavelengths = (1214:24:1550)';
OAMmodes = [-5:-1, 1:5];

% Loop through each OAM mode
for oam_mode = OAMmodes
    fprintf('Processing OAM mode %d...\n', oam_mode);
    
    % Initialize a vector to store the power ratio for this mode across wavelengths
    % This will correspond to the column for this specific mode
    powerRatioVector = zeros(length(wavelengths), 1);
    
    % Loop through each wavelength
    for i = 1:length(wavelengths)
        wavelength = wavelengths(i);
        
        % ---------------------------------------------------------
        % 1. Load Near-Field Data (Input and Lens Output)
        % ---------------------------------------------------------
        nearFieldFile = sprintf('nearFieldData%dl%d.mat', wavelength, oam_mode);
        
        if ~exist(nearFieldFile, 'file')
            warning('File %s not found. Skipping.', nearFieldFile);
            powerRatioVector(i) = NaN;
            continue;
        end
        
        % Load the file into a structure 'dataNF' to avoid workspace clutter
        dataNF = load(nearFieldFile);
        
        % Extract coordinates from the dataset structure
        if isfield(dataNF, 'lensNearField')
            xnear = dataNF.lensNearField.x;
            ynear = dataNF.lensNearField.y;
        else
            error('Structure lensNearField not found in %s', nearFieldFile);
        end
        
        % Extract the pre-processed field components exactly as requested
        % We assume 'En' and 'E_inputn' are variables saved directly in the .mat file
        if isfield(dataNF, 'En') && isfield(dataNF, 'E_inputn')
            En = dataNF.En;
            E_inputn = dataNF.E_inputn;
            
            % Apply the 0.5 factor as per your snippet
            Enear = 0.5 * En;
            Einput = 0.5 * E_inputn;
        else
            warning('Variables En or E_inputn not found in %s', nearFieldFile);
            powerRatioVector(i) = NaN;
            continue;
        end
        
        % Calculate Power in Near Fields
        % Ninput: Power of input Gaussian
        % Nnear: Power after metasurface (includes transmission loss)
        Ninput = trapz(ynear, trapz(xnear, Einput .* conj(Einput), 2)); 
        Nnear  = trapz(ynear, trapz(xnear, Enear .* conj(Enear), 2)); 
        
        % Calculate Metasurface Loss (Transmittance)
        MetaLoss = Nnear / Ninput;
        
        % ---------------------------------------------------------
        % 2. Load Propagated Beam Data (Far/Propagated Field)
        % ---------------------------------------------------------
        beamFile = sprintf('beamData%dl%d.mat', wavelength, oam_mode);
        
        if ~exist(beamFile, 'file')
            warning('File %s not found. Skipping.', beamFile);
            powerRatioVector(i) = NaN;
            continue;
        end
        
        dataBeam = load(beamFile); % Loads variables like EH and Ef
        
        if isfield(dataBeam, 'Ef') && isfield(dataBeam, 'EH')
            x = dataBeam.EH.x;
            y = dataBeam.EH.y;
            Ef = dataBeam.Ef;
            
            % Prepare propagated field 
            E = Ef.'; 
            
            % Calculate Power of Propagated Field
            N = trapz(y, trapz(x, E .* conj(E), 2)); 
            
            % Calculate Ratio: Propagated Power / Near Field Power
            Ratio = N / Nnear;
            
            % Calculate Total Efficiency
            RatioTot = Ratio * MetaLoss;
            
            % Store the result
            powerRatioVector(i) = RatioTot;
            
        else
             warning('Variables Ef or EH not found in %s', beamFile);
             powerRatioVector(i) = NaN;
        end
        
    end
    
    % --- Save Result for Current OAM Mode ---
    % Saves a file named powerLoss_l<mode>.mat containing the vector and wavelength list
    outputFilename = sprintf('powerLoss_l%d.mat', oam_mode);
    save(outputFilename, 'powerRatioVector', 'wavelengths');
    fprintf('Saved %s\n', outputFilename);
    
end

disp('All power calculations completed.');