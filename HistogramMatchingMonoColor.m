function hmBaseImg = HistogramMatchingMonoColor(baseImg, modelBaseImg)
    % HistogramMatchingMonoTone(baseImg, modelBaseImg)
    
    % Deze functie zorgt voor gegeven een baseImg, dat dit histogram
    % gematched wordt met het histogram van de modelBaseImg. Beide zijn
    % gray scale afbeeldingen
    
    % Opmerkingen hierbij zijn dat eerst de baseImg wordt ge-equaliseerd
    % alvorens deze wordt gespecifieerd met de modelBaseImg.
    % Ook kan het kleurbereik L worden ingesteld, deze is standaard 255.

    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
    
    disp(sprintf('Histogram Matching Mono Color in progress...')); tic;
    
    % De afbeeldingen terug in het bereik 0 tot 256 brengen
    L = 256;
    baseImg = round(baseImg*(L-1));
    modelBaseImg = round(modelBaseImg*(L-1));
    [height,width] = size(baseImg);
    [heightModel,widthModel] = size(modelBaseImg);
    % Matlab begint de indices vanaf 1
    baseImg = baseImg + 1;
    modelBaseImg = modelBaseImg + 1;

    % Histogram opstellen van base en model
    histogramBase = zeros(1,L);
    histogramModel = zeros(1,L);
    for i=1:height
        for j=1:width
            if (baseImg(i,j) < 1 || isnan(baseImg(i,j)))
                baseImg(i,j) = 1;
            elseif ( baseImg(i,j)>L)
                baseImg(i,j) = L;
            end
            histogramBase(baseImg(i,j)) = histogramBase(baseImg(i,j)) + 1;
        end
    end
    clear i j
    for i=1:heightModel
        for j=1:widthModel
            if (modelBaseImg(i,j) < 1 || isnan(modelBaseImg(i,j)))
                modelBaseImg(i,j) = 1;
            elseif ( modelBaseImg(i,j)>L)
                modelBaseImg(i,j) = L;
            end
            histogramModel(modelBaseImg(i,j)) = histogramModel(modelBaseImg(i,j)) + 1;
        end
    end
    clear i j

    % PDF-functie van histogram van base en model opstellen
    PhistogramBase = double(histogramBase) ./ (height*width);  % PDF van base
    PhistogramModel = double(histogramModel) ./ (heightModel*widthModel); % PDF van model

    % Cumulatieve functie van histogram van base en model opstellen
    cumBase(1) = (L-1) * PhistogramBase(1); % komt overeen met de s'en
    cumModel(1) = (L-1) * PhistogramModel(1); % komt overeen met de g'en
    for i=2:L
        cumBase(i) = cumBase(i-1) + (L-1)*PhistogramBase(i);
        cumModel(i) = cumModel(i-1) + (L-1)*PhistogramModel(i);
    end
    
    % Beveiliging omdat Matlab zijn indices beginnen bij 1
    cumBase = round(cumBase) + 1;
    cumModel = round(cumModel) + 1;

    % InputImg equaliseren.
    equalized = zeros(1,L);
    for i=1:L
        equalized(cumBase(i)) = equalized(cumBase(i)) + histogramBase((i));
    end

    % PDF van de ge-equaliseerde histogram
    Pequalized = equalized ./ (height*width);

    % Cumulatieve functie van het ge-equaliseerde histogram
    cumEqualized(1) = (L-1) * Pequalized(1); % komt overeen met de g'en
    for i=2:L
        cumEqualized(i) = cumEqualized(i-1) + (L-1)*Pequalized(i);
    end

    % Mappings maken voor elke kleurwaarde van inputImg met welke deze overeen gaat
    % moeten komen met kleurwaarde van modelImg
    mapping = zeros(2,L);   % voor elke sk berekenen welke j nodig is om G(j) er het dichtste bij te laten liggen
    for i=1:L
        sk = cumBase(i);
        j = 1;
        while ( cumModel(j) < sk)
            j = j+1;
        end
        if (j == 1)
            mapping(1,i) = sk;
            mapping(2,i) = j;
        elseif ( (sk - cumModel(j-1)) <= (cumModel(j-1) - sk))
            mapping(1,i) = sk;
            mapping(2,i) = j-1;
        else
            mapping(1,i) = sk;
            mapping(2,i) = j;
        end
    end

    % Mappings toepassen op de ge-equaliseerde histogram om zo het
    % gespecifieerde diagram te bekomen
    % = overbodige stap maar kan aantonen dat specified diagram ongeveer
    % corret is.
    SpecifiedDiagram = zeros(1,L);
    for i=1:L
        SpecifiedDiagram(mapping(2,i)) = SpecifiedDiagram(mapping(2,i)) + (equalized(i));
    end
    SpecifiedDiagram = double(SpecifiedDiagram);

    mapping = round(mapping);

    % Mapping toepassen op de inputImg
    for i=1:height
        for j=1:width
            if (baseImg(i,j) < 1)
                baseImg(i,j) = 1;
            elseif ( baseImg(i,j)>L)
                baseImg(i,j) = L;
              end
            hmBaseImg(i,j) = mapping(2,baseImg(i,j));
        end
    end

    % De nieuwe afbeelding terug omzetten naar kleurwaardens binnen het
    % bereik [0,1]
    hmBaseImg = hmBaseImg - 1;
    hmBaseImg = double(hmBaseImg)/(L-1);
    
    time_used = toc;  disp(sprintf('Time for Histogram Matching Mono Color = %f secs',time_used)); 
    disp(sprintf('Histogram Matching Mono Color done.'));



