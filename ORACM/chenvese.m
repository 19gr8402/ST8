function [time,itr] = chenvese(I,show)
    k = 10; [row,col] = size(I);
    mask = zeros(row,col);
    mask (k:row-k,k:col-k)=1;    
    mu=0.2; itr = 0;
    phi0 = bwdist(mask)-bwdist(1-mask)+im2double(mask)-.5;         
    objPos = phi0 >= 0; objNeg = ~objPos;
    Area1 = sum(objNeg(:)); Area2 =sum(objPos(:));
    if show,
        figure();imshow(I);         
        contour(flipud(phi0), [0 0], 'r','LineWidth',4); hold on; 
        contour(flipud(phi0), [0 0], 'g','LineWidth',1.3); hold on; 
        title(['C-V : ',int2str(itr),'th iteration, the total area of the object:',int2str(abs(Area2))]);axis off;         
        drawnow;
    end

    tic
    while abs(Area2-Area1)>0.1   
        inidx = find(phi0>=0); % frontground index
        outidx = find(phi0<0); % background index
        force_image = 0; % initial image force for each layer                   
        c1 = sum(sum(I.*Heaviside(phi0)))/(length(inidx)+eps); % average inside of Phi0
        c2 = sum(sum(I.*(1-Heaviside(phi0))))/(length(outidx)+eps); % verage outside of Phi0
        force_image=force_image-(I-c1).^2+(I-c2).^2; 
        kphi0 = kappa(phi0); maxkphi0 = max(max(abs(kphi0)));
        force = force_image + mu*kphi0./maxkphi0;
        force = force./(max(max(abs(force))));        
        phi0 = phi0+force;        
        objPos=phi0(abs(phi0)<=.5);       
        Area1= Area2;  Area2 =sum(objPos(:));        
        itr = itr + 1; 
        if show,                   
            imshow(I,'initialmagnification','fit','displayrange',[0 255]);hold on;
            contour(phi0, [0 0], 'r','LineWidth',4);hold on; 
            contour(phi0, [0 0], 'g','LineWidth',1.3);hold on; 
            title(['C-V : ',int2str(itr),'th iteration, the total area of the object:',int2str(abs(Area2))]);axis off;         
            drawnow;
        end
    end
    time = toc;
end

function H=Heaviside(z)
    Epsilon=10^(-5);
    H=zeros(size(z,1),size(z,2));
    idx1=find(z>=Epsilon);
    idx2=find(z<Epsilon & z>-Epsilon);
    H(idx1)=1;
    for i=1:length(idx2)
        H(idx2(i))=1/2*(1+z(idx2(i))/Epsilon+1/pi*sin(pi*z(idx2(i))/Epsilon));
    end;
end

function KG = kappa(I)  
    I = double(I);
    [m,n] = size(I);
    P = padarray(I,[1,1],1,'pre');
    P = padarray(P,[1,1],1,'post');

    % central difference
    fy = P(3:end,2:n+1)-P(1:m,2:n+1);
    fx = P(2:m+1,3:end)-P(2:m+1,1:n);
    fyy = P(3:end,2:n+1)+P(1:m,2:n+1)-2*I;
    fxx = P(2:m+1,3:end)+P(2:m+1,1:n)-2*I;
    fxy = 0.25.*(P(3:end,3:end)-P(1:m,3:end)+P(3:end,1:n)-P(1:m,1:n));
    G = (fx.^2+fy.^2).^(0.5);
    K = (fxx.*fy.^2-2*fxy.*fx.*fy+fyy.*fx.^2)./((fx.^2+fy.^2+eps).^(1.5));
    KG = K.*G;
    KG(1,:) = eps;
    KG(end,:) = eps;
    KG(:,1) = eps;
    KG(:,end) = eps;
    KG = KG./max(max(abs(KG)));
end