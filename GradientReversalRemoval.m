function corrDetailImg = GradientReversalRemoval( inputImg, detailImg)
    % GradientReversalRemoval( inputImg, detailImg)
    
    % Gradient reversal removal in de RGB color space door middel van voor
    % elke kleurenband de GradientReversalRemovalMonoColor aan te roepen

    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
    
    disp(sprintf('Gradient Reversal Removal (RGB color space) in progress...')); tic;

    corrDetailImgR = GradientReversalRemovalMonoColor(inputImg(:,:,1), detailImg(:,:,1));
    corrDetailImgG = GradientReversalRemovalMonoColor(inputImg(:,:,2), detailImg(:,:,2));
    corrDetailImgB = GradientReversalRemovalMonoColor(inputImg(:,:,3), detailImg(:,:,3));

    % Samenvoegen van de verschillende kleurenbanden
    corrDetailImg = cat(3, corrDetailImgR, corrDetailImgG, corrDetailImgB);
    
    time_used = toc;  disp(sprintf('Time for Gradient Reversal Removal (RGB color space) = %f secs',time_used)); 
    disp(sprintf('Gradient Reversal Removal (RGB color space) done.'));