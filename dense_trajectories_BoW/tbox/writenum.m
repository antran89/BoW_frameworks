function writenum(number)

%simple function to write a number (e.g. iteration count) on the screen

fprintf(' ')
fprintf(num2str(number));

%fflush produces an error in matlab but needed in octave:
try; fflush(stdout); catch; end
