function [matchPoint] = matchFeature(mainMatrix, compareMatrix,Nbest)
    matchResult = 10000 * ones(Nbest,2);
    matchPoint_temp = zeros(Nbest,2);
    matchPoint_temp2 = zeros(Nbest,3);
    k = 1;
    m = 1;
    for i = 1:Nbest
        checkVec = mainMatrix(:,i);
        for j = 1:Nbest
            difference = checkVec - compareMatrix(:,j);
            variance = difference' * difference;
            if variance < matchResult(i,1)
                matchResult(i,2) = matchResult(i,1);
                matchResult(i,1) = variance;
                matchPoint_temp(i,1) = i;
                matchPoint_temp(i,2) = j;
            end
        end
    end
    for i = 1:Nbest
        if (matchResult(i,1)/matchResult(i,2) < 0.3)
            bad = 0;
            for j = 1: k-1
                if (matchPoint_temp2(j,1) == matchPoint_temp(i,1)) || (matchPoint_temp2(j,2) == matchPoint_temp(i,2))
                    matchPoint_temp2(j,3) = matchPoint_temp2(j,3) - 1;
                    bad = 1;
                    break;
                end
            end
            if (bad == 0)
                matchResult_temp2(k,1) = matchResult(i,1);
                matchPoint_temp2(k,1) = matchPoint_temp(i,1);
                matchPoint_temp2(k,2) = matchPoint_temp(i,2);
                k = k + 1;
            end
        end
    end
    threshord = 10;
    matchPoint= zeros(100,2);
%     [~,variance_index] = sort(matchResult_temp2(:,1));
    for i = 1:k - 1
        if (matchPoint_temp2(i,3)>= 0)
            matchPoint(m,:) = matchPoint_temp2(i,1:2);
            m = m + 1;
        end
    end
    if m == 1
        matchPoint = [-1,-1];
    end
    
end