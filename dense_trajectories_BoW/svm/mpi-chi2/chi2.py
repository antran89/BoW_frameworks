#!/usr/bin/python 

import platform
from numpy import ctypeslib,empty,array,exp
from ctypes import c_float,c_double,c_int

def chi2_dist(X,Y=None,K=None):
    if X.dtype==c_float:
       datatype=c_float
    else:
       datatype=c_double
    
    X = array(X,datatype).copy() # make array continguous
    if Y==None:
        Y=X
    else:
        Y = array(Y,datatype).copy()
    
    n,dim = X.shape
    m,dim = Y.shape
    if (K==None):
        K = empty( (n,m), datatype)
    elif (K.shape != (n,m)):
        K = empty( (n,m), datatype)

    try:
        chi2lib = ctypeslib.load_library("libchi2.so",".") # adapt path to library location
    except:
        print "Unable to load chi2-library"
        raise RuntimeError
        
    if X==Y:
        if datatype==c_float:
            chi2_routine = chi2lib.chi2_distance_float
        else:
            chi2_routine = chi2lib.chi2_distance_double
    
        chi2_routine.restype = datatype
        chi2_routine.argtypes = [c_int, \
            c_int, ctypeslib.ndpointer(dtype=datatype, ndim=2, flags='C_CONTIGUOUS'), \
            c_int, ctypeslib.ndpointer(dtype=datatype, ndim=2, flags='C_CONTIGUOUS'), \
        ctypeslib.ndpointer(dtype=datatype, ndim=2, flags='C_CONTIGUOUS') ]
        meanK = chi2_routine(dim, n, X, m, Y, K)
    else:
        if datatype==c_float:
            chi2_routine = chi2lib.chi2sym_distance_float
        else:
            chi2_routine = chi2lib.chi2sym_distance_double
    
        chi2_routine.restype = datatype
        chi2_routine.argtypes = [c_int, \
            c_int, ctypeslib.ndpointer(dtype=datatype, ndim=2, flags='C_CONTIGUOUS'), \
        ctypeslib.ndpointer(dtype=datatype, ndim=2, flags='C_CONTIGUOUS') ]
        meanK = chi2_routine(dim, n, X, K)
    
    return K,meanK


def chi2_kernel(X,Y=None,K=None,oldmeanK=None):
    K,meanK = chi2_dist(X,Y,K)
    if (oldmeanK == None):
        K = exp(-0.5*K/meanK)
    else:    
        K = exp(-0.5*K/oldmeanK)
    return K,meanK


if __name__ == "__main__":
    from numpy import mean,log
    from numpy.random import random_integers
    from time import time
    dim=3000
    X1 = array( random_integers(1, 10, 2000*dim), c_float)
    X1.shape = (-1,dim)
    X2 = array( random_integers(1, 10, 1000*dim), c_float)
    X2.shape = (-1,dim)
    
    before = time()
    K,meanK = chi2_kernel(X1)
    print "runtime %f s" % (time()-before)
    print "mean(log(K)) = %f (should be -0.5)" % mean(mean(log(K)))
    
    before = time()
    K,meanK = chi2_kernel(X1,X2)
    print "runtime %f s" % (time()-before)
    print "mean(log(K)) = %f (should be -0.5)" % mean(mean(log(K)))

    X1 = array( random_integers(1, 10, 2000*dim), c_double)
    X1.shape = (-1,dim)
    X2 = array( random_integers(1, 10, 1000*dim), c_double)
    X2.shape = (-1,dim)
    
    before = time()
    K,meanK = chi2_kernel(X1)
    print "runtime %f s" % (time()-before)

    before = time()
    K,meanK = chi2_kernel(X1,X2)
    print "runtime %f s" % (time()-before)

    print "mean(log(K)) = %f (should be -0.5)" % mean(mean(log(K)))
