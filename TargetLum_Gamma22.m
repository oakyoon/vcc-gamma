function target_lum = TargetLum_Gamma22()
	target_lum = TargetLum_Linear() .^ 2.2;
end