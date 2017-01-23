function [matrix_split_output_cell] = SplitData_liu( matrix_split_input_cell,fold_num )
%split matrix in fold_num pieces
    matrix_split_output_cell = cell(size(matrix_split_input_cell,1),fold_num);
    for j = 1:size(matrix_split_input_cell,1)
        for i = 1:fold_num
            if(i==fold_num)
                matrix_split_output_cell{j,i} = matrix_split_input_cell{j,1};
                break;
            end
            [row,col,val] = find(matrix_split_input_cell{j,1}~=0);
            %用于生成随机数
            rand_array = randperm(length(row));    
            matrix_part = zeros(size(matrix_split_input_cell{j,1}));
            for k = 1:(length(rand_array)/fold_num)
                matrix_part(row(rand_array(k)),col(rand_array(k))) = val(rand_array(k));
            end
             matrix_split_output_cell{j,i} = matrix_part;
             matrix_split_input_cell{j,1} = matrix_split_input_cell{j,1} - matrix_part;
        end
    end
end
