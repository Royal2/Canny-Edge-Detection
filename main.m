clear all; close all; clc;
%% Canny Edge Detection
image=imread('cars.jpg');
%for comparison with implemented gaussian kernel
kernel = fspecial('gaussian', [5 5], 1.4);  %std=1.4
smoothed_im=imfilter(image, kernel);
figure; imshow(smoothed_im); title('Image after Smoothing using fspecial(gaussian), for comaprison only');
%implemented filter
ced=canny_edge_detection(rgb2gray(image),0.2,0.1);
figure; imshow(ced); title('Canny Edge Detection, normalized');
