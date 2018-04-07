classdef ringModPlugin < audioPlugin
    %Ringmodulator based on Parker's Simplified model from the paper:
    %Julian Parker, A Simple Digital Model of the Diode-Based
    %Ring-Modulator, Proc. of the 14th International Conference on Digital
    %Audio Effects (DAFx-11), 2011
    
    properties %properties for the non-linear function and the wet/dry mix
        %DISCLAIMER: vb must be lower than vl
        vb  = 0.2;
        vl = 0.4;
        h = 1;
        mix = 0.5;
    end
    
    properties (Dependent) %Properties for the audio oscillator
        ff = 440
        AMP = 1
        
    end
    
    properties (Constant)
        PluginInterface = audioPluginInterface( ...
            audioPluginParameter('AMP','DisplayName','Mod Amplitude', 'Mapping',{'lin',0,1}), ...
            audioPluginParameter('ff','DisplayName','Mod Frequency', 'Mapping',{'log',44,8800}) , ...
            audioPluginParameter('vb','DisplayName','VB', 'Mapping',{'lin',1/10,4/10}), ...
            audioPluginParameter('vl','DisplayName','VL', 'Mapping',{'lin',4/10,8/10}), ...
            audioPluginParameter('h','DisplayName','Distortion', 'Mapping',{'lin',1,20}), ...
            audioPluginParameter('mix','DisplayName','Wet/Dry Mix', 'Mapping',{'lin',0,1}), ...
            'OutputChannels',2)
    end
    
    properties (Access = private)
        %declare the oscillator as an object
        pOSC;
    end
    
    methods
        function obj = ringModPlugin()
            obj.pOSC = audioOscillator('sine');
            obj.pOSC.SampleRate = 44100;
            
        end
        
        % We need to implement setters/getters (accessors) for Dependent properties.
        function set.ff(obj, val)
            obj.pOSC.Frequency = val;
        end
        
        function val = get.ff(obj)
            val = obj.pOSC.Frequency;
        end
        
        function set.AMP(obj, val)
            obj.pOSC.Amplitude = val;
        end
        
        function val = get.AMP(obj)
            val = obj.pOSC.Amplitude;
        end
        % End of accessors to ensure that slider values processed.
        
        function out = process (plugin, in)
            plugin.pOSC.SamplesPerFrame = size(in,1); %set the sample size of the oscillator based on the input frame
            sinewave = plugin.pOSC();
            output = zeros(size(in));
            
            for n = 1:size(in,2) %Loop for given number of audio channels
                for i = 1:length(in)
                    %In this loop the structure of the simplified ring
                    %modulator model is implemented
                    
                    %Vc is the input sound
                    Vc = in(i,n);
                    %Vin is the modulating sinewave
                    Vin = sinewave(i) * 0.5;
                    
                    n1 = Vin + Vc;
                    n2 = Vc - Vin;
                    
                    %The non-linearity is calculated in function diodeC
                    D1 = diodeC(n1,plugin.vb,plugin.vl,plugin.h);
                    D2 = diodeC(-n1,plugin.vb,plugin.vl,plugin.h);
                    
                    D3 = diodeC(n2,plugin.vb,plugin.vl,plugin.h);
                    D4 = diodeC(-n2,plugin.vb,plugin.vl,plugin.h);
                    
                    nD12 = D1+D2;
                    nD34 = -(D3+D4);
                    
                    output(i,n) = nD12 + nD34;
                end
            end
            out = output * plugin.mix + in * (1 - plugin.mix);
        end
    end
    
end