%This is the implementation of the structure of Julian Parkers simple diode
%based ring modulator:
%Julian Parker, A Simple Digital Model of the Diode-Based
%Ring-Modulator, Proc. of the 14th International Conference on Digital
%Audio Effects (DAFx-11), 2011

[input fs] = audioread('roy.wav');
%uncomment the bottom command if input sound is longer than 192000 samples
%input = input(1:192000,1); 

osc = audioOscillator('sine')
osc.Frequency = 220;
osc.Amplitude = 1;
osc.SampleRate = 44100;
osc.SamplesPerFrame = length(input);
mod = osc();

vb = 0.2; %vb is the parameter for the diode forward bias voltage
vl = 0.4; %vl is the paramter for the voltage beyond which the function is linear
%voltage starts from vb, and becomes linear afer vl
h = 1; %is the slope of the wave shape curve

mix = 1;

for i = 1:length(input)
    
    Vc = input(i);
    Vin = mod(i) * 0.5;
    
    n1 = Vin + Vc;
    n2 = Vc - Vin;
    
    D1 = diodeC(n1,vb,vl,h);
    D2 = diodeC(-n1,vb,vl,h);
    
    D3 = diodeC(n2,vb,vl,h);
    D4 = diodeC(-n2,vb,vl,h);
    
    nD12 = D1+D2;
    nD34 = -(D3+D4);
    
    output(i) = nD12 + nD34;
end

out = output * mix;

soundsc(out,fs);