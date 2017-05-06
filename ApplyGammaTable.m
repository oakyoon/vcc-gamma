function ApplyGammaTable(target_lum, rel_lum)
	if ~exist('target_lum', 'var') || isempty(target_lum)
		target_lum = TargetLum_Linear;
	end
	if ~exist('rel_lum', 'var') || isempty(rel_lum)
		rel_lum = RelLum_sRGB;
	end

	[mtable, screen_ids] = LoadMeasurementTable;
	gamma_table = BuildGammaTable(mtable, target_lum, rel_lum);
	if iscell(mtable)
		for s = 1:length(screen_ids)
			Screen('LoadNormalizedGammaTable', screen_ids(s), gamma_table{s});
		end
	else
		Screen('LoadNormalizedGammaTable', screen_ids, gamma_table);
	end
end