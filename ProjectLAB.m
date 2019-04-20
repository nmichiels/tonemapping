function ProjectLAB
    % Uitvoerbaar bestand om Two-scale Tone Management for Photographic
    % Look uit te voeren in de CIE-LAB color space
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
    
    % inputvariabelen
    inputImg = imread('input.png'); inputImg = double(inputImg)/255;
    modelImg = imread('model.png'); modelImg = double(modelImg)/255;
    
    [height, width] = size(inputImg);
    inputMin = min( inputImg( : ) );
    inputMax = max( inputImg( : ) );
    inputDelta = inputMax - inputMin;
    if ~exist('sigmaR', 'var') sigmaR = 0.1 * inputDelta; end
    if ~exist('sigmaS', 'var' ) sigmaS = min( width, height ) / 16; end

    % Tone Management Functie aanroepen die werkt in CIE-LAB color space
    result = LAB(inputImg, modelImg, sigmaS, sigmaR);
        figure(1);imshow(result); imwrite(result, 'resultImages/result CIELAB.png');