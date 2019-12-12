classdef LatexTable < handle
    % Usermade Matlabclass: LatexTable
    %
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % Author: Joachim Pomer
    % Creation Date: 10.11.2018
    % Last Update: 16.11.2018
    % by : Joachim Pomper
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   
    % Class that collects data and uncertainties to print it in a latex 
    % code table and save it as .tex file, wich can be importet in latex
    %
    
    % features die noch implementiert werden müssen
    % Tabelle Rundherum
    % Automatisches einstellen. 
    % Copiemodus in zwischen ablage.
    % etc.
    
    properties (SetAccess = public)
       
        data = [];
        delta = [];
        row_names = [];
        units = [];
        
    end
    
    properties (SetAccess = private, Hidden = true)
        
        % formation parameters
        fp_row_names = false;
        fp_row_units = false;
        fp_col_names = false; % not available by now
        fp_col_units = false;
        fp_header_units = false; % not available by now
        
        % Latex required usepackage parameters
        rup_siunitx = true % not available by now
        rup_inputence = true % not available by now
        
        % dimensions of table
        n_rows = 0;
        n_cols = 0;
        
        
    end
    
    methods (Access = public)
        
        function this = LatexTable(data, delta)
            
            %%% input parse
            e_msg = 'data and delta must be numerical array of same size';
            assert(all(size(data) == size(delta)) && ...
                   isa(data, 'numeric')  && ...
                   isa(delta, 'numeric'), e_msg);
            
            %%% LatexTable     
            this.data = data;
            this.delta = delta;
            
            this.n_rows = size(data,1);
            this.n_cols = size(data,2);
            
        end %Constructor
        
        function settings(this, varargin)
            
            %%% setup inputParser
            p = inputParser;
            % HeaderUnits
            e_msg = ['HeaderUnits is not valid. Valid input Arguments' ...
                     'are: ''true'', ''false'', ''1'', ''0''. '];
            validfnc = @(x) assert(all(size(x) == [1,1]) && ...
                                   (any(x==[1,0]) || isa(x, 'logical')),...
                                   e_msg);
            default = false;
            p.addParameter('HeaderUnits', default, validfnc)
            % descriptionUnits
            %
            
            %%% actaul parse
            p.parse(varargin{:})
            
            this.fp_header_units = p.Results.HeaderUnits;
            
        end %settings
        
        function addRowNames(this, row_names)
           
            %%% input parse
            e_msg = ['rownames must be a 1 x ', num2str(this.n_rows) ...
                    'cell array containing char arrays' ...
                    ' as elements '];
            assert(all(size(row_names) == [1, this.n_rows]) && ...
                    isa(row_names, 'cell') && ... 
                    all(cellfun(@(x) isa(x, 'char'), row_names)), e_msg);    
            
            %%% set rownames
            this.row_names = row_names;
            %%% set formation parameters 
            this.fp_row_names = true;
            
        end %addRownames
        
        function addRowUnits(this, row_units)
            
            %%% input parse
            e_msg = ['row_units must be a 1 x ', num2str(this.n_rows) ...
                    'cell array containing char arrays' ...
                    ' as elements. The char arrays must be valid latex '...
                    ' code'];
            assert(all(size(row_units) == [1, this.n_rows]) && ...
                    isa(row_units, 'cell') && ... 
                    all(cellfun(@(x) isa(x, 'char'), row_units)), e_msg);    
            
            %%% set units
            if this.fp_col_units                     
                warning(['Units for columns have already been assigned' ...
                         'and have been overwritten by now'])
            end
            
           this.units = row_units;
           this.fp_row_units = true;
           this.fp_col_units = false;

            
        end %addRowUnits
        
         function addColumnUnits(this, col_units) 
             
            %%% input parse
            e_msg = ['column_units must be a 1 x ', num2str(this.n_cols) ...
                    'cell array containing char arrays' ...
                    ' as elements. The char arrays must be valid latex '...
                    ' code'];
            assert(all(size(col_units) == [1, this.n_cols]) && ...
                    isa(col_units, 'cell') && ... 
                    all(cellfun(@(x) isa(x, 'char'), col_units)), e_msg);    
            
            %%% set units
            if this.fp_row_units                     
                warning(['Units for rows have already been assigned' ...
                         'and have been overwritten by now'])
            end
            
           this.units = col_units;
           this.fp_row_units = false;
           this.fp_col_units = true;
             
         end %addColUnits
         
        function printas(this, filename)
            
            FiD=fopen(filename,'w+','n', 'UTF-8');
            
            for idx_row = 1 : this.n_rows
                fprintf(FiD, '\n');
                this.printRow(FiD, idx_row)
            end
            
            fclose(FiD);
            
        end %printas
        
    end %publicMethods
    
    methods(Access = private)
        
        function printRow(this, FiD, idx_row)
            
            if this.fp_row_names
                fprintf(FiD, '%s', this.row_names{idx_row});
                if this.fp_row_units && this.fp_header_units
                    fprintf(FiD, '~/~\\si{%s}', this.units{idx_row});
                end
                fprintf(FiD, ' & ');
            end
                            
            for idx_col = 1:this.n_cols
                row_content = this.sigd(this.data(idx_row, idx_col), ...
                                        this.delta(idx_row, idx_col));
                fprintf(FiD, '%s', row_content{1});
                if this.fp_row_units && ~this.fp_header_units
                    fprintf(FiD, '~\\si{%s}', this.units{idx_row});
                end 
                if this.fp_col_units && ~this.fp_header_units
                    fprintf(FiD, '~\\si{%s}', this.units{idx_col});
                end 
                if idx_col ~= this.n_cols 
                    fprintf(FiD, ' %s ', '&');
                end
            end
            
            if idx_row ~= this.n_rows
                fprintf(FiD, ' %s', '\\');
            end
            
        end
        
        function rup_list = checkForRups(this)
            % not needed, rup_list should be stored internaly
            rup_list = [];
            if this.rup_siunitx
                rup_list = [rup_list ,'siunitx'];
            end
        end %checkForRups
        
    end %privateMethods
    
    methods(Access = private, Static)
        
        function [tex] = sigd (Ix,Idx)
        
        % THIS IS AN OLD VERSION
        % IT WORKS BUT SCHOULD BE REDONE
        %
        %This function is used to correctly format the data of an experiment consisting of
        %measurement Values and measurement uncertainty. It is thought to be used
        %together with the function 'tabtex.m' to create a .tex file wich can be
        %importet into latex. For this the default output of this functionis a
        %cell-array of stringarrys wich contain code that can be transcribed to
        %latex code with the function tabtex.
        %the two other optional outputs are the formated Values and Uncertainties.
        %Example:
        %Ix=[200,2;200.0,2.0;200.00,0.22];
        %Idx=[0.2,2;0.002,0.22;2,0.002];


        %Debugging und Defaultvalues
        if size(Ix)~=size(Idx); error('The two input-arrays must have the same size');end  
        Idx = abs(Idx);
        
        %Programm

        Size=size(Ix); z=Size(1); s=Size(2);
        tex=cell(Size);
        Nx=zeros(Size);
        Ndx=zeros(Size);

        for kz=1:z
            for ks=1:s

                B=num2str(str2double(num2str(Idx(kz,ks),1)));
                dx=strsplit(B,'.');
                
                   if  Idx(kz,ks) == 0

                           A = num2str(Ix(kz,ks));
                           A = strrep(A,'.',',');
                           tex{kz,ks}=['$ ', A, '$'];
                   else

                       switch dx{1}

                           case '0'

                           N=length(dx{2});
                           A=num2str(Ix(kz,ks),['%.',num2str(N),'f']);
                           A=strrep(A,'.',',');
                           B=strrep(B,'.',',');
                           tex{kz,ks}=['$ ',A,' \,\pm\, ',B,' $'];
                           
                           otherwise

                           A=strsplit(num2str(Ix(kz,ks)),'.');
                           N=length(A{1})-length(dx{1})+1;
                           A=str2double(num2str(Ix(kz,ks),['%.',num2str(N),'g']));
                           A=num2str(A);
                           A=strrep(A,'.',',');
                           B=strrep(B,'.',',');
                           tex{kz,ks}=['$ ',A,' \,\pm\, ',B,' $'];

                       end

                   end

            end
        end
        end
        
    end %privateMethods
end