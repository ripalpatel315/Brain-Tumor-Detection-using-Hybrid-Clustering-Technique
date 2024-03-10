clc;
clear all;
close all;
warning off;
i=imread('images\abnormal\chronic infarct with gliosis and cystic formation.jpg');
figure;imshow(i);title('Input Image')
if (size(i,3)==3)
    i_gray = rgb2gray(i);
end
i_gray_resized = im2double(imresize(i_gray,[128,128]));
figure;imshow(i_gray_resized);title('Resized Image')
i = i_gray_resized;
%%%%%%%%%%% median filetr %%%%%%%%%%%
J = imnoise(i,'salt & pepper',0.02);
figure ,imshow(J)
title('salt and pepper noise Image');
Kaverage = filter2(fspecial('average',3),J)/255;
figure
imshow(Kaverage)
Kmedian = medfilt2(J);
imshowpair(Kaverage,Kmedian,'montage')
title('Median filter Image');

%%%%%%%
cluster_n = 2;
data = double(i(:));
label_vector = kmeans(cluster_n,data);
bw_1 = reshape(label_vector,size(i));
figure;imshow(i,[]);title('Clustered Image')
%=============Performing Masking Operation=================%
i_mask = zeros(size(i));
for m = 1 : size(i,1)
    for n = 1 : size(i,2)
        p = bw_1(m,n);
        if(p==1)
            i_mask(m,n)=i(m,n);
        end
    end
end
figure;imshow(i_mask,[]);title('Clustered Image')
cluster_n = 3;
data = double(i_mask(:));
data = fcm_clus_n(data,cluster_n,i_mask);
i_fcm = reshape(data,size(i_mask,1),size(i_mask,2));
figure;imshow(i_fcm,[]);title('Clustered Image');