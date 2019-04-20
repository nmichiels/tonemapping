function filteredImage = BilateralFilterGrey(inputImg, edgeImg, sigmaS, sigmaR, samplingR, samplingS)
    % BilateralFilterGrey(inputImg, edgeImg, sigmaS, sigmaR, samplingR,
    % samplingS)
    
    % Een implementatie van een Fast Bilaterale filter. Gebaseerd op de
    % paper
    % http://people.csail.mit.edu/sparis/publi/2006/tr/Paris_06_Fast_Bilateral_Filter_MIT_TR_low-res.pdf
    
    % De stappen die we gebruiken komen overeen met de formules op pagina
    % 11
    %
    % Voor het gebruik van default parameters hebben we ons gebaseerd op:
    % referentie: http://people.csail.mit.edu/sparis/bf/
    
    % Deze implementatie is specifiek bedoeld voor gray scale images

    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
    
    disp(sprintf('Bilateral Filter Mono Color in progress...')); tic;

    [height,width] = size(inputImg);

    % Enkele tests op parameterinput
    % Enkel het gebruik van default parameters is afgeleid uit
    % http://people.csail.mit.edu/sparis/bf/
    
    if ~exist('edgeImg', 'var') edgeImg = inputImg; end
    edgeMin = min( edgeImg( : ) );
    edgeMax = max( edgeImg( : ) );
    edgeDelta = edgeMax - edgeMin;
    if ~exist('sigmaR', 'var') sigmaR = 0.1 * edgeDelta; end
    if ~exist('sigmaS', 'var' ) sigmaS = min( width, height ) / 16; end
    if ~exist( 'samplingR', 'var' )  samplingR = sigmaR; end
    if ~exist( 'samplingS', 'var' )  samplingS = sigmaS; end

    if ((height ~= size(edgeImg,1)) || (width ~= size(edgeImg,2)))
        error('inputImg and edgeImg must be the same size!');
    end

    % STAP 1: DOWNSAMPLEN
    %------------------------------------------------------------
    
    % omgezette parameters omzetten naar gedownsampelde parameters
    dSigmaSpatial = sigmaS / samplingS;
    dSigmaRange = sigmaR / samplingR;
    dsHeight = floor( ( height - 1 ) / samplingS ) + 2;
    dsWidth =  floor( ( width - 1 ) / samplingS ) + 2;
    dsDepth = floor( edgeDelta / samplingR ) + 2;

    % initialiseren van de downsampled space, deze is in 2 verdeeld omdat
    % de downsampled space  bestaat uit vectoren (wi, w) die hier voor de
    % gemakkelijkheid worden opgedeeld
    ds1 =  double(zeros(dsHeight, dsWidth, dsDepth));
    ds2 = double(zeros(dsHeight, dsWidth, dsDepth));

    iMin = min(inputImg(:));

    for i=1:height
        for j=1:width
            % a) compute the homogeneous vector (wi,w)<-(InputImg(i,j),1)
            wi = inputImg(i,j);
            w = 1;
            % b) compute the downsampled coordinates
            x = round(i / samplingS) + 1;
            y = round(j / samplingS) + 1;
            c = round((edgeImg(i,j) - edgeMin) / samplingR) + 1;
            % c) update the downsampled space
            ds1(x,y,c) = ds1(x,y,c) + wi;
            ds2(x,y,c) = ds2(x,y,c) + w;
        end
    end
    clear i j

    
    % STAP 2: CONVOLUTIE MET EEN GAUSSIAANSE FILTER
    %------------------------------------------------------------

    filterWidth = 2 * dSigmaSpatial + 1;
    filterWidth = filterWidth;
    filterDepth = 2 * dSigmaRange + 1;
    % een gaussiaanse filter aanmaken
   gauss=zeros(filterWidth,filterWidth,filterDepth);
   for i=1:filterWidth; for j=1:filterWidth; for k=1:filterDepth; x=i-filterWidth/2; y=j-filterWidth/2; z=k-filterDepth/2; gauss(i,j,k)=(x*x+y*y)/(dSigmaSpatial*dSigmaSpatial) + (z*z)/(dSigmaRange*dSigmaRange); end; end; end
   gauss=  exp(-0.5*gauss);
   filter = gauss;

    % convolve
    filtered_dx1 = convn( ds1, filter, 'same');
    filtered_dx2 = convn( ds2, filter, 'same' );
    
    
    % STAP 3: UPSAMPLING
    %------------------------------------------------------------

    % divide (http://people.csail.mit.edu/sparis/bf/)
    filtered_dx2( filtered_dx2 == 0 ) = -2; % avoid divide by 0, won't read there anyway
    filtered_dx2( filtered_dx2 < -1 ) = 0; % put zeros back


    % Initialiseren van de coordinaten die later geïnterpoleerd moeten
    % worden
    filteredImagedx1 = double(zeros(height, width)); % = WbIb
    filteredImagedx2 = double(zeros(height, width)); % = Wb
    for i=1:height
        for j=1:width
            filteredImagedx1i(i,j) =  (i/samplingS)+1;
            filteredImagedx1j(i,j) = (j/samplingS)+1;
            filteredImagedx1c(i,j) = ((edgeImg(i,j) - edgeMin)/samplingR)+1;
        end
    end

    % interpoleren van de coordinaten
    filteredImagedx1 = interpn( filtered_dx1, filteredImagedx1i, filteredImagedx1j, filteredImagedx1c );
    filteredImagedx2 = interpn( filtered_dx2, filteredImagedx1i, filteredImagedx1j, filteredImagedx1c );
    % normaliseren van de coordinaten door (WbIb / Wb)
    filteredImage = filteredImagedx1 ./ filteredImagedx2;
    clear filteredImagedx1 filteredImagedx2 filtered_dx1 filtered_dx2 filteredImagedx1i filteredImagedx1j filteredImagedx1c
    
    time_used = toc;  disp(sprintf('Time for Bilateral Filter Mono Color = %f secs',time_used)); 
    disp(sprintf('Bilateral Filter Mono Color done.'));

