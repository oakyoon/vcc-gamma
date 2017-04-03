function lum_table = BuildLumTable(mtable, target_lum)
	if ~exist('mtable', 'var') || isempty(mtable)
		mtable = LoadMeasurementTable;
	end
	if ~exist('target_lum', 'var') || isempty(target_lum)
		target_lum = TargetLum_Linear;
	end

	% check input args.
	if ~iscell(mtable)
		mtable = {mtable};
	end
	if isvector(target_lum)
		target_lum = repmat(target_lum(:), 1, 3);
	end

	% determine lum. range
	minlum    = max(cell2mat(cellfun(@(t) {t(1,   5:7)}, mtable(:))), [], 1);
	maxlum    = min(cell2mat(cellfun(@(t) {t(end, 5:7)}, mtable(:))), [], 1);
	lum_range = min((maxlum - minlum) ./ LumRatio_RGB) .* LumRatio_RGB;

	% build lum. table
	n_lums    = size(target_lum, 1);
	lum_table = repmat(minlum, n_lums, 1) + ...
		repmat(lum_range, n_lums, 1) .* target_lum;
end