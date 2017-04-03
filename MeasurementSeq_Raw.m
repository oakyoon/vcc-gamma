function [lums, colors, gamma_table] = MeasurementSeq_Raw(colors, device, screen_id, gamma_table, n_measures)
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

	try
		% open window and load gamma table
		wptr = Screen('OpenWindow', screen_id, [0 0 0]);
		Screen('LoadNormalizedGammaTable', screen_id, gamma_table);
		HideCursor;
		if screen_id > 0
			screen_ids = Screen('Screens');
			for s = screen_ids(screen_ids > 0 & screen_ids ~= screen_id)
				Screen('OpenWindow', s, [0 0 0]);
			end
		end

		n_colors = size(colors, 1);
		lums = zeros(n_colors, n_measures);
		for r = 1:n_measures
			cseq = randperm(n_colors);
			for c = cseq
				% put color on screen
				Screen('FillRect', wptr, colors(c, :));
				Screen('Flip', wptr);
				WaitSecs(.1);
				% provide dummy device with bufferValue (for testing purpose)
				if isa(device, 'LumMeter_Dummy')
					device.bufferTimeout = GetSecs + .4;
					device.bufferValue = [ ...
						gamma_table(colors(c, 1) + 1, 1), ...
						gamma_table(colors(c, 2) + 1, 2), ...
						gamma_table(colors(c, 3) + 1, 3) ...
						];
				end
				% measure luminance & cool down
				lums(c, r) = device.safeRead();
				WaitSecs(.4);
			end
		end

		Screen('CloseAll');
	catch e
		Screen('CloseAll');
		rethrow(e);
	end
end