function sig_contour(sig, varargin)
% SIG_CONTOUR: Produce a contour plot of a 3D or 4D signature
%    
%     Contours are taken with respect to the first variable in the
%     signature, colours with respect to the fourth (if present)
%
%     
params = parse_inputs(varargin{:});
J1 = sig{1}; % contour levels with respect to this one
J2 = sig{2};
J3 = sig{3};

levels = params.levels;
if isempty(levels)
    levels = linspace(min(J1(:)), max(J1(:)), params.n_contours);
end

if numel(sig) == 3;
    contour(J2, J3, J1, levels)
else
    % ?
end

function params = parse_inputs(varargin)
p = inputParser();
p.addParameter('levels', []);
p.addParameter('n_contours', 10);
p.parse(varargin{:});
params = p.Results;
end

end