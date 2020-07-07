classdef MatFileWriter < handle
    
%   Author: Ian Esten

  methods
      function this = MatFileWriter
      end
  end

  methods (Static)
      function ext = getExt()
          ext = '.mat';
      end

      function write(fileName, data, Fs)
          save(fileName, 'data', 'Fs');
      end
  end

end
