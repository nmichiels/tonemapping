function corrDetailImg = GradientReversalRemovalMonoColor( inputImg, detailImg)
    % GradientReversalRemovalMonoColor( inputImg, detailImg)
    
    % Deze functie zorgt voor gradient reversal removal op een gray scale
    % afbeelding
    
    % Deze gaat eerst de gradienten berekenen, vervolgens aanpassingen doen
    % hierop alvorens deze door te geven aan de poisson reconstruction
    
    % De boolean 'gradient' is een speciaal geval. 
    % Indien deze true is gebruiken we de ingebouwde matlabfunctie om
    % gradienten te berekenen die we gekregen hebben van Robin.
    % Indien false gebruiken we onze eigen geimplementeerde
    % gradientberekeningen.

    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
    
    disp(sprintf('Gradient Reversal Removal Mono Color in progress...')); tic;
    
    [height,width] = size(detailImg);
    if ((height ~= size(inputImg,1)) || (width ~= size(inputImg,2)))
        error('inputImg and detailImg must be the same size!');
    end
    
    gradient = false;
    
    if( gradient == true )                   % met gradient functie (gekregen van Robin)
        gxI = zeros(height,width);
        gyI = zeros(height,width);
        
        gxD = zeros(height,width);
        gyD = zeros(height,width);
        
        [gxI gyI] = gradient(inputImg);
        [gxD gyD] = gradient(detailImg);
        clear inputImg
    else                                % eigen implementatie van gradientberekeningen
        % Find gradients INPUT image
        gxI = zeros(height,width);
        gyI = zeros(height,width);
        j = 1:height-1; 
        k = 1:width-1;
        gxI(j,k) = (inputImg(j,k+1) - inputImg(j,k)); 
        gyI(j,k) = (inputImg(j+1,k) - inputImg(j,k));
        clear j k

        % Find gradients DETAIL image
        gxD = zeros(height,width); 
        gyD = zeros(height,width);
        j = 1:height-1; 
        k = 1:width-1;
        gxD(j,k) = (detailImg(j,k+1) - detailImg(j,k)); 
        gyD(j,k) = (detailImg(j+1,k) - detailImg(j,k));
        clear j k inputImg
    end
    
    % Aanpassingen van de gradientwaarden
    gx = zeros(height,width);
    gy = zeros(height,width);
    for m=1:height
        for n=1:width
            if( (gxD(m,n) > 0 && gxI(m,n) < 0) || ( gxD(m,n) < 0 && gxI(m,n) > 0 ) )
                gx(m,n) = 0;
            elseif( abs(gxD(m,n)) > abs(gxI(m,n)) )
                gx(m,n) = gxI(m,n);
            else
                gx(m,n) = gxD(m,n);
            end

            if( (gyD(m,n) > 0 && gyI(m,n) < 0) || ( gyD(m,n) < 0 && gyI(m,n) > 0 ) )
                gy(m,n) = 0;
            elseif( abs(gyD(m,n)) > abs(gyI(m,n)) )
                 gy(m,n) = gyI(m,n);
            else
                 gy(m,n) = gyD(m,n);
            end
        end
    end
    clear gxI gyI gxD gyD
    
    % aangepaste gradienten doorgeven aan de poisson reconstructie
    corrDetailImg = poisson_reconstruction(detailImg, gx, gy);
    
    time_used = toc;  disp(sprintf('Time for Gradient Reversal Removal Mono Color = %f secs',time_used)); 
    disp(sprintf('Gradient Reversal Removal Mono Color done...'));

    
    