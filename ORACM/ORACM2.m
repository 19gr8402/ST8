function [time,itr] = ORACM2(Img,show)
 warning('off'); %#ok<WNOFF>
    [row,col] = size(Img);
    phi = ones(row,col); k = 10; 
    phi(k:row-k,k:col-k) = -1;
    obj = - phi; objPos = obj >= 0; objNeg = ~objPos;
    itr = 0; 
    Area1 = sum(objNeg(:)); Area2 =sum(objPos(:));
    if show, 
        figure;imshow(Img,[]); hold on; 
        contour(obj, [0 0], 'r','LineWidth',4);hold on; 
        contour(obj, [0 0], 'g','LineWidth',1.3);hold on; 
        title(['ORACM2 : ',int2str(itr),'th iteration, the total area of the object:',int2str(abs(Area2))]);axis off; 
        drawnow; 
    end
    tic
        while abs(Area2-Area1)>0                                            
            c1 = sum(sum(Img.*objNeg))/sum(sum(objNeg));
            c2 = sum(sum(Img.*objPos))/sum(sum(objPos)); 
            nImg = Img - (c1 + c2)/2;
            obj = nImg /max(abs(nImg(:)));            
            objPos = obj >= 0; 
            objPos=bwareaopen(objPos,20);
            objPos=imclose(objPos,strel('disk',3)); objNeg = ~objPos;            
            obj = objPos - objNeg;            
            Area1= Area2;  Area2 =sum(objPos(:));    
            itr = itr + 1;        
            if show,
                imshow(Img,[]); hold on; 
                contour(obj, [0 0], 'r','LineWidth',4);hold on; 
                contour(obj, [0 0], 'g','LineWidth',1.3);hold on; 
                title(['ORACM2 : ',int2str(itr),'th iteration, the total area of the object:',int2str(abs(Area2))]);axis off; 
                drawnow;
            end
        end
    time = toc;    
%     pause;
end