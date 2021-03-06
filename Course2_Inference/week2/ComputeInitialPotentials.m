%COMPUTEINITIALPOTENTIALS Sets up the cliques in the clique tree that is
%passed in as a parameter.
%
%   P = COMPUTEINITIALPOTENTIALS(C) Takes the clique tree skeleton C which is a
%   struct with three fields:
%   - nodes: cell array representing the cliques in the tree.
%   - edges: represents the adjacency matrix of the tree.
%   - factorList: represents the list of factors that were used to build
%   the tree. 
%   
%   It returns the standard form of a clique tree P that we will use through 
%   the rest of the assigment. P is struct with two fields:
%   - cliqueList: represents an array of cliques with appropriate factors 
%   from factorList assigned to each clique. Where the .val of each clique
%   is initialized to the initial potential of that clique.
%   - edges: represents the adjacency matrix of the tree. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function P = ComputeInitialPotentials(C)

% number of cliques
N = length(C.nodes);

% initialize cluster potentials 
P.cliqueList = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
P.edges = zeros(N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% First, compute an assignment of factors from factorList to cliques. 
% Then use that assignment to initialize the cliques in cliqueList to 
% their initial potentials. 

% C.nodes is a list of cliques.
% So in your code, you should start with: P.cliqueList(i).var = C.nodes{i};
% Print out C to get a better understanding of its structure.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P.edges = C.edges;
F = C.factorList;

% Make a cardinality map for all variables
for i = 1:length(F)
    for j = 1:length(F(i).var)
        card_map(F(i).var(j)) = F(i).card(j);
    end
end

%Populate P
for i = 1:N
    P.cliqueList(i).var = C.nodes{i};
    P.cliqueList(i).card = card_map(C.nodes{i});
    P.cliqueList(i).val = ones(1, prod(P.cliqueList(i).card));
end

% Assign factors to cliques
clique_map = zeros(1, length(F));
for i = 1:length(F)
    for j = 1:length(C.nodes)
        if length(F(i).var) == length(C.nodes{j})
            if isempty(setdiff(F(i).var, C.nodes{j}))
                clique_map(i) = j;
                break
            end
        end
    end
end

for i = 1:length(clique_map)
    if clique_map(i) == 0
        for j = 1:length(C.nodes)
            if isempty(setdiff(F(i).var, C.nodes{j}))
                clique_map(i) = j;
                break;
            end
        end
    end
end

% Compute potentials
for i = 1:N
    idx = find(clique_map == i);
    if ~isempty(idx)
        for j = 1:length(idx)
            P.cliqueList(i) = FactorProduct(P.cliqueList(i), F(idx(j)));
        end
    end
end

end

