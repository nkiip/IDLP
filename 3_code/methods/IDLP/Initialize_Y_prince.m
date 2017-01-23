function [ Y_hat ] = Initialize_Y_prince( gene_phenotype_matrix, phenotype_similarity_matrix )
%INITIALIZE_Y_PRINCE Summary of this function goes here
%   Detailed explanation goes here
   [all_gene_num, all_phenotype_num] = size(gene_phenotype_matrix);
   Y_temp = zeros(size(gene_phenotype_matrix));
    for i = 1 : all_gene_num
        tmp = repmat(gene_phenotype_matrix(i,:),all_phenotype_num,1);
        temp2 = tmp.*phenotype_similarity_matrix;
        Y_temp(i,:) = max(temp2,[],2)';
    end
   %Y_hat = matrix_folds_cell_train{1,1};
   Y_hat = Y_temp; 

end

