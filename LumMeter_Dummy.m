classdef LumMeter_Dummy < LumMeter

	properties (GetAccess=public, SetAccess=private)

		gamma = 2.2;

	end
	properties (GetAccess=public, SetAccess=public)

		% bufferValue will be used to generate dummy measurement value
		bufferTimeout = 0;
		bufferValue   = [];

	end
	methods (Access=public)

		function obj = LumMeter_Dummy(gamma)
			if exist('gamma', 'var') && ~isempty(gamma)
				obj.gamma = gamma;
			end
		end

		function open(~, ~)
		end

		function close(~, ~)
		end

		function l = read(obj)
			if obj.bufferTimeout >= GetSecs && ~isempty(obj.bufferValue)
				l = sum((obj.bufferValue .^ obj.gamma) .* LumRatio_RGB * 100);
			else
				l = rand * 100;
			end
		end

	end

end