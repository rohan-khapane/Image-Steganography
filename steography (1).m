
clc;
clear all;
close all;
%cover=imread("flower.jpg");
%message=imread("school.jpg");
cover = imread(input('Enter cover image: ', 's'));
message = imread(input('Enter message image name: ', 's'));


n = input('Enter the no of LSB bits to be subsituted- '); 
x=rgb2gray(cover);
y=rgb2gray(message);

% Resize one of the images to match the size of the other
if ~isequal(size(x), size(y))
    % Determine which image needs resizing based on the desired size
    if numel(x) > numel(y)
        desiredSize = size(y);
        x = imresize(x,desiredSize);
        size(x)
    else
        y = imresize(y, size(x));
        size(y)
    end
end

S = uint8(bitor(bitand(x,bitcmp(2^n-1,'uint8')),bitshift(y,n-8))); %Stego
imwrite(S, 'output.jpg');

E = uint8(bitand(255,bitshift(S,8-n))); %Extracted3
origImg = double(y);   %message image
distImg = double(E);   %extracted image
[M N] = size(origImg);
distImg1=imresize(distImg,[M N]);

error = origImg - distImg1;
MSE = sum(sum(error .* error)) / (M * N);
disp('MSE is')
disp(abs(MSE))
figure(1),subplot(2,1,1);imshow(x);title('1.Cover image')
figure(1),subplot(2,1,2);imshow(y);title('2.Message to be hide')

figure(3),imshow((abs(S)),[]);title('3.Stegnographic image')
figure(4),imshow(real(E),[]); title('4.Extracted image')

figure(5),subplot(2,1,1);imhist(x);title('Histogram of cover image')
figure(5),subplot(2,1,2);imhist(S); title('Histogram of transformed stego image')