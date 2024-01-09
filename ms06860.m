I = imread('mandi.tif');
I2 = demosaic(I,'bggr');
I3 = bggr_demosaic(I);
subplot(3,1,1);
imshow(I);title('Original Image');
subplot(3,1,2);
imshow(I2);title('MATLAB provided demosaic function');
subplot(3,1,3);
imshow(I3);title('Assignment 2 Demosaic function')

%%
function d_image = bggr_demosaic(img)
    [H,W] = size(img);
    %creating three channels
    R = uint8(zeros([H,W]));
    G = uint8(zeros([H,W]));
    B = uint8(zeros([H,W]));
    
    for i=1:H
        for j=1:W
            if mod(j,2)==1
                if mod(i,2)==1
                    %Blue pixel
                    B(i,j) = img(i,j);
                    %G value at B pixel
                    G_B = [0 0 -1 0 0; 0 0 2 0 0;-1 2 4 2 -1;0 0 2 0 0;0 0 -1 0 0];
                    G(i,j) = filt(img,i,j,G_B);
                    %R value at B pixel
                    R_B = [0 0 -3/2 0 0; 0 2 0 2 0;-3/2 0 6 0 -3/2;0 2 0 2 0;0 0 -3/2 0 0];
                    R(i,j) = filt(img,i,j,R_B);
                else
                    %Green pixel G1
                    G(i,j) = img(i,j);
                    %R value at G1 pixel
                    R_G1 = [0 0 1/2 0 0;0 -1 0 -1 0;-1 4 5 4 -1;0 -1 0 -1 0;0 0 1/2 0 0];
                    R(i,j) = filt(img,i,j,R_G1);
                    %B value at G1 pixel
                    B_G1 = [0 0 -1 0 0;0 -1 4 -1 0;1/2 0 5 0 1/2;0 -1 4 -1 0;0 0 -1 0 0];
                    B(i,j) = filt(img,i,j,B_G1);
                end
            else
                if mod(i,2)==0
                    %Red pixel
                    R(i,j) = img(i,j);
                    %G value at R pixel
                    G_R = [0 0 -1 0 0;0 0 2 0 0; -1 2 4 2 -1;0 0 2 0 0; 0 0 -1 0 0];
                    G(i,j) = filt(img,i,j,G_R);
                    %B value at R pixel
                    B_R = [0 0 -3/2 0 0; 0 2 0 2 0; -3/2 0 6 0 -3/2; 0 2 0 2 0; 0 0 -3/2 0 0];
                    B(i,j) = filt(img,i,j,B_R);
                else
                    %Green pixel G2
                    G(i,j) = img(i,j);
                    %B value at G2
                    B_G2 = [0 0 1/2 0 0;0 -1 0 -1 0;-1 4 5 4 -1;0 -1 0 -1 0;0 0 1/2 0 0];
                    B(i,j) = filt(img,i,j,B_G2);
                    %R value at G2
                    R_G2 = [0 0 -1 0 0;0 -1 4 -1 0;1/2 0 5 0 1/2;0 -1 4 -1 0;0 0 -1 0 0];
                    R(i,j)=filt(img,i,j,R_G2);
                end
            end
        end
    end
    d_image = cat(3,R,G,B);
end

%%

function value = filt(img,r,c,filter)
    [H,W] = size(img);

    %removing extra rows from filter if they fall outside the image
    if r-2<1
        filter(1,:) = [0 0 0 0 0]; 
    end
    if r-1<1
        filter(2,:) = [0 0 0 0 0];
    end
    if r+2>H
        filter(5,:) = [0 0 0 0 0];
    end
    if r+1>H
        filter(4,:) = [0 0 0 0 0];
    end

    %removing extra columns
    if c-2<1
        filter(:,1) = [0;0;0;0;0];
    end
    if c-1<1
        filter(:,2) = [0;0;0;0;0];
    end
    if c+1>W
        filter(:,4) = [0;0;0;0;0];
    end
    if c+2>W
        filter(:,5) = [0;0;0;0;0];
    end
    
    sum=0; %accumulator
    count=0; %variable to store the normalization variable
    for i=1:5
        for j=1:5
            if filter(i,j)~=0
                %applying the filter at non zero values of the filter
                v = filter(i,j)*double(img(r+i-3,c+j-3));
                count = count+filter(i,j);
                sum = sum+v;
            end
        end
    end
    value=sum/count;
end







