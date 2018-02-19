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
[i, j] = GetNextCliques(P, MESSAGES);
if i == 0
    disp('Tree already calibrated');
    return
end

if isMax == 1
    for k = 1:length(P.cliqueList)
        P.cliqueList(k).val = log(P.cliqueList(k).val);
    end
end

message_list = [i j];
switched = 0;
    
while i ~= 0
    idx = find(message_list(:, 2) == i);
    
    message = P.cliqueList(i);
    
    if isMax == 0
        message.val = message.val / sum(message.val);
    end

    for k = 1:length(idx)
        if message_list(idx(k), 1) == j && message_list(idx(k), 2) == i
            continue
        end
        if isMax == 0
            message = FactorProduct(message, MESSAGES(message_list(idx(k), 1),...
                message_list(idx(k), 2)));
        else
            message = FactorSum(message, MESSAGES(message_list(idx(k), 1),...
                message_list(idx(k), 2)));
        end
    end
    marg_variables = setdiff(P.cliqueList(i).var, P.cliqueList(j).var);
    
    if isMax == 0
        message = FactorMarginalization(message, marg_variables);
        message.val = message.val / sum(message.val);
    else
        message = FactorMaxMarginalization(message, marg_variables);
    end
    
    MESSAGES(i, j) = message;
    
    [i, j] = GetNextCliques(P, MESSAGES);
    
    message_list = [message_list ; i, j];
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
        message = MESSAGES(j, i);
        
        if isMax == 0
            temp = FactorProduct(temp, message);
        else
            temp = FactorSum(temp, message);
        end
    end
    P.cliqueList(i) = temp;
end

return
