function [ matrix_split_output_cell ] = SplitData_yg( matrix_split_input_cell,fold_num )
%SPLITDATA Summary of this function goes here
%   Detailed explanation goes here
    matrix_split_output_cell = cell(size(matrix_split_input_cell,1),fold_num);
    for j = 1:size(matrix_split_input_cell,1) %iterate matrice which are going to be split
        [row,col,val] = find(matrix_split_input_cell{j,1}~=0);
        each_fold_element_num = floor(length(row)/fold_num);
        for i = 1:fold_num %iterate all folds
            matrix_part = zeros(size(matrix_split_input_cell{j,1}));
            start_idx = (i-1)*each_fold_element_num+1;
            end_idx = i*each_fold_element_num;
            if i==fold_num
                end_idx = length(row);
            end
            for k = start_idx:end_idx
                matrix_part(row(k),col(k)) = val(k);
            end
            matrix_split_output_cell{j,i} = matrix_part;            
        end
    end

end

