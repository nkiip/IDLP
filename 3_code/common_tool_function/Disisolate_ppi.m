function [ ppi_ppi ] = Disisolate_ppi( ppi_ppi )
    for i = 1:size(ppi_ppi,1)
        sumi = sum(ppi_ppi(i,:));
        if(sumi==0)
           ppi_ppi(i,:) = 1/size(ppi_ppi,1); 
            
        end
        
    end
end

