classdef LumMeter < handle

	methods (Abstract, Access=public)

		open(obj, forced)
		close(obj, forced)
		l = read(obj)

	end
	methods (Access=public)

		function l = safeRead(obj, n_errors)
			if ~exist('n_errors', 'var') || isempty(n_errors)
				n_errors = 3;
			end
			r_errors = n_errors;
			while r_errors > 0
				try
					obj.open(false);
					l = obj.read();
					r_errors = 0;
				catch e  % tolerate certain number of failures
					fprintf(2, '%s\n', e.message);
					r_errors = r_errors - 1;
					if r_errors <= 0
						ne = MException('', '%d successive failures', n_errors);
						throw(ne.addCause(e));
					end
				end
			end
		end

	end

end