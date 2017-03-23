% compile all the matlab code
path = pwd;

cd tbox
mex mex_VideoReader.cpp -lopencv_ml -lopencv_highgui -lopencv_core
cd(path)

cd svm/chi/pwmetric/
slmetric_pw_compile();
cd(path)

cd svm/libsvm-matlab
system('make')
cd(path)

cd svm/mpi-chi2
system('make')
cd(path)

% uncomment this section if you need to install yael
% cd yael/matlab
% Make
% cd(path)