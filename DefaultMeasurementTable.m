function mtable = DefaultMeasurementTable()
	mtable = zeros(256, 7);
	mtable(:, 1)   = (0:255)';
	mtable(:, 2:4) = LinearGammaTable;
	mtable(:, 5:7) = TargetLum_sRGB() .* repmat(RelLum_sRGB(), 256, 1) * 100;
end