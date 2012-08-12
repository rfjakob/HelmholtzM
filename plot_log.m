function [  ] = plot_log( log )
%PLOT_LOG Summary of this function goes here
%   Detailed explanation goes here

i=log.runtime;
is=1e3;
bs=1e6;
xyz='XYZ';
figure(1)
for k=1:3
    subplot(3,1,k);
    plot(i,log.field_set(:,k)*bs,'b.', i,log.field_act(:,k)*bs,'bo' ...
        , i,log.current_set(:,k)*is,'r.', i,log.current_act(:,k)*is,'ro');
    title(xyz(k));
    grid on;
    if k==1
        legend('Set field (uT)','Actual field (uT)','Set current (mA)','Actual current (mA)')
    elseif k==3
        xlabel('Runtime (seconds)');
    end
end

