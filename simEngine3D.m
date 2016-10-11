
% Filename: simEngine3D.m
% Author:   Samuel Acu�a
% Date:     11 Oct 2016
% About:    
% Driver file for the simEngine3D framework. Defines the system, the
% bodies in the system, and the constraints and forces in the system. Then
% calls for the solution of the equations of motion for the system.

clear; clc; close all

%% DEFINE SYSTEM %%

sys = system3D(); %initialize system



%% DEFINE BODIES IN THE SYSTEM %%
sys.addBody([10;0;0])
sys.addBody([5;20;7])

%% DEFINE POINTS ON THE BODIES %%

%% DEFINE CONSTRAINTS AMONG THE BODIES %%