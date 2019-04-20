function corrDetailImg = GradientReversalRemovalDetailPreservation( inputImg, detailImg, alpha)
    % GradientReversalRemovalDetailPreservation( inputImg, detailImg,
    % alpha)
    
    % Gradient reversal removal in de RGB color space door middel van voor
    % elke kleurenband de GradientReversalRemovalDetailPreservationMonoColor aan te roepen
    
    % Deze is een iets andere implementatie dan de gewone gradient reversal
    % removal wegens het gebruik van een alpha voor detail preservation

    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
    
    disp(sprintf('Gradient Reversal Removal Detail Preservation in progress...')); tic;

    corrDetailImgR = GradientReversalRemovalDetailPreservationMonoColor(inputImg(:,:,1), detailImg(:,:,1), alpha(1));
    corrDetailImgG = GradientReversalRemovalDetailPreservationMonoColor(inputImg(:,:,2), detailImg(:,:,2), alpha(2));
    corrDetailImgB = GradientReversalRemovalDetailPreservationMonoColor(inputImg(:,:,3), detailImg(:,:,3), alpha(3));

    % Samenvoegen van de verschillende kleurenbanden
    corrDetailImg = cat(3, corrDetailImgR, corrDetailImgG, corrDetailImgB);
    
    time_used = toc;  disp(sprintf('Time for Gradient Reversal Removal Detail Preservation = %f secs',time_used)); 
    disp(sprintf('Gradient Reversal Removal Detail Preservation done.'));