function [datadir, basedir, hostname] = GammaDataDir()
	% determine hostname
	[status, hostname] = system('hostname');
	if status ~= 0
		fprintf(2, 'cannot determine hostname, fall back to ''default''.\n');
		hostname = 'default';
	else
		hostname = strtrim(hostname);
		if ~isempty(regexp(hostname, '\.local$', 'once'))  % workaround for mac
			fprintf(2, 'removing ''.local'' at the end of hostname.\n');
			hostname = regexprep(hostname, '\.local$', '');
		end
	end

	% determine basedir
	if exist('gamma-data', 'dir')
		basedir = 'gamma-data';
	else
		basedir = fullfile(fileparts(mfilename('fullpath')), 'gamma-data');
	end

	% determine datadir
	datadir = fullfile(basedir, hostname);
	if ~exist(datadir, 'dir')
		fprintf(2, 'cannot find directory named ''%s'' in ''%s'', fall back to ''default''.\n', hostname, basedir);
		datadir = fullfile(basedir, 'default');
	else
end