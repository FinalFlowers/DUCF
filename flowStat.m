function [maxFlow] = flowStat(flow)
%函数功能：统计光流直方图
%输入：光流 flow  x方向：flow(:,:,1)    y方向：flow(:,:,2)
%输出：最大光流幅值maxFlow
UNKNOWN_FLOW_THRESH = 1e9;
% UNKNOWN_FLOW = 1e10;            % 

[~, ~, nBands] = size(flow);

if nBands ~= 2
    error('flowToColor: image must have two bands');    
end    

u = flow(:,:,1);
v = flow(:,:,2);

% fix unknown flow
idxUnknown = (abs(u)> UNKNOWN_FLOW_THRESH) | (abs(v)> UNKNOWN_FLOW_THRESH) ;
u(idxUnknown) = 0;
v(idxUnknown) = 0;

rad = sqrt(u.^2+v.^2);

flowHist = zeros(1,10);
data = 0.5:0.5:5;
num = size(u,1)*size(u,2);
for i = 1:num
    if rad(i)<0.5
        flowHist(1) = flowHist(1) + 1;
    elseif rad(i)<1
        flowHist(2) = flowHist(2) + 1;
    elseif rad(i)<1.5
        flowHist(3) = flowHist(3) + 1;
    elseif rad(i)<2
        flowHist(4) = flowHist(4) + 1;
    elseif rad(i)<2.5
        flowHist(5) = flowHist(5) + 1;
    elseif rad(i)<3
        flowHist(6) = flowHist(6) + 1;
    elseif rad(i)<3.5
        flowHist(7) = flowHist(7) + 1;
    elseif rad(i)<4
        flowHist(8) = flowHist(8) + 1;
    elseif rad(i)<4.5
        flowHist(9) = flowHist(9) + 1;
    else
        flowHist(10) = flowHist(10) + 1;
    end
end

    [~,index] = max(flowHist(:));
    maxFlow = data(index);
    
end

