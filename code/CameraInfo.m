classdef CameraInfo < handle
    properties
        position
        target
        viewangle
        upvector
        proj
        light_positions
    end
    
    methods
        function obj = CameraInfo()
        end
        
        function obj = loadFromAxes(obj, varargin)
            if nargin == 1
                ax = gca();
            else
                ax = varargin{1};
            end
            % Get camera position and orientation and projection mode
            obj.position = campos(ax);
            obj.target = camtarget(ax);
            obj.viewangle = camva(ax);
            obj.upvector = camup(ax);
            obj.proj = camproj(ax);
            
            % Find the position of any lighting objects
            gobjs = get(ax, 'children');
            i_lights = find(strcmp('light', get(gobjs, 'type')));
            n_lights = numel(i_lights);
            obj.light_positions = {};
            for i = 1:1:n_lights
                hLight = gobjs(i_lights(i));
                obj.light_positions{i} = get(hLight, 'Position');
            end
        end
        
        function obj = apply(obj, varargin)
            if nargin == 1
                ax = gca();
            else
                ax = varargin{1};
            end
            % Position camera
            campos(ax, obj.position);
            camtarget(ax, obj.target);
            camva(ax, obj.viewangle);
            camup(ax, obj.upvector);
            camproj(ax, obj.proj);
            
            % Turn on lights
            % First remove any lights from the existing axes
            gobjs = get(ax, 'children');
            i_lights = find(strcmp('light', get(gobjs, 'Type')));
            for i = i_lights
                delete(gobjs(i));
            end
            
            for i = 1:numel(obj.light_positions)
                light('Position', obj.light_positions{i}, 'Style', 'local');
            end
        end
    end
end