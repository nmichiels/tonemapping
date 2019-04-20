function texturenessedImg = TexturenessMonoColor(inputImg, modelImg, hmBaseImg, detailImg, sigmaS, sigmaR)
    % TexturenessMonoColor(inputImg, modelImg, hmBaseImg, detailImg,
    % sigmaS, sigmaR)
    
    % Eerst wordt er voor de input, model, histogramMatched, en detail er
    % een highpass filter van berekend. Vervolgens wordt er voor elk van
    % deze afbeeldingen een cross bilaterale filter berekend op basis van
    % die highpass filter

    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
    
    disp(sprintf('Textureness Mono Color in progress...')); tic;
    disp(sprintf('Textureness Mono Color: 0 procent'));
    
    [inputHeight,inputWidth] = size(inputImg);
    [modelHeight,modelWidth] = size(modelImg);

    
    if ~exist('sigmaS', 'var' ) sigmaS = min( inputWidth, inputHeight ) / 16; end

    
    % STAP 1: Highpass filters voor elke afbeelding
    %----------------------------------------------------------------
    inputImgFiltered = HighPassFilter(inputImg, sigmaS);
    inputImgFiltered = abs(inputImgFiltered);
    modelImgFiltered = HighPassFilter(modelImg, sigmaS);
    modelImgFiltered = abs(modelImgFiltered);
    detailImgFiltered = HighPassFilter(detailImg, sigmaS);
    detailImgFiltered = abs(detailImgFiltered);
    hmBaseImgFiltered = HighPassFilter(hmBaseImg, sigmaS);
    hmBaseImgFiltered = abs(hmBaseImgFiltered);
    disp(sprintf('Textureness Mono Color: 10 procent'));

    % STAP 2: Cross Bilateral Filter voor elke afbeelding met als edge de
    % respectievelijke highpassfilter
    % het volstaat de sigmaS te vermenigvuldigen met 8 en de sigmaR
    % hetzelfde te houden
    %----------------------------------------------------------------
    
    TinputImg = BilateralFilterGrey(inputImgFiltered, inputImg, sigmaS*8, sigmaR); disp(sprintf('Textureness Mono Color: 30 procent'));
    TmodelImg = BilateralFilterGrey(modelImgFiltered, modelImg, sigmaS*8, sigmaR); disp(sprintf('Textureness Mono Color: 50 procent'));
    TdetailImg = BilateralFilterGrey(detailImgFiltered, detailImg, sigmaS*8, sigmaR); disp(sprintf('Textureness Mono Color: 70 procent'));
    ThmBaseImg = BilateralFilterGrey(hmBaseImgFiltered, hmBaseImg, sigmaS*8, sigmaR); disp(sprintf('Textureness Mono Color: 90 procent'));
    
    % STAP 3: De Textureness Transfer stap om de kleurwaarden terug binnen
    % het correcte bereik te brengen
    %----------------------------------------------------------------
    texturenessedImg = TexturenessTransferMonoColor(TinputImg, TmodelImg, TdetailImg, ThmBaseImg, hmBaseImg, detailImg);
    disp(sprintf('Textureness Mono Color: 100 procent'));
    
    time_used = toc;  disp(sprintf('Time for Textureness Mono Color = %f secs',time_used)); 
    disp(sprintf('Textureness Mono Color done.'));
    
    
    
    
    
        
    
    
    
    
    