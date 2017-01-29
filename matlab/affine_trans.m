function [xout,yout] = affine_trans(xin,yin,trans)
% Performs a affine transformation of the points in xin and yin
% if trans has 4 parameters, it is just scaling, rotation and translation
%
% 4 Parameter Affine
%
%	trans(1) = lambda*cos(theta)
%	trans(2) = lambda*sin(theta)
%	trans(3) = xshift
%	trans(4) = yshift
%
%	x' = trans(1)*x - trans(2)*y + trans(3)
%	y' = trans(1)*y + trans(2)*x + trans(4)
%
%	NOTE: this is the same as used in the old NRR code, but not the same as is used in ASMs!
%
% 6 Parameter Affine
%
%	trans(1) to trans(4) are as before
%	trans(5) is the xshear xs
%	trans(6) is the yshear ys
%
%	The transformation is:
%
%	x'		lambda*(1 sx)*(1  0)*(cos(theta) -sin(theta))*(x) + xshift
%	y'			      (0 1  ) (sy 1) (sin(theta)   cos(theta))*(y) + yshift
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	

% Check that xin and yin are the same size, else return empty matrix
if( (length(xin(:))~=length(yin(:)) )| isempty(xin) )
	xout = [];
	yout = [];
else
	% Make yin the same size as xin
	yin = reshape(yin,size(xin));
	if(length(trans(:))==4)
		trans(5) = 0;
		trans(6) = 0;
	end

		xout = 	( trans(1)*( 1 + trans(5)*trans(6) ) + trans(5)*trans(2) )*xin +...
			     ( -trans(2)*( 1 + trans(5)*trans(6) ) + trans(5)*trans(1) )*yin + trans(3);
		yout = 	( trans(2) + trans(6)*trans(1) )*xin +...
			     ( -trans(2)*trans(6) + trans(1) )*yin + trans(4);
end