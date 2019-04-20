function output = TexturenessTransferMonoColor(TinputImg, TmodelImg, TdetailImg, ThmBaseImg, hmBaseImg, detailImg)
    % TexturenessTransferMonoColor(TinputImg, TmodelImg, TdetailImg,
    % ThmBaseImg, hmBaseImg, detailImg)
    
    % De waardens die uit de gewone textureness komen moeten nog bijgewerkt
    % worden zodat de kleuren terug binnen het normale bereik liggen

    % Auteurs:  Nick Michiels   0623764
    %           Jan Oris        0623977
    
    % In opdracht van   Universiteit Hasselt
    %                   3e bachelor ICT
    %                   Beeldverwerking
    %
    %**********************************************************************
    
    
    [inputHeight,inputWidth] = size(TinputImg);
    [modelHeight,modelWidth] = size(TmodelImg);
    
    % STAP 1: Histogram Matching van input met het model
    %----------------------------------------------------------------
    T = HistogramMatchingMonoColor(TinputImg, TmodelImg);
    
    % STAP 2: Detaillayer aanpassen om halos te verwijderen
    %----------------------------------------------------------------
    for i=1:inputHeight
        for j=1:inputWidth
                P(i,j) = max(0, (T(i,j) - ThmBaseImg(i,j))/TdetailImg(i,j));
        end
    end
    
    output = hmBaseImg + P.*detailImg;
