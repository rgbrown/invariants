function write_transformed_image(f, X, Y, tform, varargin)
params = parse_inputs(varargin{:});



end

function parameters = parse_inputs(varargin)
p = inputParser();
p.addParameter('filename', []);
p.parse(varargin{:});
parameters = p.Results;
end
