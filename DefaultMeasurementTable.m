function mtable = DefaultMeasurementTable(gamma)
	if ~exist('gamma', 'var') || isempty(gamma)
		gamma = 2.2;
	end

	mtable = zeros(256, 7);
	mtable(:, 1)   = (0:255)';
	mtable(:, 2:4) = LinearGammaTable;
	gamma_lums = (linspace(0, 1, 256)' .^ gamma) * 100;
	mtable(:, 5:7) = repmat(gamma_lums, 1, 3) .* repmat(LumRatio_RGB, 256, 1);
end