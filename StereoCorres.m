clear
%% Load images
left = imread('flowers-left.png');
right = imread('flowers-right.png');
% figure, imshow(left);
% title('left image');
% figure, imshow(right);
% title('right image');

%% Convert to grayscale, double, [0, 1] range for easier computation
left_gray = double(rgb2gray(left)) / 255.0;
right_gray = double(rgb2gray(right)) / 255.0;

%% Define image patch location (topleft [row col]) and size
patch_loc = [96 136];
patch_size = [100 100];

%% Extract patch (from left image)
patch_left = left_gray(patch_loc(1):(patch_loc(1) + patch_size(1) - 1), patch_loc(2):(patch_loc(2) + patch_size(2) - 1));
strip_left = left_gray(patch_loc(1):(patch_loc(1) + patch_size(1) - 1), :);
%figure, imshow(patch_left);
%title('patch from left img');

%% Extract strip (from right image)
strip_right = right_gray(patch_loc(1):(patch_loc(1) + patch_size(1) - 1), :);
%figure, imshow(strip_right);
%title('strip from right image');

%% Now look for the patch in the strip and report the best position (column index of topleft corner)
best_x = find_best_match(patch_left, strip_right);
disp(strcat('best_x: ',num2str(best_x)));
patch_right = right_gray(patch_loc(1):(patch_loc(1) + patch_size(1) - 1), best_x:(best_x + patch_size(2) - 1));
%figure, imshow(patch_right);
%title('function one');

best_x2 = find_best_match2(patch_left, strip_right);
disp(strcat('best_x2: ',num2str(best_x2)));
patch_right2 = right_gray(patch_loc(1):(patch_loc(1) + patch_size(1) - 1), best_x2:(best_x2 + patch_size(2) - 1));
%figure, imshow(patch_right2);
%title('function two');
i = 3;
j = 6;
k = 7;

figure;
subplot(i,j,[1:3]), imshow(strip_left);
title('Left Camera Strip');
subplot(i,j,[4:6]), imshow(strip_right);
title('Right Camera Strip');
subplot(i,j,[k:(k + 1)]), imshow(patch_left);
k = k + 2;
title({'Patch from Left Camera Strip',strcat('(A) x pixel Loc:',num2str(patch_loc(2)))});
subplot(i,j,[k:(k + 1)]), imshow(patch_right);
k = k + 2;
stra = sprintf('\t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t Best Match Patch');
title({stra,'Normalized Cross Correlation',strcat('best x pixel Loc:',num2str(best_x))});
subplot(i,j,[k:(k + 1)]), imshow(patch_right2);
k = k + 2;
strb = sprintf('on Right Camera Strip \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t ');
title({strb,'Minimum Squared Difference',strcat('best x pixel Loc:',num2str(best_x2))});


%% Define image patch location (topleft [row col]) and size
patch_loc = [120 170];
patch_size = [100 100];

%% Extract patch (from left image)
patch_left = left_gray(patch_loc(1):(patch_loc(1) + patch_size(1) - 1), patch_loc(2):(patch_loc(2) + patch_size(2) - 1));
strip_left = left_gray(patch_loc(1):(patch_loc(1) + patch_size(1) - 1), :);
%figure, imshow(patch_left);
%title('patch from left img');

%% Extract strip (from right image)
strip_right = right_gray(patch_loc(1):(patch_loc(1) + patch_size(1) - 1), :);
%figure, imshow(strip_right);
%title('strip from right image');

%% Now look for the patch in the strip and report the best position (column index of topleft corner)
best_x = find_best_match(patch_left, strip_right);
disp(strcat('best_x: ',num2str(best_x)));
patch_right = right_gray(patch_loc(1):(patch_loc(1) + patch_size(1) - 1), best_x:(best_x + patch_size(2) - 1));
%figure, imshow(patch_right);
%title('function one');

best_x2 = find_best_match2(patch_left, strip_right);
disp(strcat('best_x2: ',num2str(best_x2)));
patch_right2 = right_gray(patch_loc(1):(patch_loc(1) + patch_size(1) - 1), best_x2:(best_x2 + patch_size(2) - 1));
%figure, imshow(patch_right2);
%title('function two');
subplot(i,j,[k:(k + 1)]), imshow(patch_left);
k = k + 2;
title(strcat('(B) x pixel Loc:',num2str(patch_loc(2))));
subplot(i,j,[k:(k + 1)]), imshow(patch_right);
k = k + 2;
title(strcat('best x pixel Loc:',num2str(best_x)));
subplot(i,j,[k:(k + 1)]), imshow(patch_right2);
k = k + 2;
title(strcat('best x pixel Loc:',num2str(best_x2)));

% Test code:
% Find best match
function best_x = find_best_match(patch, strip)
    % TODO: Find patch in strip and return column index (x value) of topleft corner
    corr = normxcorr2(patch, strip);
    %[x,y] = meshgrid(1:size(corr,2),1:size(corr,1));
    %surf(x,y,corr);
    [ypeak, xpeak] = find(corr == max(corr(:)));
    %disp(strcat('ypeak: ',num2str(ypeak),' xpeak: ',num2str(xpeak)));
    %disp(size(patch));
    %disp(size(strip));
    best_x = xpeak - size(patch,2) + 1; % placeholder
end

function best_x = find_best_match2(patch, strip)
    % TODO: Find patch in strip and return column index (x value) of topleft corner
    min_sq_diff = Inf;
    best_x = 0;
    for x = 1:(size(strip,2) - size(patch,2))
        other_patch = strip(:,x:(x+size(patch,2)-1));
        diff = patch - other_patch;
        sq_diff = sum(sum(diff.*diff));
        if sq_diff < min_sq_diff
            min_sq_diff = sq_diff;
            best_x = x;
        end
    end
end