function fParallel(fblck,nblck,whoiam,ThisMatlab,fname);

% Copyright (C) 2009 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

global funcName

funcName=fname;

warning off;
diary off;

delete( [fname,'_',int2str(whoiam),'.log']);

diary( [fname,'_',int2str(whoiam),'.log']);

    
% configure dynare environment
dynareroot = dynare_config();

load( [fname,'_input']) 
% keyboard;
if exist('fGlobalVar'),
  globalVars = fieldnames(fGlobalVar);
  for j=1:length(globalVars),
    eval(['global ',globalVars{j},';'])
  end
  struct2local(fGlobalVar);
end

% lounch the routine to be run in parallel
tic,
[fOutputVar, OutputFileName] = feval(fname, fInputVar ,fblck, nblck, whoiam, ThisMatlab);
toc,

%%% Sincronismo "Esterno" %%%%%%%%%%%%%
%%% Ogni Processo quando ha finito lo notifica cancellando un file ... 
% keyboard;
if(whoiam)
  save([ fname,'_output_',int2str(whoiam)],'fOutputVar' )
  
  
  if options_.parallel(ThisMatlab).Local
    delete(['P_',fname,'_',int2str(whoiam),'End.txt']);

  else
    if isunix,
%     for j=1:size(OutputFileName,1),
%       copyfile([OutputFileName{j,1},OutputFileName{j,2}],['\\',fInputVar.MasterName,'\',fInputVar.DyMo(1),'$\',fInputVar.DyMo(4:end),'\',OutputFileName{j,1}])
%     end
%     copyfile([fname,'_output_',int2str(whoiam),'.mat'],['\\',fInputVar.MasterName,'\',fInputVar.DyMo(1),'$\',fInputVar.DyMo(4:end)]);
%     delete(['\\',fInputVar.MasterName,'\',fInputVar.DyMo(1),'$\',fInputVar.DyMo(4:end),'\P_',fname,'_',int2str(whoiam),'End.txt']);
    else
      for j=1:size(OutputFileName,1),
        copyfile([OutputFileName{j,1},OutputFileName{j,2}],['\\',fInputVar.MasterName,'\',fInputVar.DyMo(1),'$\',fInputVar.DyMo(4:end),'\',OutputFileName{j,1}])
      end
      copyfile([fname,'_output_',int2str(whoiam),'.mat'],['\\',fInputVar.MasterName,'\',fInputVar.DyMo(1),'$\',fInputVar.DyMo(4:end)]);
      delete(['\\',fInputVar.MasterName,'\',fInputVar.DyMo(1),'$\',fInputVar.DyMo(4:end),'\P_',fname,'_',int2str(whoiam),'End.txt']);
    end
  end
end

disp(['fParallel ',int2str(whoiam),' completed.'])
diary off;

exit;
