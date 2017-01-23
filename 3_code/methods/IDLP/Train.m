function [learned_matrix_cell] = Train(cv_train_parameter_cell, matrix_cell_train, ...,
                                    matrix_folds_cell_train,initialMatrix_cell,fold_idx)
   % cv_train_parameter_cell = {best_parameter_array; matrix_cv_split_idx; fold_num; 
   %                              distinct_parameter_num; evaluation_index_num};
   %matrix_cell_train = {gene_phenotype_matrix_old; phenotype_similarity_matrix; ppi_matrix; 
   %                     ncbi_gene_id; phenotype_id};
   %matrix_folds_cell_train = matrix_cell_train(matrix_cv_split_idx,1);
   %initialMatrix_cell = initialMatrix_cell = initialMatrice_cells{:,i};
   alpha = cv_train_parameter_cell{1,1}(1,1);
   beta = 1-alpha;
   gamma = cv_train_parameter_cell{1,1}(2,1);
   alphaPrime = cv_train_parameter_cell{1,1}(3,1);
   betaPrime = 1 - alphaPrime;
   gammaPrime = cv_train_parameter_cell{1,1}(4,1);
   max_ite = cv_train_parameter_cell{end-4+1,1};
   
   gene_phenotype_matrix_old = matrix_folds_cell_train{1,1};
   phenotype_similarity_matrix = matrix_cell_train{2,1};
   ppi_matrix = matrix_cell_train{3,1};
   Y_prince_folds_cell = matrix_cell_train{7,1};
   %ncbi_gene_id = matrix_cell_train{4,1};
   %phenotype_id = matrix_cell_train{5,1};
   
   W1 = Disisolate_ppi(ppi_matrix);
   D1 = diag(1./sqrt(sum(W1,2)));%    D1 = diag(sum(W1,2));
   S1_hat = D1*W1*D1;   %S1_hat = D1^(-0.5) * W1 * D1^(-0.5);
   W2 = phenotype_similarity_matrix; 
   D2 = diag(1./sqrt(sum(W2,2)));
   S2_hat = D2*W2*D2;  
   
   Y = initialMatrix_cell{1,1};
   [all_gene_num, all_phenotype_num] = size(Y);
   Y_hat = Y_prince_folds_cell{1,fold_idx};
   %Y_hat = 1./(1+exp((-15*Y_hat)+log(9999)));
   for i = 1:max_ite
       S1 = S1_hat + gamma*Y*Y';
       A = (eye(all_gene_num)-alpha*S1);
       B = A\eye(all_gene_num); %A*B=I, pinv(A) is equivelent to A\eye(allGene_num), but much slower
       Y = beta*B*Y_hat;
       S2 = S2_hat + gammaPrime*Y'*Y;
       AA = eye(all_phenotype_num)-alphaPrime*S2;
       BB = AA\eye(all_phenotype_num);       
       Y = betaPrime * Y_hat * BB;
   end   
   learned_matrix_cell = {Y;S1;S2};
end

