% Set the Sampling rate to 44100 Hz (CD quality) and 16-bit depth
fs = 44100;
bits = 16;

% Variable to keep track of figure numbers
timeDomainFigNum = 1;
freqDomainFigNum = 1;

% Get the path of the directory where the MATLAB script is located
script_file = mfilename('fullpath');
[script_path, ~, ~] = fileparts(script_file);

db_file = fullfile(script_path, 'db.mat'); % Database file path

% Check if the database file exists, load it if it does, or create a new one if not
if exist(db_file, 'file') ~= 2
    database = struct('UserID', {}, 'FundamentalFreq', {}); % Create new database structure
    save(db_file, 'database'); % Save the newly created database structure
else
    load(db_file); % Load existing database
end

while true
    % Ask the user whether they want to record, open a file, or validate
    user_choice = input('Do you want to record (R), open a file (O), validate (V), or Exit (E)? ', 's');
    
    if strcmpi(user_choice, 'R') % Record a new audio
        % Ask the user for the recording duration
        recorduration = input('Enter the recording duration (in seconds): ');
        if isempty(recorduration) || recorduration <= 0
            disp('Invalid recording duration. Please enter a positive number.');
            continue;
        end
        
        recorder = audiorecorder(fs, bits, 1);
        
        % Record a speech signal for the specified duration
        disp('Start Recording....');
        recordblocking(recorder, recorduration);
        disp('End of Recording...');

        % Playback the recording
        play(recorder);

        % Ask the user if they are happy with the recording
        user_response = input('Are you happy with the recording? (y/n): ', 's');

        if strcmpi(user_response, 'y')
            % If the user is happy, break out of the loop
            y = getaudiodata(recorder);
            user_file_name = input('Please enter a file name to save the recording: ','s');
            filename = [user_file_name, '.wav'];
            audiowrite(filename, y, fs);
            % Break out of the loop after successful recording
            %break;
        else
            % If not happy, repeat the recording
            disp('Recording again...');
        end
    elseif strcmpi(user_choice, 'O') % Open an existing audio file
        % List audio files in the current directory
        audio_files = dir('*.wav');
        
        if isempty(audio_files)
            disp('No audio files found in the directory.');
            continue;
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

            %% Play recording 
            %sound(y,fs);
            %pause;
            % Step 1: Remove Noise (Apply Filtering or Noise Reduction Algorithm)
            % For example, using a low-pass filter
            % Here, design and apply a low-pass filter to remove noise from the signal 'y'
            % Replace the filter design and implementation as per your noise reduction needs

            % Step 2: Apply Hamming Window to the Signal
            y_windowed = y .* hamming(length(y));

            % Step 3: Convert Windowed Audio from Time Domain to Frequency Domain
            Y = fft(y_windowed);
            L = length(y_windowed);
            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            f = fs*(0:(L/2))/L;

            % Step 4: Extract Fundamental Frequency (using appropriate method)
            % For instance, using peak detection in the frequency domain
            [max_val, max_idx] = max(P1);
            fundamental_freq = f(max_idx);
            fprintf('Estimated Fundamental Frequency: %.2f Hz\n', fundamental_freq);

            % Step 5: Plot Diagrams
            % Time Domain Plot
            figure(timeDomainFigNum);
            time = (0:length(y)-1) / fs;
            plot(time, y);
            xlabel('Time (s)');
            ylabel('Amplitude');
            title('Audio Signal in Time Domain');
            timeDomainFigNum = timeDomainFigNum + 1;

            % Frequency Domain Plot
            figure(timeDomainFigNum);
            plot(f, P1);
            hold on;
            plot(f(max_idx), max_val, 'ro', 'MarkerSize', 8); % Mark fundamental frequency
            hold off;
            xlabel('Frequency (Hz)');
            ylabel('Magnitude');
            title('Single-Sided Amplitude Spectrum of Audio Signal');
            legend('Frequency Spectrum', 'Fundamental Frequency');
            grid on;
            timeDomainFigNum = timeDomainFigNum + 1;

            % Ask for the user ID to save with the fundamental frequency
            user_id = input('Enter User ID: ', 's');
        new_entry.UserID = user_id;
        new_entry.FundamentalFreq = fundamental_freq;
        
        database(end + 1) = new_entry; % Append new entry to the database
        
        % Save the updated database
        save(db_file, 'database');
        
        % Break out of the loop or continue file opening/validation process
        %break; % For example, breaking out of the loop after analyzing one file
        end
    elseif strcmpi(user_choice, 'V') % Validate

        audio_files = dir('*.wav');
        
        if isempty(audio_files)
            disp('No audio files found in the directory.');
            continue;
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
        % Ask for the user ID to validate
            validate_id = input('Enter User ID to validate: ', 's');
            [y, fs] = audioread(selected_file);
            % Step 2: Apply Hamming Window to the Signal
            y_windowed = y .* hamming(length(y));

            % Step 3: Convert Windowed Audio from Time Domain to Frequency Domain
            Y = fft(y_windowed);
            L = length(y_windowed);
            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            f = fs*(0:(L/2))/L;

            % Step 4: Extract Fundamental Frequency (using appropriate method)
            % For instance, using peak detection in the frequency domain
            [max_val, max_idx] = max(P1);
            fundamental_freq = f(max_idx);
            fprintf('Estimated Fundamental Frequency: %.2f Hz\n', fundamental_freq);
            % Retrieve the fundamental frequency corresponding to the entered user ID from the database
            match_fundamental = [];
            for i = 1:length(database)
                if strcmpi(validate_id, database(i).UserID)
                    match_fundamental = database(i).FundamentalFreq;
                    break;
                end
            end
            
            % Check if a match is found and validate within a 10% tolerance
            if ~isempty(match_fundamental)
                tolerance = 0.1 * match_fundamental;
                if abs(fundamental_freq - match_fundamental) <= tolerance
                    fprintf('Validation successful for User ID: %s\n', validate_id);
                else
                    fprintf('Validation failed for User ID: %s\n', validate_id);
                end
            else
                fprintf('User ID: %s not found in the database\n', validate_id);
            end
        end
        %break; % For example, breaking out of the loop after validating one entry
    elseif strcmpi(user_choice, 'E')
        break;
    else
        disp('Invalid choice. Please enter "R" to record, "O" to open a file, or "V" to validate.');
    end
end
