function [mtable, screen_ids] = LoadMeasurementTable()
	screen_ids = Screen('Screens');
	if any(screen_ids ~= 0)
		screen_ids = screen_ids(screen_ids ~= 0);
		n_screens  = length(screen_ids);
		mtable     = cell(n_screens, 1);
		for s = 1:n_screens
			vars = load(fullfile(GammaDataDir, num2str(screen_ids(s)), 'mtable.mat'));
			mtable{s} = vars.mtable;
		end
	else
		screen_ids = 0;
		vars       = load(fullfile(GammaDataDir, '0', 'mtable.mat'));
		mtable     = vars.mtable;
	end
end