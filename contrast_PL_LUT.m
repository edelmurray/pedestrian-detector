function [ Lut ] = contrast_PL_LUT( gamma )

for i = 1:256
    Lut(i) = i-1;
end
for i = 1:256
    if (Lut(i)^gamma)/(255^(gamma-1)) < 0
        Lut(i) = 0;
    else if (Lut(i)^gamma)/(255^(gamma-1)) > 255
            Lut(i) = 255;
        else
            Lut(i) = round((Lut(i)^gamma)/(255^(gamma-1)));
        end
    end
end
Lut = uint8(Lut);

end

