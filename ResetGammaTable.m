function ResetGammaTable()
	screen_ids = Screen('Screens');
	if any(screen_ids ~= 0)
		screen_ids = screen_ids(screen_ids ~= 0);
	end
	for screen_id = screen_ids
		Screen('LoadNormalizedGammaTable', screen_id, LinearGammaTable);
	end
end