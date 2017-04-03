function mtable = MeasurementSeq_RGB(levels, device, screen_id, gamma_table, n_measures)
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
	mtable = zeros(n_levels, 7);
	mtable(:, 1)   = levels;
	mtable(:, 2:4) = gamma_table(levels + 1, :);

	% rgb colors
	colors = zeros(n_levels * 3, 3);
	for c = 1:3
		colors((c * n_levels) + ((1 - n_levels): 0), c) = levels;
	end
	colors = unique(colors, 'rows');
	n_colors = size(colors, 1);
	% measurement sequence
	lums = MeasurementSeq_Raw(colors, device, screen_id, gamma_table, n_measures);
	% organize measurement table
	for m = 1:n_levels
		level = levels(m);
		if level == 0
			selected_lums = lums(all(colors == 0, 2), :);
			mtable(mtable(:, 1) == 0, 5:7) = mean(selected_lums);
		else
			for c = 1:3
				color = zeros(n_colors, 3);
				color(:, c) = level;
				selected_lums = lums(all(colors == color, 2), :);
				mtable(mtable(:, 1) == level, 4 + c) = mean(selected_lums);
			end
		end
	end
end