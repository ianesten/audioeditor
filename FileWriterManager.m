classdef FileWriterManager < handle
%FileWriterManager Manage file writer add-ons in +filewriters directory

%   Copyright 2008 The MathWorks, Inc.
%   Author: Navan Ruthramoorthy

    methods
        function this = FileWriterManager
        end
        
        function fileName = writeFile(this, data, Fs)
            if isempty(this.FileWriters)
                % First time: Scan all file writers
                scanFileWriters(this);
            end
            numWriters = length(this.FileWriters);
            extensions = cell(numWriters, 1);
            for w = 1:numWriters
                extension = this.FileWriters(w).Ext;
                extensions{w, 1} = append('*', extension);
            end
            
            [filename, pathname] = uiputfile(extensions);
            if isempty(filename) || isequal(0, filename)
                fileName = [];
                return;
            end
            fileName = append(pathname, filename);
            [~ ,~ , extension] = fileparts(fileName);
            filterindex = 0;
            for w = 1:numWriters
                writerExtension = this.FileWriters(w).Ext;
                if(isequal(extension, writerExtension))
                    filterindex = w;
                    break;
                end
            end
            
            writer = eval(this.FileWriters(filterindex).evalString);
            writer.write(fileName, data, Fs);
        end
    end

    methods (Access=private)
        function scanFileWriters(this)
            fileWriterPackage = 'filewriters';
            thisFileDir = fileparts(mfilename('fullpath'));
            fileWriterFiles = what([thisFileDir '/+' fileWriterPackage]);
            if isempty(fileWriterFiles), return, end
            if isempty(this.FileWriters)
                    this.FileWriters = struct('evalString', {}, 'Ext', {});
            end
            for i=1:length(fileWriterFiles.m)
                try
                    evalStr = ([fileWriterPackage '.' fileWriterFiles.m{i}(1:end-2)]);
                    ext = eval([evalStr '.getExt']);
                    this.FileWriters(end+1) = struct('evalString', evalStr, ...
                                                                                     'Ext', ext);
                catch me
                    warning(me.identifier, me.message);
                end
            end
        end
    end
    
    properties
        FileWriters
    end
end