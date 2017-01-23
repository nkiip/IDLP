function [ best_parameter_array ] = Get_best_parameter(evaluation_result, distinct_parameter_num, cv_criteria)
    
% each column:[AUC50;AUC100;AUC200] 

    if strcmp(cv_criteria,'AUC20') == 1
     [M,I]  = max(evaluation_result(1,:));    
     elseif strcmp(cv_criteria,'AUC50') == 1
     [M,I]  = max(evaluation_result(2,:));
    elseif strcmp(cv_criteria,'AUC100') == 1
     [M,I]  = max(evaluation_result(3,:));     
    elseif strcmp(cv_criteria,'AUC300') == 1
     [M,I]  = max(evaluation_result(4,:));       
    end
    best_parameter_array = evaluation_result(end-distinct_parameter_num+1:end,I);
end

