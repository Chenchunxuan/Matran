classdef Constraint < bulk.BulkData
    %Constraint Describes a constraint applied to a node.
    %
    % The definition of the 'Constraint' object matches that of the SPC1
    % bulk data type from MSC.Nastran.
    %
    % Valid Bulk Data Types:
    %   - 'SPC1'
            
    methods % construction
        function obj = Constraint(varargin)
                    
            %Initialise the bulk data sets
            addBulkDataSet(obj, 'SPC1', ...
                'BulkProps'  , {'SID', 'C', 'G'}, ...
                'PropTypes'  , {'i'  , 'c', 'i'}, ...
                'PropDefault', {''   , '' ,''}  , ...
                'ListProp'   , {'G'}, ...
                'Connections', {'G', 'bulk.Node', 'Nodes'}, ...
                'SetMethod'  , {'C', @validateDOF});
            
            varargin = parse(obj, varargin{:});
            preallocate(obj);
            
        end
    end
    
    methods % visualisation
        function hg = drawElement(obj, hAx)
            %drawElement Draws the constraint objects as a discrete marker
            %at the specified nodes and returns a single handle for all the
            %beams in the collection.
            
            coords = obj.Nodes.X(:, obj.NodesIndex);
            
            hg  = line(hAx, ...
                'XData', coords(1, :), ...
                'YData', coords(2, :), ...
                'ZData', coords(3, :), ...
                'LineStyle'      , 'none' , ...
                'Marker'         , '^'    , ...
                'MarkerFaceColor', 'c'    , ...
                'MarkerEdgeColor', 'k'    , ...
                'Tag'            , 'Constraints', ...
                'SelectionHighlight', 'off');

        end
    end
    
end  