function [ Y_hat ] = Get_Y_hat_allFolds( gene_phenotype_matrix, phenotype_similarity_matrix )
%GET_Y_PRINCE_ALLFOLDS Summary of this function goes here
%   Detailed explanation goes here
      
    Y_hat = Initialize_Y_prince(gene_phenotype_matrix, phenotype_similarity_matrix);
    
end

