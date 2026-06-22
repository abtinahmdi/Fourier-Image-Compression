# Image Compression using 2D Fourier Transform

## Project Overview

This project investigates image compression in the frequency domain using the 2D Fourier Transform.

The image is transformed into the frequency domain, high-frequency components are removed using a configurable low-pass filter, and the image is reconstructed using the inverse Fourier Transform.

## Objectives

* Implement 2D Fourier Transform in MATLAB
* Compare manual DFT calculations with MATLAB built-in functions
* Analyze the effect of frequency-domain filtering
* Study the relationship between retained frequencies and image quality

## Methods

1. Resize the input image for computational efficiency.
2. Compute the 2D Fourier Transform.
3. Shift the spectrum to center low-frequency components.
4. Apply a circular low-pass filter.
5. Reconstruct the image using inverse FFT.
6. Compare image quality under different filter radii.

## Results

The experiments show that retaining more low-frequency components improves image quality, while aggressive filtering reduces visual detail.

The manually computed DFT closely matches MATLAB's built-in FFT implementation with negligible numerical error.

## Tools

* MATLAB
* FFT / IFFT
* Frequency-Domain Filtering

## Repository Structure

* src/ : MATLAB source code
* results/ : generated figures and images
* report.pdf : original Persian report
