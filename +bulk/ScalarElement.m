classdef ScalarElement < bulk.BulkData
    %ScalarElement Describes an element that connects to two nodes or to
    %one node and the ground.
    %
    % The defintion of the 'ScalarElement' matches the various scalar
    % elements in MSC.Nastran such as CMASS, CELAS, CDAMP.
    %
    % Valid Bulk Data Types:
    %   - CMASS1
    %   - CMASS2
    %   - CMASS3
    %   - CMASS4
        
    methods %construction
        function obj = ScalarElement(varargin)
            
            %Initialise the bulk data sets
            addBulkDataSet(obj, 'CMASS1', ...
                'BulkProps'  , {'EID', 'PID', 'G1', 'C1', 'G2', 'C2'}  , ...
                'PropTypes'  , {'i'  , 'i'  , 'i' , 'c' , 'i' , 'c' }  , ...
                'PropDefault', {''   , ''   , ''  , ''  , 0   , ''  }  , ...
                'SetMethod'  , {'C1', @validateDOF, 'C2', @validateDOF}, ...
                'Connections', { ...
                'PID', 'bulk.PMASS', 'MassProp', ...
                'G1' , 'GRID' , 'Node1'   , ...
                'G2' , 'GRID' , 'Node2'});
            addBulkDataSet(obj, 'CMASS2', ...
                'BulkProps'  , {'EID', 'M'  , 'G1', 'C1', 'G2', 'C2'}  , ...
                'PropTypes'  , {'i'  , 'r'  , 'i' , 'c' , 'i' , 'c' }  , ...
                'PropDefault', {''   , ''   , ''  , ''  , 0   , ''  }  , ...
                'SetMethod'  , {'C1', @validateDOF, 'C2', @validateDOF}, ...
                'Connections', { ...
                'G1' , 'GRID' , 'Node1'   , ...
                'G2' , 'GRID' , 'Node2'});
            addBulkDataSet(obj, 'CMASS3', ...
                'BulkProps'  , {'EID', 'PID', 'S'}, ...
                'PropTypes'  , {'i'  , 'r'  , 'i'}, ...
                'PropDefault', {''   , ''   , '' }, ...
                'PropMask'   , {'S', 2}           , ...
                'AttrList'   , {'S', {'nrows', 2}}, ...
                'Connections', { ...
                'PID', 'bulk.PMASS', 'MassProp', ...
                'S'  , 'SPOINT'    , 'ScalarNode'});
            addBulkDataSet(obj, 'CMASS4', ...
                'BulkProps'  , {'EID', 'M', 'S'  }, ...
                'PropTypes'  , {'i'  , 'r'  , 'i'}, ...
                'PropDefault', {''   , ''   , '' }, ...
                'PropMask'   , {'S', 2}           , ...
                'AttrList'   , {'S', {'nrows', 2}}, ...
                'Connections', {'S', 'SPOINT', 'ScalarNode'});
            
            varargin = parse(obj, varargin{:});
            preallocate(obj);
            
        end
    end
    
    methods % visualisation
        function hg = drawElement(obj, hAx)

            coords1 = getDrawCoords(obj.Node1, obj.DrawMode); 
            coords2 = getDrawCoords(obj.Node2, obj.DrawMode);
            
            %Check index for grounded terminals
            ind  = [obj.Node1Index ; obj.Node2Index];
            idx  = ~any(ind == 0);
            indG = ind(:, ~idx); %grounded
            
            %Grab coordinates
            % - Grounded elements will be plotted as marker at the opposite
            %   node to the grounded node. e.g. if node 1 is grounded then
            %   we plot the marker at node 2 coordinates
            x  = [coords1(:, indG(2, indG(2, :) ~= 0)), coords2(:, indG(1, indG(1, :) ~= 0))];
            xA = coords1(:, obj.Node1Index(idx));
            xB = coords2(:, obj.Node2Index(idx));  
            
            hg(1) = drawNodes(x, hAx, ...
                'Marker', 's', 'MarkerFaceColor', 'b', 'Tag', 'Scalar Element');
            hg(2) = drawLines(xA, xB, hAx, ...
                'Color', 'b', 'LineStyle', '--', 'Tag', 'Scalar Element');
            
        end
    end
    
end

