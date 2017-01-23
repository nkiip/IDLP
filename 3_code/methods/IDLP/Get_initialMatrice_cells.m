function initialMatrice_cells = Get_initialMatrice_cells(initialMatrice_parameter_cell)
 %   initialMatrice_parameter_cell = {initialMatrixFile_num; ncbi_gene_id; phenotype_id};
    initialMatrice_num = initialMatrice_parameter_cell{1,1};
    ncbi_gene_id = initialMatrice_parameter_cell{2,1};
    phenotype_id = initialMatrice_parameter_cell{3,1};
    allGene_num = length(ncbi_gene_id);
    allPhenotype_num = length(phenotype_id);
    initialMatrice_cells = cell(1,initialMatrice_num);
    for i=1:initialMatrice_num
        initialMatrice_cells{1,i} = rand(allGene_num,allPhenotype_num);
    end

end

