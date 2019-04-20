function result = DetailPreservationMonoColor(texturenessedImg, inputImg, modelImg)
    % DetailPreservation(texturenessedImg, inputImg, modelImg)
    
    % De detail preservation stap. Hier komt contrast overeen met de sigma
    % uit de paper
    
    % Deze werkt voor een gray scale image

    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
    
    disp(sprintf('Detail Preservation Mono Color in progress...')); tic;
    
    % STAP 1: Histogram Matching van texturenessedImg met modelImg om
    % kleurmisvorimingen van texturenesss weg te krijgen
    %----------------------------------------------------------------------
    texturenessedImg = HistogramMatchingMonoColor(texturenessedImg,modelImg);

    % STAP 2: Berekeningen van alpha en contrast vermindering
    %----------------------------------------------------------------------
    contrast=((prctile(texturenessedImg,95)-prctile(texturenessedImg,5))/(prctile(inputImg,95)-prctile(inputImg,5)));
    alpha=contrast/4;
    
    % STAP 3: Gradient Reversal Removal met de zojuist berekende parameters
    %----------------------------------------------------------------------
    result = GradientReversalRemovalDetailPreservationMonoColor(inputImg, texturenessedImg, alpha);

    time_used = toc;  disp(sprintf('Time for Detail Preservation Mono Color = %f secs',time_used)); 
    disp(sprintf('Detail Preservation Mono Color done.'));
    