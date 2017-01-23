function [learned_matrix_cell, best_parameter_array, evaluation_parameter_result] = Learn(input_parameter_cell, matrix_cell_train, ...,
    initialMatrice_cells)
    %%%%%%%%%%%%%%%%%%%%%%%%%% parsing parameters %%%%%%%%%%%%%%%%%%%%%%%%%%
    alpha_set = input_parameter_cell{1,1};
    %beta_set = 1 - alpha_set;
    gamma_set = input_parameter_cell{2,1};
    alphaPrime_set = input_parameter_cell{3,1};
    %betaPrime_set = 1 - beta_set;
    gammaPrime_set = input_parameter_cell{4,1};
    distinct_parameter_num = input_parameter_cell{5,1};
    fold_num = input_parameter_cell{6,1};
    index_cell = input_parameter_cell{7,1};
    cv_criteria = input_parameter_cell{8,1};
    matrix_cv_split_idx = input_parameter_cell{9,1};
    max_ite = input_parameter_cell{10,1};
    %%%%%%%%%%%%%%%%%%%%%%%%%% parsing parameters %%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%% cross-validation to choose best parameters  %%%%%%%%%%%%%%%%%%%%%%%%%%
    evaluation_index_num = length(index_cell);    
    evaluation_parameter_result = zeros(evaluation_index_num+distinct_parameter_num,...,
        length(alpha_set)*length(gamma_set)*length(alphaPrime_set)*length(gammaPrime_set));
    i = 1;
    for alpha = alpha_set
        for gamma = gamma_set
            for alphaPrime = alphaPrime_set
                for gammaPrime = gammaPrime_set    
%                     alphaPrime = alpha;
%                     gammaPrime = gamma;
                    cv_train_parameter_cell = {[alpha; gamma; alphaPrime; gammaPrime]; evaluation_index_num;...,
                        max_ite; matrix_cv_split_idx;...,
                        fold_num; distinct_parameter_num};
                    [tmp,~] = CrossValidation_Train(cv_train_parameter_cell, matrix_cell_train, ...,
                        initialMatrice_cells);
                    evaluation_parameter_result(1:end-distinct_parameter_num,i) = tmp;
                    evaluation_parameter_result(end - distinct_parameter_num+1:end,i) = [alpha, gamma, alphaPrime, gammaPrime];
                    i = i+1;
                end
            end
        end
    end        
    best_parameter_array = Get_best_parameter(evaluation_parameter_result,distinct_parameter_num,cv_criteria);       
    cv_train_parameter_cell_bestPara = {best_parameter_array; evaluation_index_num;...,
                        max_ite; matrix_cv_split_idx;...,
                        fold_num; distinct_parameter_num};    
    %[~,evaluation_initialMatrice_result_bestPara] = CrossValidation_Train(cv_train_parameter_cell_bestPara, matrix_cell_train, ...,
    %                    initialMatrice_cells);
    %choose best initial matrice
    %best_initialMatrixCell_idx = Get_best_initialMatrixArray_idx(evaluation_initialMatrice_result_bestPara,cv_criteria);
    best_initialMatrixCell_idx = 1;
    %%%%%%%%%%%%%%%%%%%%%%%%%% cross-validation to choose best parameters  %%%%%%%%%%%%%%%%%%%%%%%%%%     
     
    best_initialMatrix_cell = initialMatrice_cells(:,best_initialMatrixCell_idx);
    matrix_allFold_cell_train = matrix_cell_train(matrix_cv_split_idx,1);
%    file_name = [method_data_dir initial_matrixFileName_cell{i,1}];load(file_name);initial_matrix_cell = {W;H1;H2};
    fold_idx = fold_num+1;%0: it means all folds;
    [learned_matrix_cell] = Train(cv_train_parameter_cell, matrix_cell_train, matrix_allFold_cell_train,best_initialMatrix_cell,fold_idx);  
  
end

function  [evaluation_result_average,evaluation_initialMatrice_result] = CrossValidation_Train(cv_train_parameter_cell, matrix_cell_train, initialMatrice_cells)
%     cv_train_parameter_cell = {[alpha; gamma; alphaPrime; gammaPrime]; evaluation_index_num;...,
%                         max_ite; matrix_cv_split_idx;...,
%                         fold_num; distinct_parameter_num};    
    %evaluation_index_num = cv_train_parameter_cell{end,1};
    fold_num = cv_train_parameter_cell{end-2+1,1};   
    matrix_cv_split_idx = cv_train_parameter_cell{end-3+1,1};
    %max_ite = cv_train_parameter_cell{end-4+1,1};
    evaluation_index_num = cv_train_parameter_cell{end-5+1,1};
    
    %matrix_split_input_cell = matrix_cell_train(matrix_cv_split_idx,1);%if we need multiple matrix to be split, like:1-th and 3-th matrix,then matrix_cell_train([1,3],1)
    %matrix_split_output_cell = SplitData(matrix_split_input_cell,fold_num);
    matrix_split_output_cell = matrix_cell_train{6,1};
    %given a fixed parameters, return the average result of ten times' different initial matrix values     
    [~,initialMatrixCell_num] = size(initialMatrice_cells);
    evaluation_initialMatrice_result = zeros(evaluation_index_num, initialMatrixCell_num);
    for i=1:initialMatrixCell_num
        initialMatrix_cell = initialMatrice_cells(:,i);%initialMatrix_cell: a row cell vector that contain initial matrice
%         file_name = [method_data_dir initial_matrixFileName_cell{i,1}];load(file_name);initial_matrix_cell = {W;H1;H2};
        evaluation_folds_result = zeros(evaluation_index_num, fold_num);
        for j=1:fold_num
            matrix_oneFold_cell_validate = matrix_split_output_cell(:,j);
            matrix_mergeFolds_cell_train = MergeData(matrix_split_output_cell,j);   %delete the j-th fold data, merge the rest            
            [learned_matrix_cell] = Train(cv_train_parameter_cell, matrix_cell_train, matrix_mergeFolds_cell_train,initialMatrix_cell,j);    
            evaluation_folds_result(:,j) = Evaluate(learned_matrix_cell, evaluation_index_num, matrix_oneFold_cell_validate);        
        end
        %each initial matrix file corresponding to an average evaluation result on all fold data 
        evaluation_initialMatrice_result(:,i) = mean(evaluation_folds_result,2);        
    end
    evaluation_result_average = mean(evaluation_initialMatrice_result,2); % average the evaluation result on all initial matrix file
end