classdef body3D < handle
    % Filename: body.m
    % Author:   Samuel Acu�a
    % Date:     11 Oct 2016
    % About:
    % a generic spatial rigid body, including all the attributes of the
    % body, as well as local points on the body.This also
    % estabilishes the local reference frame.
    properties
        ID;   % body ID number
        r; % = [x;y;z] location of body RF from GLOBAL RF
        p; % = [e0;e1;e2;e3] euler parameters of BODY RF
        pdot; % = [4x1] time derivative of euler parameters p
        m; % mass of the part
        J; % inertia tensor of the part
        isGround; % if body is ground
        point; % structure of points on the body, defined in BODY RF
    end
    properties (Dependent)
        nPoints; % number of points on the body
        A; % rotation matrix, an expression of the euler parameters
    end
    methods (Access = public)
        function body = body3D(ID,r,p,pdot,m,J,isGround) %constructor function
            if ~exist('isGround','var') || isempty(isGround)
                isGround = 0; % body is not ground
            end
            if ~exist('J','var') || isempty(J) || isGround == 1
                J = zeros(3); % body has no inertia
            end
            if ~exist('m','var') || isempty(m) || isGround == 1
                m = 0; % body has no mass
            end
            if ~exist('pdot','var') || isempty(pdot) || isGround == 1
                pdot = [0;0;0;0]; % no velocity change in body orientation
            end
            if ~exist('p','var') || isempty(p)
                p = [1;0;0;0]; % no change in body orientation from GLOBAL RF
            end
            if ~exist('r','var') || isempty(r)
                r = [0;0;0]; % body located at origin
            end
            
            % instantiate body properties
            body.ID = ID;
            body.r = r;
            body.p = p;
            body.pdot = pdot;
            body.m = m;
            body.J = J;
            body.isGround = isGround;
            body.point = {}; % no points defined yet
        end
        function addPoint(body,aBar) % add a body to the system
            % inputs:
            %    - body: body you are adding point to
            %    - aBar: [3x1] position of point in BODY RF
            if ~exist('aBar','var') || isempty(aBar)
                aBar = [0;0;0]; % point located at origin of body
            end
            body.point{body.nPoints+1} = aBar;
        end
        
    end
    methods % methods block with no attributes
        function nPoints = get.nPoints(body) % calculate number of bodies in system
            nPoints = length(body.point);
        end
        function A = get.A(body) % calculate rotation matrix, an expression of the euler parameters
            A = utility.p2A(body.p);
        end
    end
end