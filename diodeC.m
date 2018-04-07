function [ value ] = diodeC(v,vb,vl,h)

%vb = 0.2; %diode forward bias voltage
%vl = 0.4; %voltage beyond which the function is linear

%h is the slope of the linear section of the curve. Increasing the curve,
%will increase the distortion. We therefore use the distortion input value
%for h.
%h = dist;


%the following non-linear function is taken from the paper:
%Julian Parker, A Simple Digital Model of the Diode-Based
%Ring-Modulator, Proc. of the 14th International Conference on Digital
%Audio Effects (DAFx-11), 2011

if(v <= vb)
    value = 0;
elseif((vb < v) && (v <= vl))
    value = h * (((v-vb)^2)/(2 * vl - 2 * vb));
else
    value = h * v - h * vl + (h * (((vl-vb)^2) / (2*vl-2*vb)));
end

end

