% Define the parameters
close all
wavelengths = (1214:24:1550)';
ls = -11:11;
OAMmodes = [-5:-1,1:5];
purityMat = zeros(length(wavelengths),length(ls));

for oam_mode = OAMmodes
    for i = 1:length(wavelengths)
        wavelength = wavelengths(i);
        filename = strcat('beamData',num2str(wavelength),'l',num2str(oam_mode),'.mat');
        load(filename);
        x = EH.x;
        y = EH.y;
        lambda = EH.lambda;
        
        E = Ef;
        
        
        E = E.';
        % Normalize the electric field
        Ecirc = E;
        [X,Y] = meshgrid(x,y);
        R = sqrt(X.^2+Y.^2);
        Ecirc(R>max(x)) = 0;
    
        N = trapz(y, trapz(x, Ecirc .* conj(Ecirc), 2));
        E = sqrt(N^-1) * E;

        moduE = abs(E).^2;
        phaseE = angle(E);
        
        %%
        
        
        E = flipud(E); %Flip due to y-axis being positive to down direction in matlab images
        %E = E*exp(-1i*phase(E(100,100)));

        % Define the grid for the x-y plane
        [X, Y] = meshgrid(x, y); % 2D grid
        
        % Convert to polar coordinates
        [phi, r] = cart2pol(X, Y); % Azimuthal and radial coordinates
        
      
        
        rr = linspace(0,max(abs(x)),100);
        th = linspace(-pi,pi,50);
        
        Pvals = zeros(size(ls));
        
        x0s = zeros(length(rr),length(th));
        y0s = zeros(length(rr),length(th));
        aRho = zeros(size(rr));
        for iind = 1:length(rr)
            r0 = rr(iind);
            for jind = 1:length(th)
                th0 = th(jind);
                x0 = r0*cos(th0);
                y0 = r0*sin(th0);
                x0s(iind,jind) = x0;
                y0s(iind,jind) = y0;       
            end
            
        end
        m = 1;
        for l0 = ls
            E_rhoPhi = interp2(x,y,E,x0s,y0s,'spline');
            for iind = 1:length(rr)
                aRho(iind) = 1/sqrt(2*pi) * trapz(th,E_rhoPhi(iind,:).*exp(-1i*l0*th));
            end
            Pvals(m) = trapz(rr,rr.*abs(aRho).^2);
            m = m+1;
        end
        
        
        
        Pvals_norm = Pvals/(sum(Pvals));
        %Pvals(Pvals < 1e-6) = 0;
        disp('OAM mode power are [OAM mode, relative power]:'); % Display the result
        disp([ls.' Pvals_norm'])
    
        purityMat(i,:) = Pvals_norm;
        
    end
    
    save(strcat('OAMpurity_v2_','l',num2str(oam_mode)),"purityMat");

end






