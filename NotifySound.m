function NotifySound()
	fprintf(2, 'waiting for key press...\n');
	KbName('UnifyKeyNames');
	keys = [KbName('space'), KbName('ESCAPE')];

	wavfile = fullfile(fileparts(mfilename('fullpath')), 'NotifySound.wav');
	if exist('audioread', 'file')
		[Y, Fs] = audioread(wavfile);
	else
		[Y, Fs] = wavread(wavfile); %#ok<DWVRD>
	end
	InitializePsychSound;
	pa = PsychPortAudio('Open', [], [], 0, Fs, size(Y, 2));
	PsychPortAudio('FillBuffer', pa, Y');
	PsychPortAudio('Start', pa, 0, 0, 1);

	ListenChar(2);
	RestrictKeysForKbCheck(keys);
	KbWait([], 3);
	RestrictKeysForKbCheck([]);
	ListenChar(1);

	PsychPortAudio('Stop', pa);
	PsychPortAudio('Close', pa);
end