function [output] = canny_edge_detection(image,te,tl)
%{Implementing canny edge detection
%   Input: grayscale image, threshold, low threshold
%   Output: fitlered image
%image=imread('cars.jpg');
%image=rgb2gray(image);
    image=double(image);
    figure; imshow(uint8(image)); title('Original Grayscale Image');
%smoothing
    k=(1/159)*[2 4 5 4 2; 4 9 12 9 4; 5 12 15 12 5; 4 9 12 9 4; 2 4 5 4 2]; %guassian kernel, \sigma=1.4
    smoothed_image=imfilter(image, k);
    %smoothed_image=conv2(image, k); %using conv2() change image size to 288x644
    figure; imshow(uint8(smoothed_image)); title('Image After Smoothing');
%finding gradients
    %x and y gradient using sobel operator
    kx=[-1 0 1; -2 0 2; -1 0 1];
    ky=[-1 -2 -1; 0 0 0; 1 2 1];
    gx=imfilter(smoothed_image, kx);
    gy=imfilter(smoothed_image, ky);
    %gx=conv2(smoothed_image, kx); %again conv2() changed image size to 286x642
    %gy=conv2(smoothed_image, ky);
    figure; imshow(uint8(gx)); title('x-gradient Image');
    figure; imshow(uint8(gy)); title('y-gradient Image');
    %gradient magnitude
    g_mag=sqrt(double(gx).^2+double(gy).^2);
    figure; imshow(uint8(g_mag)); title('Gradient Magnitude Image');
    %edge direction image
    g_angle=atan(double(gy)./double(gx));
%non-maximum suppression
    %convert thick edges to sharp edges
    %rounding gradient direction to nearest pi/4
    for i=1:1:size(g_angle,1)
        for j=1:1:size(g_angle,2)
            if(g_angle(i,j)>=0)
                %positive, clock-wise
                if(abs(g_angle(i,j))<(pi/8))
                    g_angle(i,j)=0;
                elseif(abs(g_angle(i,j))<((pi/4)+(pi/8)))
                    g_angle(i,j)=pi/4;
                elseif(abs(g_angle(i,j))<((pi/2)+(pi/8)))
                    g_angle(i,j)=pi/2;
                elseif(abs(g_angle(i,j))<((3*pi/4)+(pi/8)))
                    g_angle(i,j)=3*pi/4;
                else
                    g_angle(i,j)=pi;
                end
            else
                %negative, counter clock-wise
                if(abs(g_angle(i,j))<(pi/8))
                    g_angle(i,j)=0;
                elseif(abs(g_angle(i,j))<((pi/4)+(pi/8)))
                    g_angle(i,j)=-pi/4;
                elseif(abs(g_angle(i,j))<((pi/2)+(pi/8)))
                    g_angle(i,j)=-pi/2;
                elseif(abs(g_angle(i,j))<((3*pi/4)+(pi/8)))
                    g_angle(i,j)=-3*pi/4;
                else
                    g_angle(i,j)=-pi;
                end
            end
        end
    end
    %compare the edge strength
    
    g_mag_pad = padarray(g_mag,[1 1],0,'both');
    for i=1+1:1:size(g_mag,1)+1
        for j=1+1:1:size(g_mag,2)+1
            if(g_angle(i-1,j-1)==0||(g_angle(i-1,j-1)==pi)||(g_angle(i-1,j-1)==-pi)||(g_angle(i-1,j-1)==2*pi))
                if((g_mag_pad(i,j)<g_mag_pad(i,j-1))||(g_mag_pad(i,j)<g_mag_pad(i,j+1)))
                    g_mag(i-1,j-1)=0; %if edge strength is not largest, then suppress it
                end
            elseif((g_angle(i-1,j-1)==pi/4)||(g_angle(i-1,j-1)==(-3*pi/4)))
                if((g_mag_pad(i,j)<g_mag_pad(i-1,j-1))||(g_mag_pad(i,j)<g_mag_pad(i+1,j+1)))
                    g_mag(i-1,j-1)=0; %if edge strength is not largest, then suppress it
                end
            elseif(g_angle(i-1,j-1)==(pi/2)||(g_angle(i-1,j-1)==(-pi/2)))
                if((g_mag_pad(i,j)<g_mag_pad(i-1,j))||(g_mag_pad(i,j)<g_mag_pad(i+1,j)))
                    g_mag(i-1,j-1)=0; %if edge strength is not largest, then suppress it
                end
            elseif(g_angle(i-1,j-1)==(3*pi/4)||(g_angle(i-1,j-1)==(-pi/4)))
                if((g_mag_pad(i,j)<g_mag_pad(i+1,j-1))||(g_mag_pad(i,j)<g_mag_pad(i-1,j+1)))
                    g_mag(i-1,j-1)=0; %if edge strength is not largest, then suppress it
                end
            end
        end
    end
    figure; imshow(uint8(g_mag)); title('Image after Non-maximum Suppression');
%thresholding
    %filtering out non-true edges (edges from noise or color variation)
    for i=1:1:size(g_mag,1)
        for j=1:1:size(g_mag,2)
            if(g_mag(i,j)<te)
                g_mag(i,j)=0;
            end
        end
    end
    figure; imshow(uint8(g_mag)); title('te=120');
%double thresholding and edge tracking
    %normalizing gradient magnitude
    norm_g = g_mag - min(g_mag(:));
    norm_g = norm_g ./ max(norm_g(:));
    %strong and weak edge
    strong_edge=max(norm_g(:));
    weak_edge=median(max(norm_g));
    for i=1:1:size(norm_g,1)
        for j=1:1:size(norm_g,2)
            if(norm_g(i,j)<tl)
                norm_g(i,j)=0;
            elseif(norm_g(i,j)<te)
                norm_g(i,j)=weak_edge;
            else
                norm_g(i,j)=strong_edge;
            end
        end
    end
    figure; imshow(norm_g); title(sprintf('Double Thresholding Image, normalized, high threshold=%d, low threshold=%d', te, tl));
%fixing broken edges
    for i=1+1:1:size(norm_g,1)-1 %excluding matrix border
        for j=1+1:1:size(norm_g,2)-1
            if(norm_g(i,j)==weak_edge)
                if((norm_g(i+1,j+1)==strong_edge)||(norm_g(i,j+1)==strong_edge)||(norm_g(i+1,j)==strong_edge)||(norm_g(i-1,j-1)==strong_edge)||(norm_g(i,j-1)==strong_edge)||(norm_g(i-1,j)==strong_edge)||(norm_g(i-1,j+1)==strong_edge)||(norm_g(i+1,j-1)==strong_edge))
                    norm_g(i,j)=strong_edge;
                else
                    norm_g(i,j)=0;
                end
            end
        end
    end
    figure; imshow(norm_g); title('Image after Fixing Broken Edges');
%return
    %output = g_mag;
    output=norm_g;
end