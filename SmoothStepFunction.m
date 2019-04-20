 function result = SmoothStepFunction(x, teta)
    % SmoothStepFunction(x, teta)
    
    % Hulpfunctie in berekening beta bij gradient reversal removal van
    % detail preservation

    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
        if (x < teta)
            result = 0;
        elseif (x > 2*teta)
            result = 1;
        else
            result = 1 - (1-(x-teta)^2/teta^2)^2; 
        end