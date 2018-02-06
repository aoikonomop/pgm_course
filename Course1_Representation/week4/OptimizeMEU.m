% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeMEU( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  
  % We assume I has a single decision node.
  % You may assume that there is a unique optimal decision.
  D = I.DecisionFactors(1);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  % 
  % Some other information that might be useful for some implementations
  % (note that there are multiple ways to implement this):
  % 1.  It is probably easiest to think of two cases - D has parents and D 
  %     has no parents.
  % 2.  You may find the Matlab/Octave function setdiff useful.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  EUF = CalculateExpectedUtilityFactor( I );
  
  OptimalDecisionRule = struct('var', [], 'card', [], 'val', []);
  OptimalDecisionRule.var = EUF.var;
  OptimalDecisionRule.card = EUF.card;
  
  assignments = IndexToAssignment(1:prod(D.card), D.card);
  OptimalDecisionRule = SetValueOfAssignment(OptimalDecisionRule, assignments,...
      zeros(prod(D.card), 1));
  
  if size(assignments, 2) > 1
      unique_partial = unique(assignments(:, end - 1), 'rows');
      for i = 1:size(unique_partial, 1)
          idx2 = ismember(assignments(:, end - 1), unique_partial(i, :));
          temp_assignments = assignments(idx2, :);
          indexes = AssignmentToIndex(temp_assignments, EUF.card(i));
          [~, max_index] = max(EUF.val(indexes));
          OptimalDecisionRule = SetValueOfAssignment(OptimalDecisionRule, ...
              IndexToAssignment(temp_assignments(max_index, :), EUF.card(i)), 1);
      end
  else
      [~, max_index] = max(EUF.val);
      OptimalDecisionRule = SetValueOfAssignment(OptimalDecisionRule, ...
          IndexToAssignment(assignments(max_index, :), EUF.card(1)), 1);
  end
  
  MEU = sum(EUF.val .* OptimalDecisionRule.val);
     
end
