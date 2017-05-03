function sig_surface(sig, varargin)
% SIG_SURFACE: Produce a surface plot of a 3D or 4D signature
%    
%     The first variable is the z coordinate (as it is usually the 
%     function value), the fourth is the colour (if present)
%
%     
params = parse_inputs(varargin{:});
J1 = sig{1}; % contour levels with respect to this one
J2 = sig{2};
J3 = sig{3};
if numel(sig) == 4;
    J4 = sig{4};
end
surf_opts = {'edgecolor', 'none', 'facealpha', 0.9};
if numel(sig) == 3
    surf(J2, J3, J1, surf_opts{:})
else
    surf(J2, J3, J1, J4, surf_opts{:}) 
end
camlight()
function params = parse_inputs(varargin)
p = inputParser();
p.addParameter('color', 'b');
p.parse(varargin{:});
params = p.Results;

end
end