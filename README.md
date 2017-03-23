The BoW (BoF) frameworks
========================

This is a Bag-of-Words (BoW) or Bag-of-Features (BoF) implementation for action recognition problem in Matlab.

It might have many trivial errors if you do not supply the path of dataset and input features correctly. Be patient.

HOW-TO INSTALL
--------------

This implementation using some functions from **OpenCV**, **[LIBSVM](https://www.csie.ntu.edu.tw/~cjlin/libsvm/)** (v3.20), **[Yael](https://gforge.inria.fr/projects/yael/)** (v4.38) and **[VLFeat](http://www.vlfeat.org/)** (v0.9.19) libraries.

Just compile some mex files with provided scripts in Matlab (run `compile.m` in `dense_trajectories_BoW`). There is no need to install anything else.

**Notice**: Due to some problems, we cannot deal with binary files (e.g. mex files) in git. So, some mex files from are missing from VLFeat and Yael. 
Please try to download these newest libraries and make two symbolic links to the two libraries (i.e, `dense_trajectories_BoW/vlfeat` and `dense_trajectories_BoW/vlfeat`). 

HOW-TO USE
----------

Provide path for data set in: `params.afspath`.

Provide path for features: `params.featurepath`.

Change `k-means` implementation method in: `params.km_method`. Change it to `matlab` if you have problems with installing `Yael` and `VLFeat`.

And some other parameters in `params`.

Voila, you run the `BoW_main.m` file for each dataset.

TESTED ON
---------

Matlab2012a, Linux x64.

The main code is written in Matlab which is a cross-platform language. In principle, the software can run on Windows or Mac OS X with little efforts on compiling dependencies such as LIBSVM, Yael, VLFeat and [encoding toolbox](https://github.com/antran89/BoW_frameworks/tree/master/dense_trajectories_BoW/ACCV2012_Encodeing).

If you run it successfully on Windows or Mac OS X, please give me a feedback.

EXTENSIONS
-------------

You can extend to the other action datasets by looking at the code at `BoW_API/HMDB_stdAPI/`.

Developers
----------

* [An Tran](http://antran89.github.io/)

License and Citation
---------------------

The code is available under GPL 3 license.

If you find **BoW toolbox** useful in your research, please consider citing:
```
@inproceedings{YeLuo_ICCV_2015,
  author    = {Ye Luo and
               Loong-Fah Cheong and
               An Tran},
  title     = {Actionness-assisted Recognition of Actions},
  booktitle = {The IEEE International Conference on Computer Vision (ICCV)},
  year      = {2015},
}
```

Enquiries, Question and Comments
--------------------------------

If you have any further enquiries, questions, or comments, please send an email
to [An Tran](tranlaman@gmail.com). If you would like to file a bug report or a feature request, please use the  [Github issue tracker](https://github.com/howtobeahacker/BoW_frameworks/issues).
