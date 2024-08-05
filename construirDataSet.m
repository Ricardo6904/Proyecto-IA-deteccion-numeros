function [DataSet] = construirDataSet(images,labels)
[row,col,n]=size(images);
 for k=1:n
     imagenGrises=images(:,:,k);
     region = regionprops(imagenGrises,'Area','centroid','BoundingBox');
     areaMaxima=max([region.Area]);
     indices = find([region.Area]==areaMaxima);
     valores=region(indices,1).BoundingBox;
     imagenRecortada = imcrop(imagenGrises,valores);
     redimensionImagen=imresize(imagenRecortada,[28,28]);
     imagenBinario=imbinarize(redimensionImagen);
     xData(k,:) = reshape(imagenBinario,1,[]);
 end
 xDataSet = cast(xData,'double');
 yDataSet=labels;
 DataSet=[xDataSet,yDataSet];
end