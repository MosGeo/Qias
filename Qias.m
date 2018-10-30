classdef Qias
%% Qias: Unit conversion with Matlab
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%%
    properties (Access = private)
        Graphs = containers.Map;
        
    end
%% Methods (instance)
    methods
        
        % ============================================
        function obj = Qias(graphsFolder)
            
            % Defaults
            if ~exist('graphsFolder', 'var')
                libraryFolder = fileparts(mfilename('fullpath'));
                graphsFolder  = fullfile(libraryFolder, 'Graphs');
            end
            
            % Main
            graphsName = Qias.graphNamesFromFolder(graphsFolder);
            for i = 1:numel(graphsName)
                fileName = fullfile(graphsFolder, [graphsName{i}, '.csv']);
                Graph = Qias.graphLoad(fileName);
                assert(all(conncomp(Graph)==1), 'Graph is not connected. Make sure the input data is correct');
                obj.Graphs(graphsName{i}) = Graph;
            end
        end
        % ============================================
        function Graph = getGraph(obj, graphName)
           % Check if graph exist
            assert(ismember(graphName,keys(obj.Graphs)), 'Graph not found');
            Graph = obj.Graphs(graphName); 
        end
        % ============================================
        function units = getUnits(obj, graphName)
            Graph = obj.getGraph(graphName);
            units = Graph.Nodes;
        end
        % ============================================
        function properties = getProperties(obj)
            properties = keys(obj.Graphs);
        end
        % ============================================
        function valueUnitTo = convert(obj, valueUnitFrom, unitFrom, unitTo, graphName)
            Graph = obj.getGraph(graphName);
            valueUnitTo = Qias.graphConvert(valueUnitFrom, unitFrom, unitTo, Graph);
        end
        
    end
%% Methods (static)

    methods (Static)
        
        % ============================================
        function graphsName = graphNamesFromFolder(folder)
            
            % Assertions
            assert(exist('folder', 'var')==true && exist(folder, 'dir') == 7, 'Folder does not exist');
            
            % Main
            fileListing   = dir(fullfile(folder, '*.csv'));
            fileListing =  struct2table(fileListing);
            graphsName = cellfun(@(x) x(1:end-4), fileListing.name, 'UniformOutput', false);
        end
        % ============================================
        function Graph = graphLoad(fileName)
            
            % Assertions
            assert(exist('fileName', 'var')==true && exist(fileName, 'file') ==2, 'File does not exist');
            
            % Read table
            graphTable = readtable(fileName);
            
            % Create inverse graph
            graphTableInverse = graphTable;
            graphTableInverse(:,1) = graphTable(:,2);
            graphTableInverse(:,2) = graphTable(:,1);
            graphTableInverse{:,3} = 1./graphTableInverse{:,3};

            % Combine the graphs and insert them into a graph
            fullGraphTable = [graphTable; graphTableInverse];
            Graph = digraph(fullGraphTable{:,1}, fullGraphTable{:,2}, fullGraphTable{:,3});  
        end    
        % ============================================
        function valueUnitTo = graphConvert(valueUnitFrom, unitFrom, unitTo, Graph)
            
            % Assertions
            assert(exist('valueUnitFrom','var')==true && isnumeric(valueUnitFrom), 'valueUnitFrom must be numeric');
            assert(exist('unitFrom','var')==true && ischar(unitFrom), 'unitFrom must be a string');
            assert(exist('unitTo','var')==true && ischar(unitTo), 'unitTo must be a string');
            assert(exist('Graph','var')==true && isa(Graph, 'digraph'), 'Graph must be a digraph');
            
            % Main
            shortPath = shortestpath(Graph, unitFrom, unitTo, 'Method','unweighted');
            idxOut = findedge(Graph,shortPath(1:end-1)',shortPath(2:end)');
            multiplier = prod(Graph.Edges.Weight(idxOut));
            valueUnitTo = valueUnitFrom*multiplier;
            
        end
        % ============================================
        function units = graphUnits(Graph)
        
            % Assertions
            assert(exist('Graph','var')==true && isa(Graph, 'digraph'), 'Graph must be a digraph');

            % Main
            units = Graph.Nodes;
        end
        % ============================================
        function [] = graphPlot(Graph)
            
            % Assertions
            assert(exist('Graph','var')==true && isa(Graph, 'digraph'), 'Graph must be a digraph');
            
            % Main
            plot(Graph, 'Layout','force', 'EdgeLabel',Graph.Edges.Weight);
        end
        % ============================================
   
    end

end