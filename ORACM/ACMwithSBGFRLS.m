%function [time,itr,u] = ACMwithSBGFRLS(Img,show) 
    %Img = img_eq;
    show = 1;
    [row,col] = size(Img);
    %U er en logical og kan derfor kun være 0 og 1.
    u = uint8(255 * c);
    u = im2double(u);
    u(u==0)= -1;
    %u = -ones(row,col);
    %u(10:row-10,10:col-10) = 1;   
    sigma = 1; G = fspecial('gaussian', 5, sigma);
    delt = 1; mu = 10;itr = 0; 
    objPos = u >= 0; objNeg = ~objPos;
    Area1 = sum(u(:)); Area2 =0;
    if show, 
        figure;imshow(Img,[]); hold on; 
        contour(u, [0 0], 'r','LineWidth',4);hold on;
        contour(u, [0 0], 'g','LineWidth',1.3);hold on;
        title(['ACMwithSBGFRLS : ',int2str(itr),'th iteration, the total area of the object:',int2str(abs(Area2))]);axis off; 
    end    
    tic    
    while abs(Area2-Area1)>0      
        c1 = sum(sum(Img.*objNeg))/sum(sum(objNeg));
        c2 = sum(sum(Img.*objPos))/sum(sum(objPos));     
        spf = Img - (c1 + c2)/2;
        spf = spf/(max(abs(spf(:))));    
        [ux, uy] = gradient(u);
        u = u + delt*(mu*spf.*sqrt(ux.^2 + uy.^2));
        u = (u >= 0) - ( u< 0);
        u = conv2(u, G, 'same'); 
        objPos = u >= 0; objNeg = ~objPos;  
        Area1= Area2;  Area2 =sum(objPos(:)); 
        itr = itr + 1;
        if show,
            imshow(Img,[]); hold on; 
            contour(u, [0 0], 'r','LineWidth',4);hold on;
            contour(u, [0 0], 'g','LineWidth',1.3);hold on;
            title(['ACMwithSBGFRLS : ',int2str(itr),'th iteration, the total area of the object:',int2str(abs(Area2))]);axis off; 
            drawnow;
        end
    end  
    time = toc;
%end