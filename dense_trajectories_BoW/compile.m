% compile all the matlab code
path = pwd;

cd svm/chi/pwmetric/
slmetric_pw_compile();
cd(path)

cd svm/libsvm-matlab
system('make')
cd(path)

cd svm/mpi-chi2
system('make')
cd(path)

cd yael/matlab
Make
cd(path)