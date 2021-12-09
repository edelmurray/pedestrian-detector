function [ Lut ] = contrast_LS_LUT( m, c )

for i = 1:256
    Lut(i) = i-1;
end
for i = 1:256
    if Lut(i)*m+c < 0
        Lut(i) = 0;
    else if Lut(i)*m+c > 255
            Lut(i) = 255;
        else
            Lut(i) = Lut(i)*m+c;
        end
    end
end
Lut = uint8(Lut);

end

