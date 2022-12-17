classdef StoreData
    %STOREDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods (Static)
        function imgSize = GetImageSize()
            %STOREDATA Construct an instance of this class
            %   Detailed explanation goes here
            imgSize = 250;
        end

        function maxImg = GetMaximumImages()
            %STOREDATA Construct an instance of this class
            %   Detailed explanation goes here
            maxImg = 5;
        end
        
    end
end
