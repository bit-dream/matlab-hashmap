classdef HashMap < handle
    %HASHMAP Simple hash map utility class that offers benefits over MATLAB's
    %built in container.Map()
    %
    % HashMap will allow any data type as keys or values in the map and
    % allows you to mix or match the data types of keys and values.
    % 
    % Ex. map = HashMap()
    % map.set('a','b')
    % map.get('a') -> 'b'
    % map.has('a') -> True
    % map.delete('a')
    % map.keys() -> {}
    % 
    % map = HashMap({'a','b'},{'c','d'})
    % map.size -> 2
    % map.values() -> {'b','d'}
    
    properties
        size = 0;
    end
    
    properties (Access = private)
        buckets = 2^4;
        bucketSize = 4;
        mapArray = cell(1,2^4);
    end
    
    methods
        
        function obj = HashMap(varargin)
            
            if nargin ~= 2 && nargin ~= 0
               throw(MException(...
                   'HashMap:InputError',...
                   'Input Error: HashMap takes either a key value pairing or nothing (empty initilization).')...
               ); 
            end
            
            if nargin == 2
                % Loop through keys and add to map
                keys = varargin{1};
                values = varargin{2};
                
                if ~iscell(keys) && ~iscell(values)
                    obj.set(keys,values);
                    return
                elseif iscell(keys) && iscell(values)
                    for i = 1:length(keys)
                        obj.set(keys{i},values{i});
                    end
                else
                    throw(MException(...
                       'HashMap:InputError',...
                       'Input Error: Key and value need to be of the same type (cell,cell)')...
                   );
                end

            end
            
        end
        
        function k = keys(obj)
            
            k = {};
            for i = 1:length(obj.mapArray)
               if isempty(obj.mapArray{i})
                   continue;
               end
               
               % Nested keys
               if length(obj.mapArray{i}) > 1
                   for j = 1:length(obj.mapArray{i})
                       k{end+1} = obj.mapArray{i}{j}{1};
                   end
               else
                   k{end+1} = obj.mapArray{i}{1}{1};
               end

            end
        end
        
        function k = values(obj)
            
            k = {};
            for i = 1:length(obj.mapArray)
               if isempty(obj.mapArray{i})
                   continue;
               end
               
               % Nested keys
               if length(obj.mapArray{i}) > 1
                   for j = 1:length(obj.mapArray{i})
                       k{end+1} = obj.mapArray{i}{j}{2};
                   end
               else
                   k{end+1} = obj.mapArray{i}{1}{2};
               end

            end
        end
        
        function set(obj,key,value)
            
            % Check if we need to expand storage of map array
            if obj.overloaded()
               obj.rehash(); 
            end
            
            if ~obj.has(key)
                obj.size = obj.size + 1;
                % This line will automatically perform a psudo seperate
                % chaining type storage. Since we can have nested cells in a
                % cell array, we will use that as storage rather than a linked
                % list.
                obj.mapArray{obj.getIndex(key)}{end+1} = {key,value};
                return
            end
            
            % Key's data is being overwritten
            idx = obj.getIndex(key);
            if length(obj.mapArray{idx}) > 1
                for i = 1:length(obj.mapArray{idx})
                    if strcmp(key,obj.mapArray{idx}{i}{1})
                        obj.mapArray{idx}{i}{2} = value;
                        return
                    end
                end
            end
            obj.mapArray{obj.getIndex(key)}{1} = {key,value};
        end
        
        function val = get(obj,key)
            val = obj.mapArray{obj.getIndex(key)};
            % Check if we have multiple entries stored in table (this is
            % worst case condition)
            if length(val) >= 1
                for i = 1:length(val)
                    if isequal(key,val{i}{1})
                        val = val{i}{2};
                        return
                    end
                end
                
                % Key didn't exist in list
                throw(MException(...
                   'HashMap:NoKey',...
                   'No Key: Could not find key in map')...
               );
            end
            
            if isempty(val)
               % Key didn't exist in list, need to return empty list
                throw(MException(...
                   'HashMap:NoKey',...
                   'No Key: Could not find key in map')...
               ); 
            end
            
            val = val{1}{2};
            
        end
        
        function bool = has(obj,key)
            try
                ret = obj.get(key);
            catch
                ret = [];
            end
            bool = ~isempty(ret);
        end
        
        function delete(obj,key)
            
            % Check that we have the key in map
            if obj.has(key)
               % proceed with object deletion
               idx = obj.getIndex(key);
               entry = obj.mapArray{idx};
               
               % Multiple entries at index
               if length(entry) >= 1
                    for i = 1:length(entry)
                        if isequal(key,entry{i}{1})
                            obj.mapArray{idx}(i) = [];
                            obj.size = obj.size - 1;
                            return
                        end
                    end
               else
                   obj.mapArray(idx) = [];
                   obj.size = obj.size - 1;
               end
            else
                throw(MException(...
                    'HashMap:NoKey',...
                    'No Key: Could not find key in map'...
                ))
            end
            
        end
        
    end
    
    methods (Access = private)
        
        function idx = getIndex(obj,key)
            hash = obj.hash(key);
            idx = mod(hash,obj.buckets-1) + 1;
        end
        
        function hashSum = hash(obj,key)
            hashSum = DataHash(key,'HEX');
            hashSum = hex2dec(hashSum);
        end
          
        function over = overloaded(obj)
            load = obj.size / obj.buckets;
            over = load >= 0.75;
        end
        
        function [keys,values] = pairs(obj)
            keys = obj.keys(); values = {};
            for key = 1:length(keys)
                values{end+1} = obj.get(keys{key});
            end
        end
        
        function rehash(obj)
            obj.bucketSize = obj.bucketSize + 1;
            obj.buckets = 2^(obj.bucketSize);
            
            [keys,values] = obj.pairs();
            obj.mapArray = cell(1,obj.buckets);
            obj.size = 0; 
            for i = 1:length(keys)
               obj.set(keys(i),values(i)) 
            end
            
        end
        
    end
end

