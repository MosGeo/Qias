%%  Initializations
clear all

% Get graph names
libraryFolder = fileparts(mfilename('fullpath'));
libraryFolder = 'C:\Users\malibrah\Documents\GitHub\Qias';
fileListing   = dir(fullfile(libraryFolder, 'Graphs', '*.csv'));
fileListing =  struct2table(fileListing);
graphsName = cellfun(@(x) x(1:end-4), fileListing.name, 'UniformOutput', false);
nGraphs    = numel(graphsName);

% Load a file and convert into a graph

Graphs = containers.Map;

for i = 1:nGraphs
    graphName = graphsName{i};
    fileName = fullfile(libraryFolder, 'Graphs', [graphName, '.csv']);
    graphTable = readtable(fileName);

    % Create inverse graph
    graphTableInverse = flipedge(graphTable);
    graphTableInverse(:,1) = graphTable(:,2);
    graphTableInverse(:,2) = graphTable(:,1);
    graphTableInverse{:,3} = 1./graphTableInverse{:,3};

    % Combine the graphs and insert them into a graph
    fullGraphTable = [graphTable; graphTableInverse];
    Graphs(graphName) = digraph(fullGraphTable{:,1}, fullGraphTable{:,2}, fullGraphTable{:,3});
    
    assert(all(conncomp(Graph)==1), 'Graph is not connected. Make sure the input data is correct');
end

%% Find conversion

graphName = 'Distance';
unitFrom = 'dm';
unitTo   = 'in';
valueUnit1   = 2;

% Check if graph exist
assert(ismember(graphName,keys(Graphs)), 'Graph not found');
Graph = Graphs(graphName);

% Check if units exist
assert(all(ismember({unitFrom, unitTo}, Graph.Nodes{:,:})), 'Units not found');

% Shortest path (unweighted)
shortPath = shortestpath(Graph, unitFrom, unitTo, 'Method','unweighted');

shortPathEdges = [shortPath(1:end-1)', shortPath(2:end)'];
idxOut = findedge(Graph,shortPath(1:end-1)',shortPath(2:end)');

multiplier = prod(Graph.Edges.Weight(idxOut));

valueUnit2 = valueUnit1*multiplier