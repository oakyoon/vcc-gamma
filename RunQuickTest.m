% calibration params.
p1_inv_gamma = 1 / 1.8;
p1_levels    = 4;
p2_step_size = 51;
p3_step_size = 51;
n_measures   = 3;
countdown    = 5;

% test-run does not check gamma data directory

% determine device & screen id
device    = Input_LumMeter('lum. meter device (e.g., LumMeter_Dummy): ');
screen_id = Input_ScreenId;

% countdown, leave the room
for countdown_sec = countdown:-1:1
	countdown_str = sprintf('%2d seconds to start... ', countdown_sec);
	fprintf(2, countdown_str);
	pause(1);
	fprintf(2, repmat('\b', 1, length(countdown_str)));
end
fprintf(2, 'starting... \n');

try
	clear e;
	% phase 1 calibration
	p1_data = struct( ...
		'screen_id',  screen_id, ...
		'n_measures', n_measures, ...
		'levels',     round((linspace(0, 1, p1_levels) .^ p1_inv_gamma) * 255) ...
		);
	p1_data.mtable = MeasurementSeq_RGB(p1_data.levels, device, ...
		p1_data.screen_id, LinearGammaTable, p1_data.n_measures);
	p1_data.gamma_table = BuildGammaTable(p1_data.mtable);

	% phase 2 calibration
	p2_data = struct( ...
		'screen_id',  screen_id, ...
		'n_measures', n_measures, ...
		'levels',     (0:p2_step_size:255) ...
		);
	p2_data.mtable = MeasurementSeq_RGB(p2_data.levels, device, ...
		p2_data.screen_id, p1_data.gamma_table, p2_data.n_measures);
	p2_data.gamma_table = BuildGammaTable(p2_data.mtable);

	% phase 3 linearity check
	p3_data = struct( ...
		'screen_id',  screen_id, ...
		'n_measures', n_measures, ...
		'levels',     (0:p3_step_size:255) ...
		);
	p3_data.mtable = MeasurementSeq_Grayscale(p3_data.levels, device, ...
		p3_data.screen_id, p2_data.gamma_table, p3_data.n_measures);

	% reset gamma table
	ResetGammaTable;

	% test-run does not save data files

	% test-run just plots figure
	figure('Position', [0, 0, 1200, 800]);
	subplot(3, 2, 1); Plot_MeasurementTable(p1_data.mtable); title('Phase 1');
	subplot(3, 2, 2); Plot_GammaTable(p1_data.gamma_table);  title('Approx. Gamma Table');
	subplot(3, 2, 3); Plot_MeasurementTable(p2_data.mtable); title('Phase 2');
	subplot(3, 2, 4); Plot_GammaTable(p2_data.gamma_table);  title('Gamma Table');
	subplot(3, 2, [5 6]);  Plot_MeasurementTable(p3_data.mtable, true); title('Linearity Check');
catch e
end

% close device
try
	device.close();
catch %#ok<CTCH>
	fprintf(2, 'device.close() failed, please do it manually...\n');
end

% notify
NotifySound;
if exist('e', 'var') && ~isempty(e)
   rethrow(e);
end