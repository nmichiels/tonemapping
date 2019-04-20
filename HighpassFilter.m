function filteredImage = HighPassFilter(image, sigmaS)
    % filteredImage = HighPassFilter(image, sigmaS)
    
    % Een implementatie van een highpass filter
    % Eerst creëren we een gaussiaanse lowpass filter in spatiaal domein ter
    % grootte van de inputImg
    % Vervolgens zetten we de inputImg en de filter om naar het
    % frequentiedomein
    % Door 1 - lowpass filter uit te voeren krijgen we de highpass filter
    % Nu passen we hem toe door middel van vermenigvuldiging
    % De omgekeerde fouriertransformatie van het beeld geeft ons de
    % gefilterde afbeelding terug

    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
    
    [height,width] = size(image);
    
    % een gaussiaanse lowpass filter ter grote van het inputbeeld (in spatiaal
    % domein met sigmaS)
    gauss=zeros(height,width);
    for i=1:height; for j=1:width; x=i-height/2; y=j-width/2; gauss(i,j)=(x*x+y*y)/(sigmaS*sigmaS); end; end
    gauss=  exp(-0.5*gauss);
        
    % De gaussiaanse lowpass filter omzetten in frequentiedomein
    gaussF=fftshift(fft2(fftshift(gauss)));
    gaussF = gaussF ./ max(max(gaussF));   % normaliseren en de som van elk punt 1 te maken
    gaussF = 1.0 - gaussF;                 % higpass filter = 1.0 - lowpass filter

    % inputimage omzetten in frequentiedomein
    image=fft2(image);
    imageF=fftshift(image);
    
    % Filter toepassen (dit komt overeen met puntgewijs vermenigvuldigen)
    filteredImageF=imageF.*gaussF;

    % De afbeelding terug omzetten naar spatiaal domein
    filteredImageF=ifftshift(filteredImageF);  % plaats centrum weer in oorsprong
    filteredImage=real(ifft2(filteredImageF)); % resultaat van highpass filter


