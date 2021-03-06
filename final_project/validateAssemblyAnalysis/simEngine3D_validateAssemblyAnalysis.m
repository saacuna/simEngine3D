% Filename: validateAssemblyAnalysis.m
% Author:   Samuel Acu�a
% Date:     02 Dec 2016
%
% About:    
% Driver file for the simEngine3D framework. Defines the system, the
% bodies in the system, and the constraints in the system.
% Uses the double pendulum to test assembly analysis

clear; clc; close all

% access directory with simEngine in it.
currentpath = cd('..'); cd('..');
addpath(pwd); % add grandparent folder to path
cd(currentpath); % return to initial folder

%% DEFINE SYSTEM %%

sys = system3D(); %initialize system

%% DEFINE BODIES IN THE SYSTEM %%

% body 1, ground
sys.addBody('ground') % body 1, ground

% body 2, in initial configuration. All units in SI
L2 = 2; 
theta = pi/2; %initial rotation,radians
R = utility.R2(pi/2)*utility.R3(theta); % initial pendulum rotation
p = utility.A2p(R); % euler parameter for pendulum LRF rotation
sys.addBody('free',[0;L2*sin(theta);-L2*cos(theta)],p); % add body 2
sys.body{2}.color = [0.4141, 0.3516, 0.8008]; %slateblue

% set body 2 mass
rho = 7800; Length = 4; width = 0.05; 
volume = Length*width*width;
mass = rho*volume;
sys.body{2}.setMass(mass);

% set body 2 inertia
J = zeros(3); 
J(1,1) = mass/12*(width^2+width^2);
J(2,2) = mass/12*(Length^2+width^2);
J(3,3) = mass/12*(Length^2+width^2);
sys.body{2}.setInertia(J);

% body 3, in initial configuration. All units in SI
L3 = L2/2;
theta = 0; %initial rotation,radians
R = utility.R2(pi/2)*utility.R3(theta); % initial pendulum rotation
p = utility.A2p(R); % euler parameter for pendulum LRF rotation
sys.addBody('free',[0;2*L2+L3*sin(theta);-L3*cos(theta)],p); % add body 3
sys.body{3}.color = [0.6953, 0.1328, 0.1328]; %Firebrick red

% set body 3 mass
rho = 7800; Length = 2; width = 0.05; 
volume = Length*width*width;
mass = rho*volume;
sys.body{3}.setMass(mass);

% set body 3 inertia
J = zeros(3); 
J(1,1) = mass/12*(width^2+width^2);
J(2,2) = mass/12*(Length^2+width^2);
J(3,3) = mass/12*(Length^2+width^2);
sys.body{3}.setInertia(J);


%% DEFINE POINTS ON THE BODIES %%
% these are used to specify heads and tails of vectors
sys.body{1}.addPoint([0;0;0]); % body 1, point 1
sys.body{1}.addPoint([0;1;0]); % body 1, point 2
sys.body{1}.addPoint([0;0;-1]); % body 1, point 3
sys.body{2}.addPoint([0;0;0]); % body 2, point 1
sys.body{2}.addPoint([0;0;1]); % body 2, point 2
sys.body{2}.addPoint([-2;0;0]); % body 2, point 3
sys.body{2}.addPoint([2;0;0]); % body 2, point 4
sys.body{2}.addPoint([0;-1;0]); % body 2, point 5

sys.body{3}.addPoint([-1;0;0]); % body 3, point 1
sys.body{3}.addPoint([0;0;0]); % body 3, point 2
sys.body{3}.addPoint([0;0;1]); % body 3, point 3
sys.body{3}.addPoint([1;0;0]); % body 3, point 4, just for looks

%% PLOT THE SYSTEM in 3D %%
sys.plot(1) % plot with reference frames
view(98,12);
axis equal


%% PERTURB ASSEMBLY FROM CONSISTENT CONFIGURATION
% at this point, the pendulum should have a consistent configuration
perturbSize = 0.001;
sys.constructQ();
q_original = sys.q;
q_perturbed = sys.q + perturbSize*rand(size(sys.q)); % slightly adjust q vector (positions and orientations)
sys.updateSystem(q_perturbed,[],[])

%% DEFINE CONSTRAINTS AMONG THE BODIES %%

% KINEMATIC CONSTRAINTS
% revolute joint with ground body
sys.addConstraint('rj',sys.body{1},1,1,2,1,3,sys.body{2},3,1,2)

% revolute joint body 3 to body 2
sys.addConstraint('rj',sys.body{2},4,1,4,1,5,sys.body{3},1,2,3)

% EULER PARAMETER NORMALIZATION CONSTRAINTS
sys.addEulerParamConstraints(); 

%% ASSEMBLE CONSTRAINT MATRIX 
q_assembled = sys.assemblyAnalysis();

sys.assembleConstraints(q_assembled)
%% Validate THE SOLUTION
sys.checkInitialConditions(1e-5)

q_difference = q_original-q_assembled



