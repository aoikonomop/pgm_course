%CLIQUETREECALIBRATE Performs sum-product or max-product algorithm for 
%clique tree calibration.

%   P = CLIQUETREECALIBRATE(P, isMax) calibrates a given clique tree, P 
%   according to the value of isMax flag. If isMax is 1, it uses max-sum
%   message passing, otherwise uses sum-product. This function 
%   returns the clique tree where the .val for each clique in .cliqueList
%   is set to the final calibrated potentials.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CliqueTreeCalibrate(P, isMax)


% Number of cliques in the tree.
N = length(P.cliqueList);

% Setting up the messages that will be passed.
% MESSAGES(i,j) represents the message going from clique i to clique j. 
MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We have split the coding part for this function in two chunks with
% specific comments. This will make implementation much easier.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
% While there are ready cliques to pass messages between, keep passing
% messages. Use GetNextCliques to find cliques to pass messages between.
% Once you have clique i that is ready to send message to clique
% j, compute the message and put it in MESSAGES(i,j).
% Remember that you only need an upward pass and a downward pass.
%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i = 1;
init_message = struct('var', [], 'card', [], 'val', []);
old_i = 0;
temp = [];
while i ~= 0
    [i, j] = GetNextCliques(P, MESSAGES);
    if i ~= 0
        if i ~= old_i
            old_message = init_message;
        end
        message = FactorProduct(old_message, P.cliqueList(i));
        message.val = message.val / sum(message.val);
        MESSAGES(i, j) = message;
        old_message = message;
        old_i = i;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Now the clique tree has been calibrated. 
% Compute the final potentials for the cliques and place them in P.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(P.cliqueList)
    temp = P.cliqueList(i);
    for j = 1:size(P.edges, 1)
        temp = FactorProduct(temp, MESSAGES(i, j));
    end
    P.cliqueList(i) = temp;
end


return
