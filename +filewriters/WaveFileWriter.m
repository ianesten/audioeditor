classdef WaveFileWriter < handle
    
%   Copyright 2008 The MathWorks, Inc.
%   Author: Navan Ruthramoorthy

  methods
      function this = WaveFileWriter
      end
  end

  methods (Static)
      function ext = getExt()
          ext = '.wav';
      end

      function write(fileName, data, Fs)
          audiowrite(fileName, data, Fs);
      end
  end

end
