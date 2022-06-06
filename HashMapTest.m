classdef HashMapTest < matlab.unittest.TestCase

    properties
        basicData = {...
            {'Key1','Value1'},...
            {'Key2','Value2'},...
        };
        
        basicMixedData = {...
            'Key1',...
            1,...
        };
    
        structMixedData = {...
            'Key1',...
            struct('Key1','Value1','Key2','Value2'),...
        };
    
        structAsKeyData = {...
            struct('Key1','Value1','Key2','Value2'),...
            'Value1'...
        }
    
    
        collisionData = {...
            {1,2,3,4,5,6},...
            {1,2,3,4,5,6}
        }
        
    end
    
    methods (Test)
        
        function instantiationNoInputs(testCase)
           
            map = HashMap();
            
            % Verify size of map is 0
            testCase.verifyEqual(map.size,0,...
                'Size of map is not zero');
            
        end
        
        function instantiationWithInputs(testCase)
            
            map = HashMap(testCase.basicData{1},testCase.basicData{2});
            
            % Verify size of map is 0
            testCase.verifyEqual(map.size,2,...
                'Size of map is not two');
            
        end
        
        function setBasicData(testCase)
            
            map = HashMap();
            map.set(testCase.basicData{1}{1},testCase.basicData{1}{2});
            
            testCase.verifyEqual(map.size,1);
            
        end
        
        function getBasicData(testCase)
            
            map = HashMap();
            map.set(testCase.basicData{1}{1},testCase.basicData{1}{2});
            getVal = map.get(testCase.basicData{1}{1});
            
            testCase.verifyEqual(testCase.basicData{1}{2},getVal);
            
        end
        
        function multiSetOperation(testCase)
            
            map = HashMap();
            map.set(testCase.basicData{1}{1},testCase.basicData{1}{2});
            testCase.verifyEqual(map.size,1);
            map.set(testCase.basicData{2}{1},testCase.basicData{2}{2});
            testCase.verifyEqual(map.size,2);
            
        end
        
        function setBasicMixedData(testCase)
            
            map = HashMap();
            map.set(testCase.basicMixedData{1},testCase.basicMixedData{2});
            
            % Test size
            testCase.verifyEqual(map.size,1);
           
            
        end
        
        function getBasicMixedData(testCase)
            
            map = HashMap();
            map.set(testCase.basicMixedData{1},testCase.basicMixedData{2});
            
            % Test size
            testCase.verifyEqual(map.size,1);
            
            % Test return type from key (double)
            getVal = map.get(testCase.basicMixedData{1});
            testCase.verifyClass(getVal,'double')
            
            % Make sure returned value is same as original data
            testCase.verifyEqual(getVal,testCase.basicMixedData{2});
            
        end
        
        function setStructMixedData(testCase)
            
            map = HashMap();
            map.set(testCase.structMixedData{1},testCase.structMixedData{2});
            
            % Test size
            testCase.verifyEqual(map.size,1);

        end
        
        function getStructMixedData(testCase)
            
            map = HashMap();
            map.set(testCase.structMixedData{1},testCase.structMixedData{2});
            
            % Test size
            testCase.verifyEqual(map.size,1);
            
            % Test return type from key (double)
            getVal = map.get(testCase.structMixedData{1});
            testCase.verifyClass(getVal,'struct')
            
            % Make sure returned value is same as original data
            testCase.verifyEqual(getVal,testCase.structMixedData{2});
            
        end
        
        function setStructAsKey(testCase)
            
            map = HashMap();
            map.set(testCase.structAsKeyData{1},testCase.structAsKeyData{2});
            
            % Test size
            testCase.verifyEqual(map.size,1);
            
        end
        
        function collisionCheck(testCase)
           
            map = HashMap(testCase.collisionData{1},testCase.collisionData{2});
            
            testCase.verifyEqual(map.size,length(testCase.collisionData{1}));
            
        end
        
        function getStructAsKey(testCase)
            
            map = HashMap();
            map.set(testCase.structAsKeyData{1},testCase.structAsKeyData{2});
            
            % Test size
            testCase.verifyEqual(map.size,1);
            
            % Test return type
            map.get(testCase.structAsKeyData{1});
            
        end
        
    end
    
end

