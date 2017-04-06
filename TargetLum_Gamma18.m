function target_lum = TargetLum_Gamma18()
	target_lum = repmat(linspace(0, 1, 256)' .^ 1.8, 1, 3);
end