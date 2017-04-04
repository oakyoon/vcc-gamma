function device = Input_LumMeter(prompt)
	if ~exist('prompt', 'var') || isempty(prompt)
		prompt = 'lum. meter device (e.g., LumMeter_CS100A(''COM2'')): ';
	end

	device = [];
	while ~isscalar(device) || ~isa(device, 'LumMeter')
		device = input(prompt);
	end
end