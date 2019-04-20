function result = DetailPreservation(texturenessedImg, inputImg, modelImg)
    % DetailPreservation(texturenessedImg, inputImg, modelImg)
    
    % De detail preservation stap. Hier komt contrast overeen met de sigma
    % uit de paper
    
    % Deze is een implementatie voor de RGB color space

    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
    
    disp(sprintf('Detail Preservation in progress...')); tic;
    
    % STAP 1: Histogram Matching van texturenessedImg met modelImg om
    % kleurmisvorimingen van texturenesss weg te krijgen
    %----------------------------------------------------------------------
    texturenessedImg = HistogramMatching(texturenessedImg,modelImg);

    % STAP 2: Berekeningen van alpha en contrast vermindering
    %----------------------------------------------------------------------
    contrast(1)=((prctile(texturenessedImg(:,:,1),95)-prctile(texturenessedImg(:,:,1),5))/(prctile(inputImg(:,:,1),95)-prctile(inputImg(:,:,1),5)));
    contrast(2)=((prctile(texturenessedImg(:,:,2),95)-prctile(texturenessedImg(:,:,2),5))/(prctile(inputImg(:,:,2),95)-prctile(inputImg(:,:,2),5)));
    contrast(3)=((prctile(texturenessedImg(:,:,3),95)-prctile(texturenessedImg(:,:,3),5))/(prctile(inputImg(:,:,3),95)-prctile(inputImg(:,:,3),5)));
    alpha=contrast./4;
    
    % STAP 3: Gradient Reversal Removal met de zojuist berekende parameters
    %----------------------------------------------------------------------
    result = GradientReversalRemovalDetailPreservation(inputImg, texturenessedImg, alpha);
    
    time_used = toc;  disp(sprintf('Time for Detail Preservation = %f secs',time_used)); 
    disp(sprintf('Detail Preservation done.'));
      
    