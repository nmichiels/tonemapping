function corrDetailImg = GradientReversalRemovalDetailPreservationMonoColor( inputImg, detailImg, alpha)
    % GradientReversalRemovalDetailPreservationMonoColor( inputImg,
    % detailImg, alpha)
    
    % Deze functie zorgt voor gradient reversal removal op een gray scale
    % afbeelding voor het geval van detail preservation
    
    % Deze gaat eerst de gradienten berekenen, vervolgens aanpassingen doen
    % hierop alvorens deze door te geven aan de poisson reconstruction
    % Deze aanpassingen gebeuren met behulp van de alpha die doorgekregen
    % is van de detail preservation
    
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
    
    disp(sprintf('Gradient Reversal Removal (Detail Preservation) Mono Color in progress...')); tic;
    
    [height,width] = size(detailImg);
    if ((height ~= size(inputImg,1)) || (width ~= size(inputImg,2)))
        error('inputImg and detailImg must be the same size!');
    end
    
    gradient = false ; % bepalen of we eigen implementatie gebruiken of niet
    
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
    
    % Aanpassingen van de gradientwaarden met behulp van de alpha
    gx = zeros(height,width); 
    gy = zeros(height,width); 
    contrast = alpha*4;
    beta = 1 + 3*SmoothStepFunction(contrast, 0.1);      
    for m=1:height
        for n=1:width
            if( abs(gxD(m,n)) < (alpha * abs(gxI(m,n))) )
                gx(m,n) = alpha * gxI(m,n);
            elseif( abs(gxD(m,n)) > (beta * abs(gxI(m,n))) )
                gx(m,n) = beta * gxI(m,n);
            else
                gx(m,n) = gxD(m,n);
            end

            if( abs(gyD(m,n)) < (alpha * abs(gyI(m,n))) )
                gy(m,n) = alpha * gyI(m,n);
            elseif( abs(gyD(m,n)) > (beta * abs(gyI(m,n))) )
                gy(m,n) = beta * gyI(m,n);
            else
                gy(m,n) = gyD(m,n);
            end  
        end
    end
    clear gxI gyI gxD gyD
    
    % aangepaste gradienten doorgeven aan de poisson reconstructie
    corrDetailImg = poisson_reconstruction(detailImg, gx, gy);
    
    time_used = toc;  disp(sprintf('Time for Gradient Reversal Removal (Detail Preservation) Mono Color = %f secs',time_used)); 
    disp(sprintf('Gradient Reversal Removal (Detail Preservation) Mono Color done.'));
    