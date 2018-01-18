function tf = CheckVarDump()
	tf = evalin('base', 'exist(''VAR_DUMP'', ''var'') && VAR_DUMP');
end