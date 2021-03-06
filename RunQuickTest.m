% calibration params.
p1_inv_gamma = 1 / 1.8;
p1_levels    = 4;
p2_step_size = 51;
p3_step_size = 51;
n_measures   = 3;
countdown    = 5;

% test-run does not check gamma data directory

% determine device & screen id
if ~exist('device', 'var') || ~isscalar(device) || ~isa(device, 'LumMeter')
	device = Input_LumMeter('lum. meter device (e.g., LumMeter_Dummy): ');
end
if ~exist('screen_id', 'var') || ~isscalar(screen_id)
	screen_id = Input_ScreenId;
end

% countdown, leave the room
for countdown_sec = countdown:-1:1
	countdown_str = sprintf('%2d seconds to start... ', countdown_sec);
	fprintf(2, countdown_str);
	pause(1);
	fprintf(2, repmat('\b', 1, length(countdown_str)));
end
fprintf(2, 'starting... \n');

% turn off sync tests
Screen('Preference', 'SkipSyncTests', 1);

try
	clear e;
	% phase 1 calibration
	if ~exist('p1_data', 'var') || ~isstruct(p1_data)
		p1_data = struct( ...
			'screen_id',  screen_id, ...
			'n_measures', n_measures, ...
			'levels',     round((linspace(0, 1, p1_levels) .^ p1_inv_gamma) * 255) ...
			);
	end
	if ~isfield(p1_data, 'mtable')
		p1_data.mtable = MeasurementSeq_RGB(p1_data.levels, device, ...
			p1_data.screen_id, LinearGammaTable, p1_data.n_measures);
	end
	if ~isfield(p1_data, 'gamma_table')
		p1_data.gamma_table = BuildGammaTable(p1_data.mtable, ...
			[], RelLum_Measured(p1_data.mtable));
	end

	% phase 2 calibration
	if ~exist('p2_data', 'var') || ~isstruct(p2_data)
		p2_data = struct( ...
			'screen_id',  screen_id, ...
			'n_measures', n_measures, ...
			'levels',     (0:p2_step_size:255) ...
			);
	end
	if ~isfield(p2_data, 'mtable')
		p2_data.mtable = MeasurementSeq_RGB(p2_data.levels, device, ...
			p2_data.screen_id, p1_data.gamma_table, p2_data.n_measures);
	end
	if ~isfield(p2_data, 'gamma_table')
		p2_data.gamma_table = BuildGammaTable(p2_data.mtable);
	end

	% phase 3 linearity check
	if ~exist('p3_data', 'var') || ~isstruct(p3_data)
		p3_data = struct( ...
			'screen_id',  screen_id, ...
			'n_measures', n_measures, ...
			'levels',     (0:p3_step_size:255) ...
			);
	end
	if ~isfield(p3_data, 'mtable')
		p3_data.mtable = MeasurementSeq_Grayscale(p3_data.levels, device, ...
			p3_data.screen_id, p2_data.gamma_table, p3_data.n_measures);
	end

	% test-run does not save data files

	% test-run just plots figure
	figure('Position', [0, 0, 1200, 800]);
	subplot(3, 2, 1); Plot_MeasurementTable(p1_data.mtable); title('Phase 1');
	subplot(3, 2, 2); Plot_GammaTable(p1_data.gamma_table);  title('Approx. Gamma Table');
	subplot(3, 2, 3); Plot_MeasurementTable(p2_data.mtable); title('Phase 2');
	subplot(3, 2, 4); Plot_GammaTable(p2_data.gamma_table);  title('Gamma Table');
	subplot(3, 2, [5 6]);  Plot_MeasurementTable(p3_data.mtable, true); title('Linearity Check');
catch e
	% var-dump
	if CheckVarDump
		dumpfile = sprintf('Workspace.%s.mat', ...
			datestr(now(), 'yyyy-mm-dd.HH_MM_SS'));
		save(fullfile(fileparts(mfilename('fullpath')), 'var-dump', dumpfile));
	end
end

% reset gamma table
ResetGammaTable;
% restore sync tests
Screen('Preference', 'SkipSyncTests', 0);

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