function device = Input_LumMeter()
	device = [];
	while ~isscalar(device) || ~isa(device, 'LumMeter')
		device = input('lum. meter device (e.g., LumMeter_CS100A(''COM2'')): ');
	end
end