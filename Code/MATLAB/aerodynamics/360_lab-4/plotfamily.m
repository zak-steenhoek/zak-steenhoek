%PLOTFAMILY plots the lift curve and drag polar for a specified winglet
% family. Some args are optional and have default values

function [familydata,nonedata] = plotfamily(familydata,nonedata,figrange)
% If no custom range, default 1,2
if isempty(figrange)
    figrange = [1,2];
end
% Default krb line specs
famSpecs = {'k.-','b.-','r.-'};
noneSpec = 'k.-.';
% famSpecs = {'r.-','g.-','b.-'};
% noneSpec = 'k.-';

figDir = ['C:\Users\zaste\OneDrive\Documents\Software\MATLAB\AEE360\' ...
    'Lab-4\figures\best\krbk-\'];

% Get and parse name
famName = inputname(1);
parts = split(famName, '_');
fam = parts{1};
rey = parts{2};
subtitle = {strjoin({'Winglet family:', fam}, ' '), ...
    strcat(strjoin({'Approx. reynold number:', rey}, ' '),'k')};

% Lift slope
figure(figrange(1)); clf; hold on; grid on;
title('Lift Coefficient vs. Pitch Angle', subtitle);
xlabel('Pitch angle (deg)'); ylabel('Lift Coefficient (dimless)');
errorbar(nonedata.data(:,1), nonedata.data(:,2), nonedata.data(:,4), noneSpec)
for i = 1:3
    errorbar(familydata(i).data(:,1),familydata(i).data(:,2), ...
        familydata(i).data(:,4), famSpecs{i});
end
legend(nonedata.winglet, familydata(1).winglet, familydata(2).winglet, ...
    familydata(3).winglet, 'Location','best');
xlim([-15 20]); ylim([-0.4 0.8]);
hold off;

q = findobj('type','figure');
figTitle = strjoin({'Lab4_liftslope',famName},'_');
% autosave(q, figTitle, figDir, 'png', false)

% Drag polar
figure(figrange(2)); clf; hold on; grid on;
title('Drag Polar', subtitle);
xlabel('Drag Coefficient (dimless)'); ylabel('Lift Coefficient (dimless)');
plot(nonedata.data(:,3), nonedata.data(:,2), noneSpec);
% errorbar(nonedata.data(:,3), nonedata.data(:,2), nonedata.data(:,4)./2, ...
%  nonedata.data(:,4)./2, nonedata.data(:,5)./2, nonedata.data(:,5)./2, noneSpec)
for i = 1:3
    plot(familydata(i).data(:,3),familydata(i).data(:,2),famSpecs{i});
    % errorbar(familydata(i).data(:,3),familydata(i).data(:,2), ...
    %     familydata(i).data(:,4)./2, familydata(i).data(:,4)./2, ...
    %     familydata(i).data(:,5)./2, familydata(i).data(:,5)./2, famSpecs{i});
end
legend(nonedata.winglet, familydata(1).winglet, familydata(2).winglet, ...
    familydata(3).winglet, 'Location','best');
xlim([0 0.2]); ylim([-0.4 0.8]);
hold off;

q = findobj('type','figure');
figTitle = strjoin({'Lab4_dragpolar',famName},'_');
% autosave(q, figTitle, figDir, 'png', false)
end

