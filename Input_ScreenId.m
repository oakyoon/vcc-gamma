function screen_id = Input_ScreenId()
	screen_ids = Screen('Screens');
	if any(screen_ids ~= 0)
		screen_ids = screen_ids(screen_ids ~= 0);
		screen_id = [];
		while ~isscalar(screen_id) || ~any(screen_ids == screen_id)
			screen_id = input(['screen id ', mat2str(screen_ids) ,': ']);
		end
	else
		screen_id = 0;
	end
end