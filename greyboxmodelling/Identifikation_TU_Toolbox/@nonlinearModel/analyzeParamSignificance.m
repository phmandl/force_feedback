function [orderedAbsParamIdx] = analyzeParamSignificance(obj,FIM)
[V,D] = eig(FIM);
orderedRelParamIdx = zeros(length(D),1);
for n_theta = 1:length(D) 
    [~,SignIdx] = max(abs(V(:,n_theta)));    
    orderedRelParamIdx(n_theta) = SignIdx;
end
orderedAbsParamIdx = obj.freeParamsForOptIdx(orderedRelParamIdx);

figure;
semilogy(diag(D));
grid on;
xticks(1:length(obj.freeParamsForOptIdx));

if isempty(obj.theta_labels)
    set(gca,'xticklabel',orderedAbsParamIdx);
else
    set(gca,'xticklabel',obj.theta_labels(orderedAbsParamIdx));
end
set(gca,'TickLabelInterpreter','none');
xtickangle(45);
title('Parameter Significance');



end

