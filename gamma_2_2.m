function y = gamma_2_2(x)
% y = gamma_2_2(x)
% Author: Jesse Chen

gamma_2_2_linear = @(x1)(x1*4.5);
gamma_2_2_exp = @(x2)((x2.^0.45)*1.099 - 0.099);

y = gamma_2_2_linear(x).*(x < 0.018) + gamma_2_2_exp(x).*(x >= 0.018);

y = y * 1.08676;

y = y/max(y);