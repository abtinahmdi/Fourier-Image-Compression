clc; 
clear; 
close all;

%% --- Task 1: Image Preparation ---
% Load image
img = imread('cameraman.tif');
% Resize to 32x32 for feasible MANUAL calculation time (O(N^4) complexity)
% If you use original size, the manual loops will take forever!
target_size = [32, 32]; 
img_small = imresize(img, target_size);
img_double = double(img_small);
[M, N] = size(img_double);

figure('Name', 'Task 1: Original Image');
imshow(uint8(img_double));
title(['Original Image Resized (' num2str(M) 'x' num2str(N) ')']);

%% --- Task 2: Built-in FFT2 ---
% Calculate FFT using built-in function
F_builtin = fft2(img_double);

% Shift zero frequency to center
F_centered = fftshift(F_builtin);

% Visualize Log Magnitude Spectrum
figure('Name', 'Task 2: Spectrum');
imshow(log(1 + abs(F_centered)), []);
title('Centered Fourier Spectrum (Log Magnitude)');

%% --- Task 3: Manual Forward DFT Implementation ---
% Formula: F(u,v) = sum_x sum_y f(x,y) * e^(-j*2*pi*(ux/M + vy/N))
F_manual = zeros(M, N);

for u = 0:M-1
    for v = 0:N-1
        sum_val = 0;
        for x = 0:M-1
            for y = 0:N-1
                % Note: Matlab indices start at 1, so use x+1, y+1
                term = img_double(x+1, y+1) * exp(-1j * 2 * pi * ((u*x)/M + (v*y)/N));
                sum_val = sum_val + term;
            end
        end
        F_manual(u+1, v+1) = sum_val;
    end
end

% Verification check
diff_norm = norm(abs(F_builtin - F_manual));
fprintf('Difference between Built-in and Manual Forward DFT: %e\n', diff_norm);

%% --- Task 4 & 5: Compression and Reconstruction for different percentages ---

% Define the percentages to test
percentages = [0.05, 0.10, 0.50]; % 5%, 10%, and 50%

% Create a figure to display all results side-by-side
figure('Name', 'Task 4 & 5: Compression Results Comparison');

% Display the original image in the first position
subplot(1, length(percentages) + 1, 1);
imshow(uint8(img_double));
title('Original');

% Loop through each percentage value
for i = 1:length(percentages)
    p = percentages(i);
    
    % --- Task 4: Create Mask and Apply it ---
    
    % Create a circular mask based on the current percentage 'p'
    [Y, X] = meshgrid(1:N, 1:M);
    cx = round(N/2);
    cy = round(M/2);
    radius_sq = (X - cx).^2 + (Y - cy).^2;
    
    % Calculate the radius that keeps the top 'p'% of coefficients
    keep_radius = sqrt((p * M * N) / pi);
    
    mask = radius_sq <= keep_radius^2;

    % Apply mask to the CENTERED spectrum to zero out high frequencies
    F_compressed_centered = F_centered .* mask;
    
    % --- Task 5: Inverse Transform ---
    
    % Un-shift the compressed spectrum
    F_compressed = ifftshift(F_compressed_centered);
    
    % Reconstruct the image using built-in inverse FFT
    img_recon_builtin = ifft2(F_compressed);
    
    % Get the real part (imaginary part should be negligible)
    img_recon_builtin_real = real(img_recon_builtin);
    
    % --- Display the result ---
    subplot(1, length(percentages) + 1, i + 1);
    imshow(uint8(img_recon_builtin_real));
    title(['Recon (' num2str(p * 100) '%)']);
    
    fprintf('Compression with p = %.2f done.\n', p);
end

%% --- Task 7 & 8: Analysis & Manual Check of F(0,0) ---

% F(0,0) Manual Calculation (Average Intensity / Sum of pixels)
% Formula: sum of all f(x,y) for u=0, v=0 (exp term becomes 1)
F_00_manual_calc = sum(sum(img_double));
F_00_from_fft = F_manual(1,1); % Matlab index (1,1) is (0,0)

fprintf('\n--- Task 7: F(0,0) Check ---\n');
fprintf('Sum of all pixels (Manual F(0,0)): %.4f\n', F_00_manual_calc);
fprintf('Value from FFT code F(0,0):        %.4f\n', F_00_from_fft);
