function [img_samples] = findForegroundVideo(img_samples , init_sz ,param )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
% groundArea = init_sz(1)*init_sz(2);
for loop=1:size(img_samples,4)

if nargin<3
    param.colorChannels = 'RGB';
    param.blurSigma = .045; 
    param.mapWidth = 64;
    param.resizeToInput = 1; 
    param.subtractMin = 1; 
end

im = img_samples(:,:,:,loop);
if size(im,3) ~= 1
    img = rgb2gray(im);
else
    img = im;
end


% read in file if img is filename
if ( strcmp(class(img),'char') == 1 ) img = imread(img); end

% convert to double if image is uint8
if ( strcmp(class(img),'uint8') == 1 ) img = double(img)/255; end


img = imresize(img, param.mapWidth/size(img, 2));

numChannels = size( img , 3  );

if ( numChannels == 3 )
  
  if ( isequal( lower(param.colorChannels) , 'lab' ) )
    
    labT = makecform('srgb2lab');
    tImg = applycform(img, labT);
    
  elseif ( isequal( lower(param.colorChannels) , 'rgb' ) )
    
    tImg = img;
    
  elseif ( isequal( lower(param.colorChannels) , 'dkl' ) )
    
    tImg = rgb2dkl( img );
    
  end

else
  
  tImg = img;

end

cSalMap = zeros(size(img));  

for i = 1:numChannels
  cSalMap(:,:,i) = idct2(sign(dct2(tImg(:,:,i)))).^2;
end

outMap = mean(cSalMap, 3);

if ( param.blurSigma > 0 )
  kSize = size(outMap,2) * param.blurSigma;
  outMap = imfilter(outMap, fspecial('gaussian', round([kSize, kSize]*4), kSize));
end

if ( param.resizeToInput )
  outMap = imresize( outMap , [ size(im,1) size(im,2) ] );
end
  
% outMap = mynorm( outMap , param );
if ( param.subtractMin )
  outMap = mat2gray(outMap);
else
  outMap = outMap / max(outMap(:));
end

%获得图像显著区域
Fore = zeros(size(im,1),size(im,2));
% Fore(find(outMap(:,:)>0.3)) = 1;
Index = find(outMap(:,:)>0.1);
Fore(Index) = 1;

%筛选显著区域
imLabel = bwlabel(Fore); 
index = imLabel(round(0.5*size(im,1)),round(0.5*size(im,2)));

if index>0 %判断目标区域有木有
Fore = ismember(imLabel,index);          %获取最大连通域图像
% area = bwarea(Fore)/groundArea;

%删除图像背景区域
for i =1:size(im,1)
    for j = 1:size(im,2)
        if Fore(i,j) == 0
            im(i,j,:) = 0;
        end
    end
end
% figure(10);imshow(im)
end
img_samples(:,:,:,loop) = im;

end

