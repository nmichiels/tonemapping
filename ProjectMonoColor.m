function result = ProjectMonoColor(inputImg, modelImg, sigmaS, sigmaR)
    
    % Functie om Two-scale Tone Management for Photographic
    % Look uit te voeren in gray scale
    % gebaseerd op de paper van:
    % http://people.csail.mit.edu/soonmin/photolook/
    
    % Zorgt voor een additional effect van Color and Toning bescrhreven in
    % de Paper van http://people.csail.mit.edu/soonmin/photolook/
    
    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
    
    disp(sprintf('Two-scale Tone Management for Photographic Look in progress...'));
    
    [height, width] = size(inputImg);
    
    if ~exist('sigmaR', 'var')
        inputMin = min( inputImg(:) );
        inputMax = max( inputImg(:) );
        inputDelta = inputMax - inputMin;
        sigmaR = 0.1 * inputDelta;
    end

    if ~exist('sigmaS', 'var' )
        sigmaS = min( width, height ) / 16;
    end
    
    % bilateral + gradient reversal removal van input
    
    disp(sprintf('\n\n-----------------------------------------------------------------------------\n Bilateral van input\n\n\n'));
    
    baseImg = BilateralFilterGrey( inputImg, inputImg, sigmaS, sigmaR);
    detailImg = (inputImg - baseImg);
    
    disp(sprintf('\n\n-----------------------------------------------------------------------------\n GradientReversalRemoval input\n\n\n'));
    
    detailImg = GradientReversalRemovalMonoColor( inputImg, detailImg );
        imwrite(detailImg, 'resultImages/02M detail.png');
    baseImg = inputImg - detailImg;
        imwrite(baseImg, 'resultImages/03M base.png');
    
    disp(sprintf('\n\n-----------------------------------------------------------------------------\n Bilateral van model\n\n\n'));
    
    % bilateral van model
    baseModelImg = BilateralFilterGrey( modelImg, modelImg, sigmaS, sigmaR);
    detailModelImg = (modelImg - baseModelImg);
    
    disp(sprintf('\n\n-----------------------------------------------------------------------------\n GradientReversalRemoval model\n\n\n'));
    
    detailModelImg = GradientReversalRemovalMonoColor( modelImg, detailModelImg );
    baseModelImg = modelImg - detailModelImg;
    
    disp(sprintf('\n\n-----------------------------------------------------------------------------\n Histogram matching\n\n\n'));
    
    % histogram matching
    hmBaseImg = HistogramMatchingMonoColor(baseImg,baseModelImg);
        imwrite(hmBaseImg, 'resultImages/04M histogramMatching.png');
    
    disp(sprintf('\n\n-----------------------------------------------------------------------------\n Textureness\n\n\n'));
    
    % textureness
    texturenessImg = TexturenessMonoColor(inputImg, modelImg, hmBaseImg, detailImg, sigmaS, sigmaR);
        imwrite(texturenessImg, 'resultImages/05M textureness.png');
    
    disp(sprintf('\n\n-----------------------------------------------------------------------------\n Detail Preservation\n\n\n'));
    
    % detail preservation
    result = DetailPreservationMonoColor(texturenessImg, inputImg, modelImg);
        imwrite(result, 'resultImages/06M result.png');
    
    
    disp(sprintf('Two-scale Tone Management for Photographic Look done.'));
    
    
    
    
    