clear;
path(path,'../../../2_useful_data');
path(path,'../../common_tool_function');
%%%%%%%%%%%%%%%%%%%% load data file %%%%%%%%%%%%%%%%%%%%%%
file_date_time = '2015_8&2016_12';
%GP_file_name = ['G_P_network_mappingkey13_' file_date_time '.mat'];
ppi_key_word = 'ppi20d_';%total_new_
GP_file_name = ['G_P_network_' ppi_key_word 'mappingkey13_' file_date_time '.mat'];

load(GP_file_name,'gene_phenotype_matrix_old', 'gene_phenotype_matrix_newAdded', 'phenotype_similarity_matrix'...,
    ,'ppi_matrix', 'ncbi_gene_id','phenotype_id');
%ppi_matrix = ppi_matrix - diag(diag(ppi_matrix));
%phenotype_similarity_matrix = phenotype_similarity_matrix - diag(diag(phenotype_similarity_matrix));
%phenotype_similarity_matrix = 1./(1+exp((-15*phenotype_similarity_matrix)+log(9999)));
%%%%%%%%%%%%%%%%%%%% load data file %%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% input parameter assignment %%%%%%%%%%%%%%%
alpha_set = [0.1];
%beta_set = 1 - alpha;
gamma_set = [1000];%
alphaPrime_set = [0.1];%
%betaPrime_set = 1 - alpha_prime;
gammaPrime_set = [1000];%
fold_num = 5;
distinct_parameter_num = 4;
index_cell = {'AUC20';'AUC50';'AUC100'}; 
cv_criteria = 'AUC20';
matrix_cv_split_idx = [1];% this variable corresponding to variable 'matrix_cell_train'.
initialMatrice_num = 10; 
initialMatrice_used_num = 1; 
max_ite = 20;
% 1:gene_phenotype_matrix_old;2:phenotype_similarity_matrix
%%%%%%%%%%%%%%%%%%%% input parameter assignment %%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% prepare data cell %%%%%%%%%%%%%%%%%%%
input_parameter_cell = {alpha_set; gamma_set; alphaPrime_set; gammaPrime_set; ...,
    distinct_parameter_num; fold_num; index_cell; cv_criteria; matrix_cv_split_idx; max_ite};
matrix_cell_test = {gene_phenotype_matrix_newAdded};
matrix_split_input_cell = {gene_phenotype_matrix_old};
useful_data_dir = '../../../2_useful_data/';
filename = [useful_data_dir 'matrix_split_output_cell_' num2str(fold_num) 'folds.mat'];
if exist(filename,'file')
    load(filename,'matrix_split_output_cell');
else   
    [ matrix_split_output_cell ] = SplitData( matrix_split_input_cell,fold_num );
    %Y_hat = Initialize_Y_prince(gene_phenotype_matrix, phenotype_similarity_matrix);    
    save(filename,'matrix_split_output_cell');
end
filename = ['Y_hat_cell_' num2str(fold_num) 'folds.mat'];
if exist(filename,'file')
    load(filename,'Y_hat_folds_cell');
else
    
    Y_hat_folds_cell = Get_Y_hat_folds(matrix_split_output_cell, phenotype_similarity_matrix);
    %Y_hat = Initialize_Y_prince(gene_phenotype_matrix, phenotype_similarity_matrix);
    Y_hat_folds_cell{1,fold_num+1}= Get_Y_hat_allFolds( gene_phenotype_matrix_old, phenotype_similarity_matrix );
    save(filename,'Y_hat_folds_cell');
end

%matrix_mergeFolds_cell_train = MergeData(matrix_split_output_cell,1); 
matrix_cell_train = {gene_phenotype_matrix_old; phenotype_similarity_matrix; ppi_matrix; ncbi_gene_id; phenotype_id;...,
                    matrix_split_output_cell;Y_hat_folds_cell};
%%%%%%%%%%%%%%%%%%%% prepare data cell %%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% initialize matrix with random value %%%%%%%%%%%%%%%  
initialMatrice_parameter_cell = {initialMatrice_num; ncbi_gene_id; phenotype_id};
infilename = 'initialMatrice_cell.mat';
if ~exist(infilename, 'file')
    initialMatrice_cell = Get_initialMatrice_cells(initialMatrice_parameter_cell); 
    initialMatrice_cell{1,2} = gene_phenotype_matrix_old; % a special case of initial matrix
    save(['initialMatrice_cell' '.mat'], 'initialMatrice_cell');
else
    load(infilename, 'initialMatrice_cell');
end
initialMatrice_used_cell = initialMatrice_cell(1,1:initialMatrice_used_num);
%%%%%%%%%%%%%%%%%%%% initialize matrix with random value %%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% learning process %%%%%%%%%%%%%%%%%%%%%%
% using cross-validation to get the best parameter(s) for the methods
tic;
[learned_matrix_cell, best_parameter_array, evaluation_parameter_result] = Learn(input_parameter_cell, matrix_cell_train, ...,
    initialMatrice_used_cell);
toc;
result_file_dir = pwd; %get current directory full name 
%learn_result_cell = {learned_matrix_cell; best_parameter_array; evaluation_parameter_result};
file_key_word = file_date_time;
%result_file_name = [result_file_dir '/' 'result' '_' file_key_word '_' datestr(now,30) '.mat' ];  
result_file_name = [result_file_dir '/' 'result' '_' ppi_key_word file_key_word '_' datestr(now,30) '.mat' ];  

save(result_file_name, 'learned_matrix_cell', 'best_parameter_array', 'evaluation_parameter_result',...,
    'max_ite','initialMatrice_used_num','alpha_set','gamma_set','alphaPrime_set','gammaPrime_set');
%%%%%%%%%%%%%%%%%%%% learning process %%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% test process %%%%%%%%%%%%%%%%%%%%%%
tic;
    evaluation_index_num = length(index_cell);
    evaluation_test = Test(matrix_cell_test,learned_matrix_cell,evaluation_index_num);
    save(result_file_name, 'evaluation_test','-append');
toc;
%%%%%%%%%%%%%%%%%%%% test process %%%%%%%%%%%%%%%%%%%%%%
rmpath('../../../2_useful_data');
rmpath('../../common_tool_function');
