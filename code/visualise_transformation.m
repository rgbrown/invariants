function visualise_transformation(f, tform, varargin)
%VISUALISE_TRANSFORMATION
params = parse_inputs(varargin{:});
x = linspace(params.xlim(1), params.xlim(2), params.nx);
y = linspace(params.ylim(1), params.ylim(2), params.ny);
[X, Y] = meshgrid(x, y);

[Xp, Yp ] = tform.reverse(X, Y);

subplot(1,2,1)
draw_image(f(X, Y), 'xlim', params.xlim, 'ylim', params.ylim)
subplot(1,2,2)
draw_image(f(Xp, Yp), 'xlim', params.xlim, 'ylim', params.ylim)

if params.write
    if isempty(params.filename)
        filename = strcat('images/', class(tform), '_image.jpg');
    else
        filename = params.filename;
    end
    imwrite(f(Xpi, Ypi), filename);
end

end

function parameters = parse_inputs(varargin)
p = inputParser();
p.parse(varargin{:});
p.addParameter('write', false)
p.addParameter('filename', []);
p.addParameter('xlim', [-1, 1]);
p.addParameter('ylim', [-1, 1]);
p.addParameter('nx', 2000);
p.addParameter('ny', 2000);
p.parse(varargin{:});
parameters = p.Results;
end