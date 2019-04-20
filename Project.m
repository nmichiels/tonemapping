function Project
    % Uitvoerbaar bestand om Two-scale Tone Management for Photographic
    % Look uit te voeren in de RGB color space
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
   
    disp(sprintf('Two-scale Tone Management for Photographic Look (RGB color space) in progress...'));

    % optievariabelen die kunnen gedeclareerd worden
    inputImg = imread('input.png'); inputImg = double(inputImg) / 255 ; figure(1); imshow(inputImg);
    modelImg = imread('model.png'); modelImg = double(modelImg) / 255 ; figure(2); imshow(modelImg);
    
    [height, width] = size(inputImg);
    inputMin = min( inputImg( : ) );
    inputMax = max( inputImg( : ) );
    inputDelta = inputMax - inputMin;
    if ~exist('sigmaR', 'var') sigmaR = 0.1 * inputDelta; end
    if ~exist('sigmaS', 'var' ) sigmaS = min( width, height ) / 16; end
    
    % bilateral + gradient reversal removal van input
    
    disp(sprintf('\n\n-----------------------------------------------------------------------------\n Bilateral van input\n\n\n'));
    
    baseImg = BilateralFilter( inputImg, inputImg, sigmaS, sigmaR); figure(3); imshow(baseImg);
        %imwrite(baseImg, 'resultImages/01 baseB.png');
    detailImg = (inputImg - baseImg);
        imwrite(detailImg, 'resultImages/01 detailB.png');
    
    disp(sprintf('\n\n-----------------------------------------------------------------------------\n GradientReversalRemoval input\n\n\n'));
    
    detailImg = GradientReversalRemoval( inputImg, detailImg ); 
        imwrite(detailImg, 'resultImages/02 detail.png');
    baseImg = inputImg - detailImg;
        imwrite(baseImg, 'resultImages/03 base.png'); figure(4); imshow(baseImg);
    
    disp(sprintf('\n\n-----------------------------------------------------------------------------\n Bilateral van model\n\n\n'));
    
    % bilateral van model
    baseModelImg = BilateralFilter( modelImg, modelImg, sigmaS, sigmaR);
    detailModelImg = (modelImg - baseModelImg);
    
    disp(sprintf('\n\n-----------------------------------------------------------------------------\n GradientReversalRemoval model\n\n\n'));
    
    detailModelImg = GradientReversalRemoval( modelImg, detailModelImg );
    baseModelImg = modelImg - detailModelImg;
    
    disp(sprintf('\n\n-----------------------------------------------------------------------------\n Histogram matching\n\n\n'));
    
    % histogram matching
    hmBaseImg = HistogramMatching(baseImg,baseModelImg);
        imwrite(hmBaseImg, 'resultImages/04 histogramMatching.png'); figure(5); imshow(hmBaseImg);
    
    disp(sprintf('\n\n-----------------------------------------------------------------------------\n Textureness\n\n\n'));
    
    % textureness
    texturenessImg = Textureness(inputImg, modelImg, hmBaseImg, detailImg, sigmaS, sigmaR);
        imwrite(texturenessImg, 'resultImages/05 textureness.png'); figure(6); imshow(texturenessImg);
    
    disp(sprintf('\n\n-----------------------------------------------------------------------------\n Detail Preservation\n\n\n'));
    
    % detail preservation
    result = DetailPreservation(texturenessImg, inputImg, modelImg);
        imwrite(result, 'resultImages/06 result.png'); figure(7); imshow(result);
    
    
    disp(sprintf('Two-scale Tone Management for Photographic Look (RGB color space) done.'));
    
    
    
    
    