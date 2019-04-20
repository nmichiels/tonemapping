function prct = percentile(image, value)
    % percentile(image, value)
    
    % Berekenen van het value'ste percentiel van een afbeelding

    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
    
    %image = [[3 4 6 3];[2 5 9 1]];
    %value = 25;
    [w,l] = size(image);
    array = zeros(1, (w*l));
    
    for i=1:w
        for j=1:l
            array(1, ((w*(i-1))+j) ) = image(i,j);
        end
    end
    array = sort(array, 'ascend');
    nr = size(array);
    
    perc = round((((w*l) / 100) * value)) + 1;
    prct = array(1,perc);
    


