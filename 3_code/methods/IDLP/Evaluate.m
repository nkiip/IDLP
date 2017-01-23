function [ AUC_vec ] = Evaluate(learned_matrix_cell, evaluation_index_num, matrix_cell_evaluate)
%EVALUATE Summary of this function goes here
%   Detailed explanation goes here
    % learned_matrix_cell = {Y;S1;S2}
    Y = learned_matrix_cell{1,1};
    %matrix_cell_test = {gene_phenotype_matrix_newAdded};
    gene_phenotype_matrix_newAdded =  matrix_cell_evaluate{1,1};
   % path(path,'../../common_tool_function');
    cAUC = zeros(1,evaluation_index_num);
    phenotype_gene_newAdded =  gene_phenotype_matrix_newAdded';
    phenotype_gene_score_matrix = Y';
    [~,avgAUC] = AUC_main(phenotype_gene_newAdded, phenotype_gene_score_matrix);
    cAUC(1,:) = avgAUC;

    %save ('result.mat','phenotype_gene_score_matrix','cROC');
    AUC_vec =cAUC';
end

