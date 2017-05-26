function [H,Inlier] = RANSAC_newnew(numFeature1n2,Dest,Source)    
    IterationMax = 500;
    condition_out = 0;
    Percentage = numFeature1n2 * 0.9; 
    testTime = 0;
    thre = 100;
    while(~condition_out)
        b = 1;
        testTime = testTime + 1;
        if (testTime > 500) && (thre < 1500)
            thre = thre + 100;
            testTime = 0;
            Percentage = Percentage - numFeature1n2 * 0.03; 
        elseif (thre == 1500)
            error('No Match!');
        end
        condition_in = 0;
        randIndex = unidrnd(numFeature1n2,4,1);
        Inlier = zeros(100,1);
        SSD = zeros(IterationMax,1);
        
        X = Dest(randIndex,1);
        Y = Dest(randIndex,2);
        x = Source(randIndex,1);
        y = Source(randIndex,2);
        H = est_homography(X,Y,x,y);
        while(~condition_in)
            randIndex = unidrnd(numFeature1n2,4,1);
            X = Dest(randIndex,1);
            Y = Dest(randIndex,2);
            x = Source(randIndex,1);
            y = Source(randIndex,2);
            [X_modified,Y_modified] = apply_homography(H,x,y);
            SSD(b) = (X - X_modified)' * (X - X_modified) + (Y - Y_modified)' * (Y - Y_modified);
            if SSD(b) < thre
                Inlier(randIndex) = 1;
            end
            b = b + 1;
            numInlier = length(find(Inlier > 0));
            condition_in = (numInlier > Percentage) || (b > IterationMax);
            condition_out = (numInlier > Percentage);
        end
    end
end