classdef LumMeter_CS100A < LumMeter

	properties (GetAccess=public, SetAccess=private)

		serialObj = [];

	end
	properties (GetAccess=public, SetAccess=public)

		serialPort = 'COM2';
		serialArgs = { ...
			'BaudRate',     4800, ...
			'DataBits',     7, ...
			'Parity',       'even', ...
			'StopBits',     2, ...
			'Terminator',  'CR/LF', ...
			'FlowControl', 'hardware', ...
			'Timeout',      5 ...
			};

	end
	methods (Access=public)

		function obj = LumMeter_CS100A(port)
			if exist('port', 'var') && ~isempty(port)
				obj.serialPort = port;
			end
		end

		function open(obj, forced)
			if ~exist('forced', 'var') || isempty(forced)
				forced = false;
			end
			if forced || isempty(obj.serialObj)
				try
					% initialize serial port object
					obj.serialObj = serial(obj.serialPort, obj.serialArgs{:});
					fopen(obj.serialObj);
					% initialize CS100A
					% MDS,07: response switch at SLOW (400ms response time)
					ec = obj.sendCommand('MDS,07');
					if ~strcmp(ec, 'OK00')
						error('cannot initialize CS100A: error check [%s]', ec);
					end
				catch e
					obj.close();
					rethrow(e);
				end
			end
		end

		function close(obj, forced)
			if ~exist('forced', 'var') || isempty(forced)
				forced = false;
			end
			if ~isempty(obj.serialObj)
				if forced || strcmp(obj.serialObj.Status, 'open')
					fclose(obj.serialObj);
				end
				delete(obj.serialObj);
			end
			obj.serialObj = [];
		end

		function ec = sendCommand(obj, cmd)
			if obj.serialObj.BytesAvailable > 0
				fread(obj.serialObj, obj.serialObj.BytesAvailable);
			end
			pause(.1);
			if strcmp(obj.serialObj.Pinstatus.ClearToSend, 'off')
				error('CS100A not ready');
			end
			fprintf(obj.serialObj, cmd);
			pause(.1);
			ec = char(fread(obj.serialObj, 4)');
		end

		function [l, c, ec] = read(obj)
			try
				ec = obj.sendCommand('MES');
				if ~isempty(regexp(ec, '^OK(00|1[1-3])$', 'once'))
					resp = textscan(fscanf(obj.serialObj), ', %f, %f, %f');
				end
				switch ec
					% OK00: normal measurement
					% OK13: luminance display range under
					case {'OK00', 'OK13'}
						l = resp{1};
						c = cell2mat(resp(2:3));
					% OK11: chromaticity measuring range over
					case 'OK11'
						l = resp{1};
						c = NaN(1, 2);
					% OK12: luminance display range over
					case 'OK12'
						l = Inf;
						c = cell2mat(resp(2:3));
					% ER10: luminance and chromaticity measuring range over 
					% ER12: luminance and chromaticity display range over
					% ER19: display range over
					case {'ER10', 'ER12', 'ER19'}
						l = Inf;
						c = NaN(1, 2);
					otherwise
						error('unexpected response from CS100A: error check [%s]', ec);
				end
			catch e
				obj.close();
				rethrow(e);
			end
		end

	end
	
end