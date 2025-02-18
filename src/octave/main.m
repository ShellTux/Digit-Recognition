#!/usr/bin/env octave
clear

addpath('src/octave')

participants = 1:60;
digits = 0:9;
samples = 0:49;

mkdir('data');
save_filename = 'data/audio_features.mat';

audio_features = zeros(length(participants), length(digits), length(samples), length(Features.enum()));
audio_features_size = size(audio_features);
audio_features_ndims = ndims(audio_features);
recompute = true;

if exist(save_filename, 'file')
   load(save_filename, 'audio_features');
   if (ndims(audio_features) == audio_features_ndims) & (size(audio_features) == audio_features_size)
      fprintf('Loaded precomputed features from %s\n', save_filename);
      recompute = false
   end
end

if recompute
   for participant = participants
      for digit = digits
         for sample = samples
            fprintf('Computing Audio Features for Participant %02d, digit %02d, sample %02d', participant, digit, sample);
            audio_file = sprintf("./AudioMNIST/data/%02d/%d_%02d_%d.wav", participant, digit, participant, sample);
            [audio, Fs] = audioread(audio_file);
            if !exist(audio_file, 'file')
               fprintf(stderr, 'File not found: %s\n', audio_file);
               % Handle the case where the file doesn't exist (e.g., skip it,
               % or set features to NaN or 0). Here, we skip.
               continue;
            end
            [audio, Fs] = audioread(audio_file);

            % Feature 1: Total Energy
            total_energy = sum(audio .^ 2);
            audio_features(participant, digit + 1, sample + 1, Features.TotalEnergy) = total_energy;

            % Feature 2: Standard Deviation
            standard_deviation = std(audio);
            audio_features(participant, digit + 1, sample + 1, Features.StandardDeviation) = standard_deviation;

            % Feature 3: Max Amplitude
            max_amplitude = max(abs(audio)); % Use abs to handle negative values
            audio_features(participant, digit + 1, sample + 1, Features.MaxAmplitude) = max_amplitude;

            % Feature 4: Zero Crossing Rate
            % Method 1: Using sign changes (more robust)
            zero_crossings = sum(abs(diff(sign(audio)))) / 2;
            zero_crossing_rate = zero_crossings / length(audio); % Normalize by signal length
            audio_features(participant, digit + 1, sample + 1, Features.ZeroCrossingRate) = max_amplitude;

            % Feature 5: Duration
            duration = length(audio) / Fs;
            audio_features(participant, digit + 1, sample + 1, Features.Duration) = duration;

            % Store the features.  Average over samples.
            # audio_features(participant, digit + 1, 1) = (audio_features(participant, digit+1, 1)*(sample) + total_energy) / (sample + 1);
            # audio_features(participant, digit + 1, 2) = (audio_features(participant, digit+1, 2)*(sample) + standard_deviation) / (sample + 1);
            # audio_features(participant, digit + 1, 3) = (audio_features(participant, digit+1, 3)*(sample) + max_amplitude) / (sample + 1);
            # audio_features(participant, digit + 1, 4) = (audio_features(participant, digit+1, 4)*(sample) + zero_crossing_rate) / (sample + 1);
            # audio_features(participant, digit + 1, 5) = (audio_features(participant, digit+1, 5)*(sample) + duration) / (sample + 1);
            fprintf('\r');
         end
      end
   endfor
   fprintf('\n');

   save(save_filename, 'audio_features');
   fprintf('Saved computed features to %s\n', save_filename);
endif

participant_index = 1;
digit_index = 1;
if false
   participant_index = input('Choose a participant: ');
   digit_index = input('Choose a digit: ') + 1;
end

fprintf('Features for Participant %d, Digit %d:\n', participant_index, digits(digit_index));
fprintf('  Total Energy:        %.4f\n',         mean(audio_features(participant_index, digit_index, :, Features.TotalEnergy)));
fprintf('  Standard Deviation:  %.4f\n',         mean(audio_features(participant_index, digit_index, :, Features.StandardDeviation)));
fprintf('  Max Amplitude:       %.4f\n',         mean(audio_features(participant_index, digit_index, :, Features.MaxAmplitude)));
fprintf('  Zero Crossing Rate:  %.4f\n',         mean(audio_features(participant_index, digit_index, :, Features.ZeroCrossingRate)));
fprintf('  Duration:            %.4f seconds\n', mean(audio_features(participant_index, digit_index, :, Features.Duration)));
