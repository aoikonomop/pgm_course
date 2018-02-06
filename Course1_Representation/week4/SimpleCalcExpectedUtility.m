% Copyright (C) Daphne Koller, Stanford University, 2012

function EU = SimpleCalcExpectedUtility(I)

  % Inputs: An influence diagram, I (as described in the writeup).
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return Value: the expected utility of I
  % Given a fully instantiated influence diagram with a single utility node and decision node,
  % calculate and return the expected utility.  Note - assumes that the decision rule for the 
  % decision node is fully assigned.

  % In this function, we assume there is only one utility node.
  F = [I.RandomFactors I.DecisionFactors];
  U = I.UtilityFactors(1);
  EU = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  all_variables = [];
  for i = 1:length(F) - 1
      all_variables = [all_variables F(i).var];
  end
  all_variables = unique([all_variables U.var]);
  
  elim_vars = setdiff(all_variables, I.DecisionFactors.var);
  Fnew = VariableElimination([I.RandomFactors, U], elim_vars);
  
  EUF = struct('var', [], 'card', [], 'val', []);
  for i = 1:length(Fnew)
      EUF = FactorProduct(EUF, Fnew(i));
  end
  
  % Bring variables in the correct order
  temp = FactorProduct(EUF, I.DecisionFactors);
  
  EU = sum(temp.val);
  
end
