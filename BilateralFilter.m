function filteredImage = BilateralFilter(inputImg, edgeImg, sigmaS, sigmaR, samplingR, samplingS)
    % BilateralFilter(inputImg, edgeImg, sigmaS, sigmaR, samplingR,
    % samplingS)
    
    % Een implementatie van een Fast Bilaterale filter. Gebaseerd op de
    % paper (voornamelijk op de formules pagina 11):
    % http://people.csail.mit.edu/sparis/publi/2006/tr/Paris_06_Fast_Bilateral_Filter_MIT_TR_low-res.pdf
    %
    % Ook de voorbeeldcode heeft als hulpmiddel gediend om het te snappen:
    % referentie: http://people.csail.mit.edu/sparis/bf/
    
    % Opgelet deze is er een voor de RGB color space, hij roept voor elke
    % kleurenband de grijswaarde implementatie aan van de bilaterale filter

    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
    
    disp(sprintf('Bilateral Filter (RGB color space) in progress...'));tic;

    height = size(inputImg,1);
    width = size(inputImg, 2);

    if ~exist('edgeImg', 'var')
        disp(sprintf('No cross bilateral filter... inputImg = edgeImg'));
        edgeImg = inputImg;
    end

    edgeMin = min( edgeImg(:) );
    edgeMax = max( edgeImg(:) );
    edgeDelta = edgeMax - edgeMin;

    if ~exist('sigmaR', 'var')
        sigmaR = 0.1 * edgeDelta;
    end

    if ~exist('sigmaS', 'var' ),
        sigmaS = min( width, height ) / 16;
    end

    if ~exist( 'samplingR', 'var' ),
        samplingR = sigmaR;
    end

    if ~exist( 'samplingS', 'var' ),
        samplingS = sigmaS;
    end
    

    
    filteredImageR = BilateralFilterGrey(inputImg(:,:,1), edgeImg(:,:,1), sigmaS, sigmaR, samplingR, samplingS);
    filteredImageG = BilateralFilterGrey(inputImg(:,:,2), edgeImg(:,:,2), sigmaS, sigmaR, samplingR, samplingS);
    filteredImageB = BilateralFilterGrey(inputImg(:,:,3), edgeImg(:,:,3), sigmaS, sigmaR, samplingR, samplingS);
    clear time_used_R time_used_G time_used_B
    
    % Samenvoegen van de verschillende kleurenbanden
    filteredImage = cat(3, filteredImageR, filteredImageG, filteredImageB);
    clear filteredImageR filteredImageG filteredImageB


    time_used = toc;  disp(sprintf('Time for Bilateral Filter (RGB color space) = %f secs',time_used)); 
    disp(sprintf('Bilateral Filter (RGB color space) done.'));
    
    
    
    
