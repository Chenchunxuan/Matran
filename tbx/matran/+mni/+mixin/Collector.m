classdef Collector < mni.mixin.Entity & mni.mixin.Dynamicable
    %Collector Handles a collection of data by assigning dynamic properties
    %each time a new object type is added to the collection.
    %
    % Detailed Description:
    %   - The 'AssignMethod' must return the object which will be assigned to the dynamic property.
    
    %Tracking the collection
    properties (SetAccess = private, Hidden = true)
        ItemNames = {};
    end
    
    %Controlling the contents of the collection
    properties (SetAccess = protected)
        %Name of class which can be collected by this object
        CollectionClass       = 'mni.mixin.Entity';
        %Descriptor of the class which can be collected
        CollectionDescription = 'matran entity';
        %Method used to assign multiple sets of data to the same property
        AssignMethod          = @horzcat;
    end
    
    methods % adding/removing items from the collection
        function addItem(obj, item)
            %addItem Adds an item to the collection.
            %
            % Syntax:
            %   - Adding a single item to the collection:
            %       >> Bar = mni.bulk.Beam('CBAR', 50)
            %       >> addItem(obj, Bar);
            %   - Adding multiple items to the collection
            
            assert(numel(obj) == 1, ['Method ''addItem'' is not valid ', ...
                'for object arrays.']);
            if numel(item) > 1
                allClass = arrayfun(@class, item, 'Unif', false);
                if numel(unique(allClass)) > 1
                    error('Update code to heterogenous arrays');
                    %Loop through each different class and add the items
                    %arrayfun(@(i) addItem(obj, i), item);
                    %return
                end
            end
            if ~isa(item, obj.CollectionClass)
                warning(['Expected the %s object to be an instance ', ...
                    'of the %s class, instead it was of class %s']  , ...
                    obj.CollectionDescription, obj.CollectionClass, class(item));
                return
            end
            
            nam = get(item ,{'Name'});
            nam = unique(nam);
            if numel(nam) > 1
                error('Update code for heterogeneous arrays');
            end
            nam = nam{:};
            if isempty(nam)
                warning(['Unable to add the item of class %s to the ', ...
                    'collection as no name has been assigned.'], class(item));
                return
            end
            
            if isprop(obj, nam)
                obj.(nam)     = obj.AssignMethod([obj.(nam), item]);
            else
                addDynamicProp(obj, nam);
                obj.(nam)     = item;
                obj.ItemNames = [obj.ItemNames, {nam}];
            end
            
        end
        function item = removeItem(obj, item)
            %removeItem 
        end
    end
end
