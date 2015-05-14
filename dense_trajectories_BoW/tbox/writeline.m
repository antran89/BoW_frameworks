function writeline(s)

     %simple function to write something on the screen, with newline 

fprintf('\n');
fprintf(s);

%fflush produces an error in matlab but needed in octave:
try; fflush(stdout); catch; end
