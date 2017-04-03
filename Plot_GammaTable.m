function Plot_GammaTable(gamma_table)
	hold on;
	for c = 1:3
		plot((0:255)', gamma_table(:, c), 'Color', (1:3) == c);
	end
	set(gca, 'XTick', 0:64:256);
	xlim([0 255]);
	ylim([0 1]);
	hold off;
end