function [ Iout ] = enhanceContrastHE( Iin )


Lut = contrast_HE_LUT(Iin);
Iout = intlut(Iin, Lut);

end