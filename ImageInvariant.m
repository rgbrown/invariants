classdef ImageInvariant
    properties
        % Note: default values are in the "parseinputs" function below
        h
        f
        xlim
        ylim
    end
    methods
        function self = ImageInvariant(f, varargin)
            self.f = f;
            params = parse_inputs(varargin{:});
            fields = fieldnames(params);
            for i = 1:numel(fields)
                self.(fields{i}) = params.(fields{i});
            end
        end   
        function [F, X, Y] = evaluate(self)
            x = self.xlim(1):self.h:self.xlim(2);
            y = self.ylim(1):self.h:self.ylim(2);
            [X, Y] = meshgrid(x, y);
            F = self.f(X, Y);
        end
        function varargout = SA2_signature(self)
            F = self.evaluate();
            [~, Fx, Fy, Fxx, Fxy, Fyy, Fxxx, Fxxy, Fxyy, Fyyy] = ...
                compute_derivatives(F, 3, self.h);
            I0 = F;
            I1 = Fxx.*Fyy - Fxy.^2;
            I2 = Fy.^2.*Fxx - 2*Fx.*Fy.*Fxy + Fx.^2.*Fyy;
            I3 = Fyy.*Fxxy.^2 - Fyy.*Fxxx.*Fxyy - Fxy.*Fxxy.*Fxyy + ...
                Fxx.*Fxyy.^2 + Fxy.*Fxxx.*Fyyy - Fxx.*Fxxy.*Fyyy;
            I4 = Fy.*Fyy.*Fxxx - 2*Fy.*Fxy.*Fxxy - Fx.*Fyy.*Fxxy + ...
                Fy.*Fxx.*Fxyy + 2*Fx.*Fxy.*Fxyy - Fx.*Fxx.*Fyyy;
            varargout = {I0, I1, I2, I3, I4}; 
        end
        function varargout = SE2_signature(self)
            F = self.evaluate();
            [~, Fx, Fy, Fxx, ~, Fyy] = ...
                compute_derivatives(F, 2, self.h);
            I0 = F;
            I1 = Fx*Fx + Fy*Fy;
            I2 = Fxx + Fyy;
            varargout = {I0, I1, I2};
        end
        function varargout = Sim2_signature(self)
           F = self.evaluate();
           [~, Fx, Fy, Fxx, Fxy, Fyy] = compute_derivatives(F, 2, self.h);
           J1 = Fx.*Fx + Fy.*Fy;
           J2 = Fxx + Fyy;
           J3 = sqrt(Fxx.*Fxx + 2*Fxy.*Fxy + Fyy.*Fyy);
           denom = sqrt(J1.*J1 + J2.*J2 + J3.*J3);
           J1 = J1 ./ denom;
           J2 = J2 ./ denom;
           J3 = J3 ./ denom;
           
           I1 = acos(J3);
           I2 = atan2(J2, J1);
           
           varargout = {F, I1, I2};
        end
        function varargout = PSL3R_signature(self)
            F = self.evaluate();
            [~, Fx, Fy, Fxx, Fxy, Fyy, Fxxx, Fxxy, Fxyy, Fyyy] = ...
                compute_derivatives(F, 3, self.h);
            D = Fx.^2.*Fyy + Fy.^2*Fxx - 2*Fx.*Fy.*Fxy;
            
            choice of frame depends on sign of D (which is itself an
            invariant)
            i_dge0 = D >= 0;
            d = zeros(size(Fx));
            d(i_dge0) = Fx(i_dge0) ./ sqrt(D(i_dge0));
            d(~i_dge0) = Fx(~i_dge0) ./ sqrt(-D(~i_dge0));
            b = -d * Fy ./ Fx;
            
            what is this? which moving frame variable was set to zero -
            It was Fbar222
            h = d./(6*D.*Fx) .* (-Fxxx.*Fy.^3 + 3*Fxxy.*Fy.^2.*Fx - ...
                3*Fxyy.*Fx.^2.*Fy + Fyyy.*Fx.^3);
            
            
            Robert's typo version:
            h = (d.*(Fyyy.*Fx.^3 - 3*Fx.^2.*Fy.*Fxyy - 3*Fx.*Fy.^2.*Fxxy +...
               Fy.^3.*Fxxx)) ./ (6*Fx.*D);
            
            We believe this is correct - differs from Robert's in the D
            in denominator of second term
            c = h.*Fx.^2./(d.*D) - (Fx.*Fxy - Fy.*Fxx) ./ D;
            a = (1 - c.*Fy) ./ Fx;
            
            checked g
            g = 1 ./ (2*Fx.^2) .* (Fxx + 2*c.*(Fx.*Fxy - Fy.*Fxx) + c.^2.*D);
            
            G is Fbar
            Gx = a.*Fx + c.*Fy;
            Gy = b.*Fx + d.*Fy;
            Gxx = -2*a.*g.*Fx - 2.*c.*g.*Fy + ...
                a.^2.*Fxx + 2*a.*c*Fxy + c.^2.*Fyy;
            Gxy = (-b.*g - a.*h).*Fx + (-d.*g - c.*h).*Fy + ...
                a.*b.*Fxx + (b.*c + a.*d).*Fxy + c.*d.*Fyy;
            Gyy = -2*b.*h.*Fx - 2.*d.*h.*Fy + ...
                b.^2.*Fxx + 2*b.*d.*Fxy + d.^2.*Fyy;
            
            Gxxx = 6*a.*g.^2.*Fx + ...
                6*c.*g.^2.*Fy + ...
                -6*a.^2.*g.*Fxx + ...
                -12*a.*c.*g.*Fxy + ...
                -6*c.^2.*g.*Fyy + ...
                a.^3.*Fxxx + ...
                3*a.^2.*c.*Fxxy + ...
                3*a.*c.^2.*Fxyy + ...
                c.^3.*Fyyy;
            
            Gxxy = 2*g.*(b.*g + 2*a.*h).*Fx + 2*g.*(d.*g + 2*c.*h).*Fy + ...
                -2*a.*(2*b.*g + a.*h).*Fxx + ...
                -4*(b.*c.*g + a.*d.*g + a.*c.*h).*Fxy + ...
                -2*c.*(2*d.*g + c.*h).*Fyy + ...
                a.^2.*b.*Fxxx + ...
                a.*(2*b.*c + a.*d).*Fxxy + ...
                c.*(b.*c + 2.*a.*d).*Fxyy + ...
                c.^2.*d.*Fyyy;
            
             Gxyy = 2*h.*(2*b.*g + a.*h).*Fx + 2*h.*(2*d.*g + c.*h).*Fy + ...
                -2*b.*(b.*g + 2*a.*h).*Fxx + ...
                -4*(b.*d.*g + b.*c.*h + a.*d.*h).*Fxy + ...
                -2*d.*(d.*g + 2*c.*h).*Fyy + ...
                a.*b.^2.*Fxxx + ...
                b.*(b.*c + 2*a.*d).*Fxxy + ...
                d.*(2*b.*c + a.*d).*Fxyy + ...
                d.^2.*c.*Fyyy;
            
            Gyyy = 6*b.*h.^2.*Fx + ...
                6*d.*h.^2.*Fy + ...
                -6*b.^2.*h.*Fxx + ...
                -12*b.*d.*h.*Fxy + ...
                -6*d.^2.*h.*Fyy + ...
                b.^3.*Fxxx + ...
                3*b.^2.*d.*Fxxy + ...
                3*b.*d.^2.*Fxyy + ...
                d.^3.*Fyyy;
            
            J1 = Gxxx;
            J2 = Gxxy.^2;
            J3 = Gxyy;
            
            denom = sqrt(J1.^2 + J2.^2 + J3.^2);
            
            I1 = acos(J3 ./ denom);
            I2 = atan2(J2, J1);
            
            varargout = {F, J1, J2, J3};
        end
            
        
        
        function varargout = mobius_signature(self, varargin)
            % MOBIUS_SIGNATURE: compute Mobius signature
            %    [S0, S1, S2, S3, S4] = self.mobius_signature()
            %    [S0, S1, S2, S3, S4] = self.mobius_signature(tol)
            if nargin == 2
                tol = varargin{1};
            else
                tol = 0;
            end
            F = self.evaluate();
            [~, Fx, Fy, Fxx, ~, Fyy] = compute_derivatives(F, 2, self.h);
            normaliser = sqrt(Fx.*Fx + Fy.*Fy);
            
            % Do the easy ones
            J1 = Fx.*Fx + Fy.*Fy;
            J2 = Fxx + Fyy;
            g = J2 ./ J1;
            [gx, gy] = gradient(g, self.h);
            
            real_cube_root = @(x) sign(x) .* abs(x).^(1/3);
            
            J3 = J1 .* real_cube_root(real((gx + 1j*gy)./(Fx + 1j*Fy)));
            
            % Project these onto a sphere
            denom = sqrt(J1.*J1 + J2.*J2 + J3.*J3);
            J1t = J1 ./ denom;
            J2t = J2 ./ denom;
            J3t = J3 ./ denom;
            
            I1 = acos(J3t);
            I2 = atan(J2t ./ J1t);
            
            % Compute n
            n = {Fx ./ normaliser, Fy ./ normaliser};
            
            % Compute I3
            [n2x, n2y] = gradient(n{2}, self.h);
            [n1x, n1y] = gradient(n{1}, self.h);
            curl = n2x - n1y;
            [curl_x, curl_y] = gradient(curl, self.h);
            I3 = 1 ./ J1 .* (n{1}.*curl_x + n{2}.*curl_y);
            
            % Compute I4
            divergence = n1x + n2y;
            [divergence_x, divergence_y] = gradient(divergence, self.h);
            I4 = 1 ./ J1 .* (n{1}.*divergence_y - n{2}.*divergence_x);
            
            idx = Fx.*Fx + Fy.*Fy < tol;
            I1(idx) = 0;
            I2(idx) = 0;
            I3(idx) = 0;
            I4(idx) = 0;
            varargout = {F, I1, I2, I3, I4};
        end
    end
end



function params = parse_inputs(varargin)
p = inputParser();
p.addParameter('xlim', [-1, 1])
p.addParameter('ylim', [-1, 1])
p.addParameter('h', 1e-2)
p.parse(varargin{:})
params = p.Results;
end

function varargout = compute_derivatives(F, N, h)
% COMPUTE_DERIVATIVES compute derivatives up to order N, returned in order
%     fx, fy, fxx, fxy, fyy, fxxx, fxxy, fxyy, fyyy, etc
derivs = cell((N+1)*(N+2)/2, 1);
derivs{1} = F;
k = 2; % index where next derivative goes
for i = 1:N % order
    start = ((i - 1)*i)/2;
    for j = 1:i
        if j == 1
            [derivs{k}, derivs{k+1}] = gradient(derivs{start+j}, h);
            k = k + 1;
        else
            [~, derivs{k}] = gradient(derivs{start+j}, h);
        end
        k = k + 1;
    end
end
varargout = derivs;
end