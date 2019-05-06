function IsegmentedLarge=ASM_ApplyModel2D(ItestOrg,Itest,tform,ShapeData,AppearanceData,options,TrainingDataLines,compartments)
% Optimalization 

% Show the test image
if options.testverbose==true;
figure, imshow(Itest,[]); hold on;
end

% The initial contour is the Mean trainingdata set contour
nl=length(ShapeData.x_mean)/2;
pos(:,1)=ShapeData.x_mean(1:nl)';
pos(:,2)=ShapeData.x_mean(nl+1:end)';

% Position the initial contour at a location close to the correct location
pos=ASM_align_data_inverse2D(pos,tform);
 
% Handle later used to delete the plotted contour
h=[]; h2=[];

% We optimize starting from a rough to a fine image scale
for itt_res=options.nscales:-1:1
    % Scaling of the image
    scale=1 / (2^(itt_res-1));

    PCAData=AppearanceData(itt_res).PCAData;
     
    % Do 50 ASM itterations
    for itt=1:options.nsearch
        % Plot the contour
        if(ishandle(h)), delete(h); end
        if options.testverbose==true;
        h=plot(pos(:,2),pos(:,1),'b.'); drawnow('expose'); 
        end
        
        % Calculate the normals of the contour points.
        N=ASM_GetContourNormals2D(pos,ShapeData.Lines);

        % Create long intensity profiles on the contour normals, for search
        % of best point fit, using the correlation matrices made in the
        % appearance model
        
        % Total Intensity line-profile needed, is the traininglength + the
        % search length in both normal directions
        n = options.k + options.ns;

        % Get the intensity profiles of all landmarks and there first order
        % derivatives
        [gt,dgt]=ASM_getProfileAndDerivatives2D(imresize(Itest,scale),pos*scale,N,n);
        % Loop through all contour points
        f=zeros(options.ns*2+1,nl);
        for j=1:nl
            % Search through the large sampeled profile, for the optimal
            % position
            for i=1:(options.ns*2+1)
                % A profile from the large profile, with the length
                % of the trainingprofile (for rgb image 3x as long) 
                gi=zeros((2*options.k+1)*size(Itest,3),1);
                if(options.originalsearch)
                    for k=1:size(Itest,3), 
                        coffset=(k-1)*(2*options.k+1);
                        coffset2=(k-1)*(options.ns*2+1);
                        gi(1+coffset:2*options.k+1+coffset)=dgt(i+coffset2:2*options.k+i+coffset2,j);
                    end
                    % Calculate the Mahalanobis distance from the current
                    % profile, to the training data sets profiles through
                    % an inverse correlation matrix.
                    v=(gi- AppearanceData(itt_res).Landmarks(j).dg_mean);
                    f(i,j)=v'*AppearanceData(itt_res).Landmarks(j).Sinv*v;
                else
                    for k=1:size(Itest,3), 
                        coffset=(k-1)*(2*options.k+1);
                        coffset2=(k-1)*(options.ns*2+1);
                        gi(1+coffset:2*options.k+1+coffset)=gt(i+coffset2:2*options.k+i+coffset2,j);
                    end
                    % Calculate the PCA parameters, and normalize them
                    % with the variances.
                    % (Seems to work better with color images than
                    % the original method)
                    bc = PCAData(j).Evectors'*(gi-PCAData(j).Emean);
                    bc = bc./(sqrt(PCAData(j).Evalues));
                    f(i,j)=sum(bc.^2);
                end
                
            end
            % Find the lowest Mahalanobis distance, and store it 
            % as movement step
        end
        [temp,i]=min(f);
        movement=((i-1)-options.ns)';

        % Move the points to there new optimal positions
        pos(:,1)=pos(:,1)+(1/scale)*movement.*N(:,1);
        pos(:,2)=pos(:,2)+(1/scale)*movement.*N(:,2);
        
        % Show the new positions
        if(ishandle(h2)), delete(h2); end
        if options.testverbose==true;
        h2=plot(pos(:,2),pos(:,1),'r.'); drawnow('expose'); 
        end
        
        % Remove translation and rotation, as done when training the
        % model.
        [pos,tform]=ASM_align_data2D(pos);
        
        % Describe the model by a vector b with model parameters
        x_search=[pos(:,1);pos(:,2)];
        b = ShapeData.Evectors'*(x_search-ShapeData.x_mean);

        % Limit the model parameters based on what is considered a nomal
        % contour, using the eigenvalues of the PCA-model
        maxb=options.m*sqrt(ShapeData.Evalues);
        b=max(min(b,maxb),-maxb);

        % Transform the model parameter vector b, back to contour positions
        x_search = ShapeData.x_mean + ShapeData.Evectors*b;
        pos(:,1)=x_search(1:nl)'; pos(:,2)=x_search(nl+1:end)';

        % Now add the previously removed translation and rotation
        pos=ASM_align_data_inverse2D(pos,tform);
    end
end

LineLengths = [];
for k=1:compartments
LineLengths = [LineLengths size(TrainingDataLines(k).c,1)];  %size(TrainingDataLines(1).c,1) size(TrainingDataLines(2).c,1) size(TrainingDataLines(3).c,1) size(TrainingDataLines(4).c,1) size(TrainingDataLines(5).c,1)];
end

count = LineLengths(1,1);
lowCount = 0;
for k=1:compartments
base_points=[pos(1+lowCount:count,1) pos(1+lowCount:count,2)];
IsegmentedLarge(k).Seg = drawObject(base_points,[size(Itest,1) size(Itest,2)],TrainingDataLines(k).c);

if k < compartments
lowCount = count;
count = count + LineLengths(1,k+1);
end
end






