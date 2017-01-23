function [ Y_hat_folds_cell ] = Get_Y_hat_folds( matrix_split_output_cell, phenotype_similarity_matrix )
%GET_Y_PRINCE_FOLDS Summary of this function goes here
%   Detailed explanation goes here
    [~,fold_num] = size(matrix_split_output_cell);
    Y_hat_folds_cell = cell(1,fold_num);
    for i=1:fold_num
        matrix_mergeFolds_cell_train = MergeData(matrix_split_output_cell,i);%merge folds except i-th fold 
        gene_phenotype_matrix = matrix_mergeFolds_cell_train{1,1};
        Y_hat = Initialize_Y_prince(gene_phenotype_matrix, phenotype_similarity_matrix);
        Y_hat_folds_cell{1,i} = Y_hat;
    end

end