function mtable = MeasurementSeq_Grayscale(levels, device, screen_id, gamma_table, n_measures)
	if ~exist('device', 'var') || isempty(device)
		device = Input_LumMeter;
	end
	if ~exist('screen_id', 'var') || isempty(screen_id)
		screen_id = Input_ScreenId;
	end
	if ~exist('gamma_table', 'var') || isempty(gamma_table)
		gamma_table = LinearGammaTable;
	end
	if ~exist('n_measures', 'var') || isempty(n_measures)
		n_measures = 3;
	end

	levels   = levels(:);
	n_levels = size(levels, 1);

	% prepare measurement table
	mtable = zeros(n_levels, 5);
	mtable(:, 1)   = levels;
	mtable(:, 2:4) = gamma_table(levels + 1, :);

	% measurement sequence
	colors = repmat(levels, 1, 3);
	lums = MeasurementSeq_Raw(colors, device, screen_id, gamma_table, n_measures);
	mtable(:, 5) = mean(lums, 2);
end