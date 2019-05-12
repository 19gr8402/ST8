function [BOLDsequence]=BOLD_filter(BOLDsequence,showPlots)

Fs = 1;             % Sampling frequency                    
T = 1/Fs;           % Sampling period       
L = 450;            % Length of signal
t = (0:L-1)*T;       % Time vector


%Cutt off
fc= 0.05;

for compartment = 1:size(BOLDsequence,2)
    
x= BOLDsequence(compartment).Seg;
x_zeromean= x-mean(x);

filtered = lowpass(x_zeromean,fc,Fs);
BOLDsequence(compartment).filt = filtered+mean(x);

if (showPlots)
  figure;
  subplot(3,2,compartment)
  plot(BOLDsequence(compartment).filt)
  title(sprintf('Filtered BOLD response, compartment %i', compartment));
end

end
end