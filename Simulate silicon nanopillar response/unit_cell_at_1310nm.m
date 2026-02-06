

load('radiusData1310.mat','radius','phase','Transm')

figure()
plot(2*radius*1e9,phase/(2*pi),'b-','LineWidth',3)
yyaxis left
set(gca,'FontSize',20)
set(gca,"YColor",'b')
ylim([0,1])
ylabel('Phase/2$\pi$','Interpreter','latex')
hold on
yyaxis right
plot(2*radius*1e9,Transm,'r-','LineWidth',3)
set(gca,"YColor",'r')
ylim([0,1])
xlim([min(2*radius*1e9),max(2*radius*1e9)])
ylabel('Transmission','Interpreter','latex')

y_limits = [0,1];
x_omit_start = 332;
x_omit_end = 356;
patch_x = [x_omit_start, x_omit_end, x_omit_end, x_omit_start];
patch_y = [y_limits(1), y_limits(1), y_limits(2), y_limits(2)];

% 5. Draw the patch
patch(patch_x, patch_y, 'black', ...
      'FaceAlpha', 0.2, ... % Set transparency (0=transparent, 1=opaque)
      'EdgeColor', 'none'); % No border on the patch

xlabel('Pillar diameter (nm)')
xticks(150:50:400)

