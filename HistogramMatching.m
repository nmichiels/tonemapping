function hmBaseImg = HistogramMatching(baseImg, modelBaseImg)
    % HistogramMatching(baseImg, modelBaseImg)
    
    % Deze functie zorgt voor gegeven een baseImg, dat dit histogram
    % gematched wordt met het histogram van de modelBaseImg
    
    % Histogram matching gebeurt hier in de RGB color space, dus wordt voor
    % elke kleurenband afzonderlijk een monotone versie van histogram
    % matching aangeroepen/

    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
    
    disp(sprintf('Histogram Matching (RGB Color Space) in progress...')); tic;
    
    hmBaseImgR = HistogramMatchingMonoColor(baseImg(:,:,1), modelBaseImg(:,:,1));
    hmBaseImgG = HistogramMatchingMonoColor(baseImg(:,:,2), modelBaseImg(:,:,2));
    hmBaseImgB = HistogramMatchingMonoColor(baseImg(:,:,3), modelBaseImg(:,:,3));
    
    % Samenvoegen van de verschillende kleurenbanden
    hmBaseImg = cat(3,hmBaseImgR,hmBaseImgG,hmBaseImgB);
    
    time_used = toc;  disp(sprintf('Time for Histogram Matching (RGB Color Space) = %f secs',time_used)); 
    disp(sprintf('Histogram Matching (RGB Color Space) done.'));


