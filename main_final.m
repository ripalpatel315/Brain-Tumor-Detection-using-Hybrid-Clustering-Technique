clc;
clear all;
close all;
warning off;
load net
[f,p]=uigetfile('*.*','Load Image');
pf = [p,f];
i=imread(pf);
%i=imread('images\abnormal\chronic infarct with gliosis and cystic formation.jpg');
figure;imshow(i);title('Input Image')
if (size(i,3)==3)
    i_gray = rgb2gray(i);
end
i_gray_resized = im2double(imresize(i_gray,[128,128]));
figure;imshow(i_gray_resized);title('Resized Image')
i = i_gray_resized;
%%%%%%%%%%% median filetr %%%%%%%%%%%
J = imnoise(i,'salt & pepper',0.02);
figure 
imshow(J)
title('salt and pepper noise Image');
Kaverage = filter2(fspecial('average',3),J)/255;
figure
imshow(Kaverage)
Kmedian = medfilt2(J);
imshowpair(Kaverage,Kmedian,'montage')
title('Median filter Image');

%%%%%%%
tic;
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
toc;
tic;
cluster_n = 3;
data = double(i_mask(:));
data = fcm_clus_n(data,cluster_n,i_mask);
i_fcm = reshape(data,size(i_mask,1),size(i_mask,2));
figure;imshow(i_fcm,[]);title('Clustered Image');
%==================Extracting 3rd cluster===============%
bw2 = false(size(i_fcm));
for m = 1 : size(i_fcm,1)
    for n = 1 : size(i_fcm,2)
        if(i_fcm(m,n)==cluster_n)
            bw2(m,n)=true;
        end
    end
end
bw2 = bwlabel(bw2);
figure;imshow(bw2,[]);title('Clustered Image');
toc;
a = regionprops(bw2,'area');
for m = 1 : length(a)
    all_area(m) = a(m).Area;
end
[max_area,idx] = max(all_area);
bw3 = ismember(bw2,idx); 
figure;imshow(bw3,[]);title('Clustered Image');
i_mask_final = zeros(size(bw3));
for m = 1 : size(bw3,1)
    for n = 1 : size(bw3,2)
        p = bw3(m,n);
        if(p==true)
            i_mask_final(m,n)=i_mask(m,n);
        end
    end
end
figure;imshow(i_mask_final,[]);title('Clustered Image');
cnt = 0;
for m = 1 : size(i_mask_final,1)
    for n = 1 : size(i_mask_final,2)
        p = i_mask_final(m,n);
        if(p~=0)
            cnt = cnt + 1;
            pix_all(cnt) = p;
            out_all(cnt) = p^2;
            out_all_h(cnt) = p/(1+m+n);
            out_all_d(cnt) = p*(m-n);
        else
        end
    end
end
E = sum(out_all);
C = mean(out_all);
H = sum(out_all_h);
En = entropy(pix_all);
D = sum(out_all_d);
toc;