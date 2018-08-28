function exportToGmsh2D(fileName, u, p, t, fieldName)

% exportToGmsh2D - Export scalar or vector field to gmsh postprocessing.
%
% This QuickerSim CFD Toolbox function exports data from a solution vector
% (for both scalar and vector fields) to the external file in Gmsh file
% format.
%
% exportToGmsh2D(fileName, u, p, t, fieldName)
%
% Input arguments:
% fileName - name of the exported file (e.g.: 'results.msh' - it should
%            always be supplemented with the *.msh extension for succesful
%            import to Gmsh software.
% u        - solution vector of size nVnodes-by-1 (for a scalar field) or
%            2*nVnodes-by-1 for a vector field.
% p        - array of nodal coordinates of the second order mesh generated
%            by the convertMeshToSecondOrder function.
% t        - array of second order triangular elements generated by the
%            convertMeshToSecondOrder function.
% fieldName - text label which will be associated in gmsh with the exported
%            field.
%
% Examples:
%       1.
%       exportToGmsh2D('velocity.msh', u(1:2*nVnodes), p, t, 'velocity')
%           Above code will export the whole velocity vector field (both x-
%           and y-component), since we take original solution vector u with
%           its elements from first to 2*nVnodes, which means the whole
%           x-velocity field and the whole y-velocity field.
%
%       2.
%       pressure = generatePressureData(u, p, t);
%       exportToGmsh2D('pressure.msh',pressure,p,t,'pressureFieldLabel');
%
%       3.
%       exportToGmsh2D('vx.msh',u(1:nVnodes),p,t,'x-velocity');
%
% Visit www.quickersim.com/cfd-toolbox-for-matlab/index for more info, help
% and support. Contact us by cfdtoolbox@quickersim.com
%
% See also: BOUNDARYFLUX2D, BOUNDARYINTEGRAL2D, COMPUTEFORCE,
%           COMPUTEMOMENT, CONVERTMESHTOSECONDORDER, GENERATEPRESSUREDATA,
%           IMPORTMESHGMSH, INITSOLUTION.

dim = size(p,1);
nnodes = size(p,2);

savescalar = 0;
savevector = 0;
savetensor = 0;

% Check whether to save scalar, vector or tensor
if(size(u)==[nnodes,1])
    savescalar = 1;
elseif(size(u)==[dim*nnodes,1])
    savevector = 1;
elseif(size(u)==[dim*nnodes,dim])
    savetensor = 1;
end

if(savescalar)
    % Export scalar quantity
    fd = fopen(fileName, 'wt');
    fprintf(fd, '$MeshFormat\n2.1 0 8\n$EndMeshFormat\n$Nodes\n%d\n', nnodes);
    
    for i = 1:nnodes
        fprintf(fd, '%d %e %e %e\n', i, p(1,i), p(2,i), 0);
    end
    
    fprintf(fd, '$EndNodes\n$Elements\n%d\n', size(t,2));
    
    for i = 1:size(t,2)
        fprintf(fd, '%d 9 0 %d %d %d %d %d %d\n', i, t(1,i), t(2,i), t(3,i), t(4,i), t(5,i), t(6,i));
    end
    
    fprintf(fd, ['$EndElements\n$NodeData\n1\n' fieldName '\n1\n0.000000\n3\n0\n1\n%d\n'], nnodes);
    
    for i = 1:nnodes
        fprintf(fd, '%d %e\n', i, u(i));
    end
    
    fprintf(fd, '$EndNodeData\n');
    
    fclose(fd);
end

if(savevector)
    % Export scalar quantity
    fd = fopen(fileName, 'wt');
    fprintf(fd, '$MeshFormat\n2.1 0 8\n$EndMeshFormat\n$Nodes\n%d\n', nnodes);
    
    for i = 1:nnodes
        fprintf(fd, '%d %e %e %e\n', i, p(1,i), p(2,i), 0);
    end
    
    fprintf(fd, '$EndNodes\n$Elements\n%d\n', size(t,2));
    
    for i = 1:size(t,2)
        fprintf(fd, '%d 9 0 %d %d %d %d %d %d\n', i, t(1,i), t(2,i), t(3,i), t(4,i), t(5,i), t(6,i));
    end
    
    fprintf(fd, ['$EndElements\n$NodeData\n1\n"' fieldName '"\n1\n0.000000\n3\n0\n3\n%d\n'], nnodes);
    
    for i = 1:nnodes
        fprintf(fd, '%d %e %e %e\n', i, u(i), u(nnodes+i), 0);
    end
    
    fprintf(fd, '$EndNodeData\n');
    
    fclose(fd);
end

end