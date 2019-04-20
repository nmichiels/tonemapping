function result = LAB(inputImg, modelImg, sigmaS, sigmaR)
    % luminance(inputImg, modelImg, sigmaS, sigmaR)
    %
    % Auteurs:  Nick Michiels   (0623764)
    %           Jan Oris        (0623977)
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    % Zorgt voor een additional effect van Color and Toning bescrhreven in
    % de Paper van http://people.csail.mit.edu/soonmin/photolook/
    % meer bepaald het werken in de CIE-LAB color space
    
    %**********************************************************************
    
    % omzetten van de rgb color space naar de CIE-LAB color space
    cform = makecform('srgb2lab');
    lab = applycform(inputImg,cform);
    model = applycform(modelImg,cform);
    lab = double(lab)/99;
    model = double(model)/99;

    % Tone Management toepassen op L
    test = ProjectMonoColor(lab(:,:,1), model(:,:,1));

    result = cat(3, test, lab(:,:,2), lab(:,:,3));
    result = round(result*100);
    
    % omzetten van CIE-LAB -> RGB
    cform2 = makecform('lab2srgb');
    result = applycform(result,cform2);
    
    
    
