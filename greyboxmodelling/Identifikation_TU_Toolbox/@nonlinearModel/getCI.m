function CI = getCI(obj, theta_hat, FIM, n, gamma)

    %{
    creation date: 2020-04-23
    created by: Zhang Peng DU

    theta_hat   guess of parameter
    n           number of summed FIMs
    FIM         Fisher-Information-Matrix (FIM)
    gamma       confidence level
    %}
    
    % number of parameters
    n_theta = length(obj.freeParamsForOptIdx);
    
    % calculate diagonal elements of inverse FIM
    FIM_inv_diag = diag( inv( FIM ) );
    
    % calculate significance level
    alph = 1 - gamma;
    
    % calculate confidence intervals
    CI = zeros(n_theta, 2);
    CI(:, :) = norminv(alph/2) / sqrt(n);
    CI = CI * [1, 0; 0, -1];
    
    for k = 1 : n_theta
        
        CI(k, :) = CI(k, :) * sqrt( FIM_inv_diag(k) ) + theta_hat(k);
        
    end
    
end