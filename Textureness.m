function texturenessedImg = Textureness(inputImg, modelImg, hmBaseImg, detailImg, sigmaS, sigmaR)
    % Textureness(inputImg, modelImg, hmBaseImg, detailImg, sigmaS, sigmaR)
    
    % Textureness in de RGB color space door middel van voor
    % elke kleurenband de GradientReversalRemovalMonoColor aan te roepen

    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
    
    disp(sprintf('Textureness in progress...')); tic;

    disp(sprintf('\nTextureness: 0 procent'));
    texturenessedImgR = TexturenessMonoColor(inputImg(:,:,1), modelImg(:,:,1), hmBaseImg(:,:,1), detailImg(:,:,1), sigmaS, sigmaR);
    disp(sprintf('\nTextureness: 33 procent'));
    texturenessedImgG = TexturenessMonoColor(inputImg(:,:,2), modelImg(:,:,2), hmBaseImg(:,:,2), detailImg(:,:,2), sigmaS, sigmaR);
    disp(sprintf('\nTextureness: 66 procent'));
    texturenessedImgB = TexturenessMonoColor(inputImg(:,:,3), modelImg(:,:,3), hmBaseImg(:,:,3), detailImg(:,:,3), sigmaS, sigmaR);
    disp(sprintf('\nTextureness: 100 procent'));
    
    % Samenvoegen van de verschillende kleurenbanden
    texturenessedImg = cat(3, texturenessedImgR, texturenessedImgG, texturenessedImgB);
    
    time_used = toc;  disp(sprintf('Time for Textureness = %f secs',time_used)); 
    disp(sprintf('Textureness done.'));
