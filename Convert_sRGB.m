function srgbmat = Convert_sRGB(rgbmat)
	srgbmat = zeros(size(rgbmat));
	linear_zone = (rgbmat <= .04045);
	srgbmat( linear_zone) =   rgbmat( linear_zone) / 12.92;
	srgbmat(~linear_zone) = ((rgbmat(~linear_zone) + .055) / 1.055) .^ 2.4;
end