function [is_need] = libsvmTest(flow,model)
%UNTITLED2 �˴���ʾ�йش˺����ժҪ
%   �˴���ʾ��ϸ˵��
u = flow(:,:,1);
v = flow(:,:,2);

params.blockNum = 5;
imageRow = size(u,1);
imageCol = size(v,2);

if mod(imageRow,params.blockNum) == 0
    windowSize(1) = imageRow/params.blockNum;
else
    rowMore = mod(imageRow,params.blockNum);
    imageRow = imageRow - rowMore;
    windowSize(1) = imageRow/params.blockNum;
end

if mod(imageCol,params.blockNum) == 0
    windowSize(2) = imageCol/params.blockNum;
else
    colMore = mod(imageCol,params.blockNum);
    imageCol = imageCol - colMore;
    windowSize(2) = imageCol/params.blockNum;
end
    
% ws = min(windowSize);
    wi = windowSize(1);
    wj = windowSize(2);
for i = 1:5
    for j = 1:5
        vx(i,j) = sum(sum(u((wi*(i-1)+1):(wi*i),(wj*(j-1)+1):(wj*j))))/(wi*wj);
        vy(i,j) = sum(sum(v((wi*(i-1)+1):(wi*i),(wj*(j-1)+1):(wj*j))))/(wi*wj);
%         vx(i,j) = mean(u((wi*(i-1)+1):(wi*i),(wj*(j-1)+1):(wj*j)));
%         vy(i,j) = mean(v((wi*(i-1)+1):(wi*i),(wj*(j-1)+1):(wj*j)));
    end
end

rad = sqrt(vx.^2+vy.^2);
rad = reshape(rad,25,1);
angle = atan(vy./vx);
angle = reshape(angle,25,1);
Vector = [rad;angle]';
is_need = svmpredict([1], Vector, model,'-q');

end

