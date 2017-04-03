function Plot_MeasurementTable(mtable, fitting_line)
	if ~exist('fitting_line', 'var') || isempty(fitting_line)
		fitting_line = false;
	end

	if size(mtable, 2) >= 7
		n_colors = 3;
		colors = [1 0 0; 0 1 0; 0 0 1];
	else
		n_colors = 1;
		colors = [0 0 0];
	end

	hold on;
	if fitting_line
		for c = 1:n_colors
			% plot linear fitting line
			xx = mtable(:, 1);
			yy = mtable(:, 4 + c);
			cc = nlinfit(xx, yy, @(c, x) x * c(1) + c(2), [1 0]);
			plot(xx, xx * cc(1) + cc(2), 'Color', colors(c, :));
			% plot data with small marker
			plot(xx, yy, 'o', 'MarkerSize', 2, ...
				'MarkerEdgeColor', colors(c, :), ...
				'MarkerFaceColor', colors(c, :));
		end
	else
		for c = 1:n_colors
			plot(mtable(:, 1), mtable(:, 4 + c), 'Color', colors(c, :));
		end
	end
	set(gca, 'XTick', 0:64:256);
	xlim([0 256]);
	hold off;
end