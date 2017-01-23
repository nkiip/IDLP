function best_initialMatrixArray_idx = Get_best_initialMatrixArray_idx(evaluation_initialMatrice_result_bestPara,cv_criteria)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    if strcmp(cv_criteria,'AUC50') == 1
        [M,I]  = max(evaluation_initialMatrice_result_bestPara(1,:));        
    elseif strcmp(cv_criteria,'AUC100') == 1
        [M,I]  = max(evaluation_initialMatrice_result_bestPara(2,:));     
    elseif strcmp(cv_criteria,'AUC200') == 1
        [M,I]  = max(evaluation_initialMatrice_result_bestPara(3,:));     
    end
    best_initialMatrixArray_idx = I;
end

