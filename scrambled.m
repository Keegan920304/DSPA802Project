audio_files = dir('*.wav');
        
        if isempty(audio_files)
            disp('No audio files found in the directory.');
        end
        
        disp('Available audio files:');
        for i = 1:length(audio_files)
            disp([num2str(i), '. ', audio_files(i).name]);
        end
        
        % Ask the user to select a file to open
        user_file_index = input('Enter the number of the audio file to open: ');
        
        if user_file_index >= 1 && user_file_index <= length(audio_files)
            % Open the selected audio file
            selected_file = audio_files(user_file_index).name;
            
            [y, fs] = audioread(selected_file);
            disp('Playing back original Audio');
            sound(y,fs);
            disp('Press any key to continue...');
            pause
            % Increase playback speed by 1.3 times
            faster_fs = fs * 1.3;
            
            % Play audio at increased speed
            sound(y, faster_fs);
            disp('Press any key to continue...');
            pause
            % Decrease playback speed by 0.8 times
            slower_fs = fs * 0.8;
            
            % Play audio at decreased speed
            sound(y, slower_fs);
            disp('Press any key to continue...');
            pause
        end 