function [ mask ] = ColorMask( img, color, threshold )
%ColorMask Generate color mask
mask = false(size(img,1), size(img,2));
dimg = double(img);
diff(:,:,1) =  dimg(:,:,1)- color(1);
diff(:,:,2) = dimg(:,:,2) - color(2);
diff(:,:,3) = dimg(:,:,3) - color(3);
total = sum(diff.^2,3);
mask(total < threshold) = true;


end

