function rel_lum = RelLum_Measured(mtable)
	if ~exist('mtable', 'var') || isempty(mtable)
		mtable = LoadMeasurementTable;
	end

	rel_lum = mtable(end, 5:7) ./ sum(mtable(end, 5:7));
end