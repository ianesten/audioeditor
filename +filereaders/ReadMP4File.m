classdef ReadMP4File < handle
%ReadMP4File Read audio data from an MP4 file

%   Author: Ian Esten
    methods
        function this = ReadMP4File(varargin)
            this.tempFilename = [tempname(), '.wav'];
        end

        function delete(this)
            %clean up temp file
            if exist(this.tempFilename, 'file') == 2
                delete(this.tempFilename);
            end
        end

        function ext = getFileExtensions(this)
            ext = {'mp4'};
        end

        function desc = getExtDescription(this) 
            desc = 'MP4 Files (*.mp4)';
        end

        function setFilename(this, filename)
            if(which('ffmpegextract'))
                ffmpegextract(filename, this.tempFilename, 'audio');
            end
            this.Filename = filename;
        end

        function data = getData(this)
            try
                data = audioread(this.audioFilename());
            catch ME
                rethrow(ME);
            end
        end

        function Fs = getSampleRate(this)
            [~, Fs] = audioread(this.audioFilename());
        end
        
        function filename = audioFilename(this)
            if exist(this.tempFilename, 'file') == 2
                filename = this.tempFilename;
            else
                filename = this.Filename;
            end
        end
    end

    properties
        Filename
        tempFilename
    end

end
