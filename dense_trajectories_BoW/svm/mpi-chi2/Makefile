# this example is also to learn makefile
# learn how to program with OPENMP in C
# problem of using mpi-chi2 is that its accuracy is doubtable, lower than using slmetric_pw
# by Dahua Lin

CC = gcc
CFLAGS = -O3 -march=nocona -ffast-math -fomit-frame-pointer
OMPFLAGS = -fopenmp

MEX = mex

#CC=icc
#CFLAGS = -xP -fast
#OMPFLAGS = -openmp

MATLABDIR=/usr/local/MATLAB/R2012a
INCLUDES=-I$(MATLABDIR)/extern/include
LDIRS=-L$(MATLABDIR)/bin/glnxa64

EXE_TARGETS = chi2float chi2double chi2_mex.mexa64
LIB_TARGETS = libchi2.so
all:	$(LIB_TARGETS) $(EXE_TARGETS)

chi2float:	chi2float.c chi2float.h Makefile
	$(CC) -D__MAIN__  $(CFLAGS) $(OMPFLAGS) -o chi2float chi2float.c

chi2double: chi2double.c chi2double.h Makefile
	$(CC) -D__MAIN__  $(CFLAGS)  $(OMPFLAGS) -o chi2double chi2double.c

libchi2.so:	chi2double.c chi2double.h chi2float.c chi2float.h Makefile
	$(CC) $(CFLAGS) $(OMPFLAGS) -shared -Wl,-soname=libchi2.so -fPIC chi2double.c chi2float.c -o libchi2.so

chi2double.o : chi2double.c chi2double.h Makefile
	$(CC) -D__MAIN__  $(CFLAGS) -c $(OMPFLAGS) -o chi2double.o chi2double.c

chi2_mex.o: chi2_mex.c chi2double.h
	$(CC) $(CFLAGS) -c $(INCLUDES) -o chi2_mex.o chi2_mex.c

# linking of chi2_mex.mexa64 using GCC is lacking of other libs
#chi2_mex.mexa64: 	chi2_mex.c chi2_mex.o chi2double.o
#	$(CC) chi2_mex.o $(LDIRS) -lmex -o chi2_mex.mexa64 chi2double.o
#$(CC) $(LDIRS) -lmex -shared -o chi2_mex.mexa64 chi2double.o chi2_mex.o

chi2_mex.mexa64: 	chi2_mex.c
	$(MEX) chi2_mex.c -o chi2_mex.mexa64 -L. -lchi2

# default installation of libomp cannot be opened using dlopen() as would be required e.g. for Python


clean:
	rm -f *.o $(EXE_TARGETS) $(LIB_TARGETS)

timing:	$(EXE_TARGETS)
	time ./chi2float
	time ./chi2double

