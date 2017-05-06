function rel_lum = RelLum_Measured(mtable)
	rel_lum = mtable(end, 5:7) ./ sum(mtable(end, 5:7));
end