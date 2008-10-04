function plot_priors(bayestopt_,M_,options_)
% function plot_priors
% plots prior density
%
% INPUTS
%    o bayestopt_  [structure]
%    o M_          [structure]
%    o options_    [structure]
%    
% OUTPUTS
%    None
%    
% SPECIAL REQUIREMENTS
%    None

% Copyright (C) 2004-2008 Dynare Team
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

TeX = options_.TeX;

figurename = 'Priors';
npar = length(bayestopt_.pmean);
[nbplt,nr,nc,lr,lc,nstar] = pltorg(npar);

if TeX
	fidTeX = fopen([M_.fname '_Priors.TeX'],'w');
	fprintf(fidTeX,'%% TeX eps-loader file generated by plot_priors.m (Dynare).\n');
	fprintf(fidTeX,['%% ' datestr(now,0) '\n']);
	fprintf(fidTeX,' \n');
end
if nbplt == 1
    h1 = figure('Name',figurename);
    if TeX
        TeXNAMES = [];
        NAMES    = []; 
    end    
    for i=1:npar
        [x,f,abscissa,dens,binf,bsup] = draw_prior_density(i);
        [nam,texnam] = get_the_name(i,TeX);
        if TeX
            TeXNAMES = strvcat(TeXNAMES,texnam);
            NAMES = strvcat(NAMES,nam);
        end    
        subplot(nr,nc,i)
        hh = plot(x,f,'-k','linewidth',2);
        set(hh,'color',[0.7 0.7 0.7]);
        box on
        title(nam,'Interpreter','none')
        drawnow
    end
    eval(['print -depsc2 ' M_.fname '_Priors' int2str(1) '.eps']);
    if ~exist('OCTAVE_VERSION')
      eval(['print -dpdf ' M_.fname '_Priors' int2str(1)]);
      saveas(h1,[M_.fname '_Priors' int2str(1) '.fig']);
    end
    if options_.nograph, close(h1), end
    if TeX
    	fprintf(fidTeX,'\\begin{figure}[H]\n');
        for jj = 1:npar
        	fprintf(fidTeX,'\\psfrag{%s}[1][][0.5][0]{%s}\n',deblank(NAMES(jj,:)),deblank(TeXNAMES(jj,:)));
        end    
        fprintf(fidTeX,'\\centering\n');
        fprintf(fidTeX,'\\includegraphics[scale=0.5]{%s_Priors%s}\n',M_.fname,int2str(1));
        fprintf(fidTeX,'\\caption{Priors.}');
        fprintf(fidTeX,'\\label{Fig:Priors:%s}\n',int2str(1));
        fprintf(fidTeX,'\\end{figure}\n');
        fprintf(fidTeX,' \n');
        fprintf(fidTeX,'%% End of TeX file.\n');
        fclose(fidTeX);
	end
else
    for plt = 1:nbplt-1
        hplt = figure('Name',figurename);
        if TeX
            TeXNAMES = [];
            NAMES    = []; 
        end    
        for index=1:nstar
            names = [];
            i = (plt-1)*nstar + index;
            [nam,texnam] = get_the_name(i,TeX);
            [x,f,abscissa,dens,binf,bsup] = draw_prior_density(i);            
            if TeX
                TeXNAMES = strvcat(TeXNAMES,texnam);
                NAMES = strvcat(NAMES,nam);
            end    
            subplot(nr,nc,index)
            hh = plot(x,f,'-k','linewidth',2);
            set(hh,'color',[0.7 0.7 0.7]);
            box on
            title(nam,'Interpreter','none')
            drawnow
        end  % index=1:nstar
        eval(['print -depsc2 ' M_.fname '_Priors' int2str(plt) '.eps']);
        if ~exist('OCTAVE_VERSION')
          eval(['print -dpdf ' M_.fname '_Priors' int2str(plt)]);
          saveas(hplt,[M_.fname '_Priors' int2str(plt) '.fig']);
        end
    	if options_.nograph, close(hplt), end
		if TeX
            fprintf(fidTeX,'\\begin{figure}[H]\n');
            for jj = 1:nstar
                fprintf(fidTeX,'\\psfrag{%s}[1][][0.5][0]{%s}\n',deblank(NAMES(jj,:)),deblank(TeXNAMES(jj,:)));
            end    
            fprintf(fidTeX,'\\centering\n');
            fprintf(fidTeX,'\\includegraphics[scale=0.5]{%s_Priors%s}\n',M_.fname,int2str(plt));
            fprintf(fidTeX,'\\caption{Priors.}');
            fprintf(fidTeX,'\\label{Fig:Priors:%s}\n',int2str(plt));
            fprintf(fidTeX,'\\end{figure}\n');
            fprintf(fidTeX,' \n');
        end    
    end % plt = 1:nbplt-1
    hplt = figure('Name',figurename);
    if TeX
        TeXNAMES = [];
        NAMES    = []; 
    end    
    for index=1:npar-(nbplt-1)*nstar
        i = (nbplt-1)*nstar +  index;
        [x,f,abscissa,dens,binf,bsup] = draw_prior_density(i);
        [nam,texnam] = get_the_name(i,TeX);
        if TeX
            TeXNAMES = strvcat(TeXNAMES,texnam);
            NAMES = strvcat(NAMES,nam);
        end    
        if lr
            subplot(lc,lr,index);
        else
            subplot(nr,nc,index);
        end    
        hh = plot(x,f,'-k','linewidth',2);
        set(hh,'color',[0.7 0.7 0.7]);
        box on
        title(nam,'Interpreter','none')
        drawnow
    end  % index=1:npar-(nbplt-1)*nstar
    eval(['print -depsc2 ' M_.fname '_Priors' int2str(nbplt) '.eps']);
    if ~exist('OCTAVE_VERSION')
      eval(['print -dpdf ' M_.fname '_Priors' int2str(nbplt)]);
      saveas(hplt,[M_.fname '_Priors' int2str(nbplt) '.fig']);
    end
    if options_.nograph, close(hplt), end
	if TeX
        fprintf(fidTeX,'\\begin{figure}[H]\n');
        for jj = 1:npar-(nbplt-1)*nstar
            fprintf(fidTeX,'\\psfrag{%s}[1][][0.5][0]{%s}\n',deblank(NAMES(jj,:)),deblank(TeXNAMES(jj,:)));
        end    
        fprintf(fidTeX,'\\centering\n');
        fprintf(fidTeX,'\\includegraphics[scale=0.5]{%s_Priors%s}\n',M_.fname,int2str(nbplt));
        fprintf(fidTeX,'\\caption{Priors.}');
        fprintf(fidTeX,'\\label{Fig:Priors:%s}\n',int2str(nbplt));
        fprintf(fidTeX,'\\end{figure}\n');
        fprintf(fidTeX,' \n');
        fprintf(fidTeX,'%% End of TeX file.\n');
        fclose(fidTeX);
    end
end

% SA 01-11-2005 v3TOv4
