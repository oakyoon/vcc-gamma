function [gamma_table, lum_table] = BuildGammaTable(mtable, target_lum, rel_lum)
	if ~exist('mtable', 'var') || isempty(mtable)
		mtable = LoadMeasurementTable;
	end
	if ~exist('target_lum', 'var') || isempty(target_lum)
		target_lum = TargetLum_Linear;
	end
	if ~exist('rel_lum', 'var') || isempty(rel_lum)
		rel_lum = RelLum_sRGB;
	end

	% check input args.
	multi_screen = iscell(mtable);
	if ~multi_screen
		mtable = {mtable};
	end

	% build gamma table
	lum_table   = BuildLumTable(mtable, target_lum, rel_lum);
	gamma_table = cell(size(mtable));
	for t = 1:numel(mtable)
		gamma_table{t} = zeros(size(lum_table, 1), 3);
		for c = 1:3
			data_idx = [true; diff(mtable{t}(:, 4 + c)) > 0];
			gamma_table{t}(:, c) = pchip( ...
				mtable{t}(data_idx, 4 + c), ...
				mtable{t}(data_idx, 1 + c), ...
				lum_table(:, c));
		end
	end

	if ~multi_screen
		gamma_table = gamma_table{1};
	end
end