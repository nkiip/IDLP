function [ z ] = AUC(Rank, n)
    Rank=Rank';
    loop = size(Rank, 1);%行数
    numerator = 0;
    TP = 0;
    FP = 0;
	AllTP = length(find(Rank == 1));%所有正样本数
    
    for i = 1 : loop
        if (Rank(i, 1) == 1)
            TP = TP + 1;%true positive预测为正的正样本
        else
            FP = FP + 1;%false positive预测为正的负样本
            numerator = numerator + TP;%？？？
        end
        
        if (FP >= n)%当有n个预测为正的负样本时，即前？个中有n个0时
            break;
        end
    end
    
%   denominator = sum(find(topn(j,:) == 0)) - Num_Positive * (Num_Positive + 1) / 2;
    denominator = FP * AllTP;
    if (numerator == 0)
        z = 0;
    else
        z = numerator / denominator ;
    end


end

