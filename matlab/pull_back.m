function [pullback_image] = pull_back(xgrid,ygrid,xsamp,ysamp,image,type)
% assumes we know image values on regular grid of points (xgrid,ygrid)
% we wish to know it on irregular set of points (xsamp,ysamp)

% if type is 'nan' leaves NaNs in pullback_image
% else replaces with median values

pullback_image(:,:,1) = interp2(xgrid,ygrid,image(:,:,1),xsamp,ysamp,'cubic');
pullback_image(:,:,2) = interp2(xgrid,ygrid,image(:,:,2),xsamp,ysamp,'cubic');
pullback_image(:,:,3) = interp2(xgrid,ygrid,image(:,:,3),xsamp,ysamp,'cubic');

if(nargin==5)
	type = 'nan';
end

if(~strcmp(type,'nan'))
	where = find(isnan(pullback_image));
	if(~isempty(where))
		pullback_image(where) = median(image(:));
	end
end