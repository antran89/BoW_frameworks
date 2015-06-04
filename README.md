The BoW (BoF) frameworks
========================

This is a Bag-of-Words (BoW) or Bag-of-Features (BoF) implementation for action recognition problem in Matlab.

It might have many trivial errors if you do not supply the path of dataset and input features correctly. Be patient.

HOW-TO INSTALL
--------------

This implementation using some functions from LIBSVM (v3.20), Yael (v4.38) and VLFeat (v0.9.19) libraries.

Just compile some mex files with provided scripts. There is no need to install anything else.

HOW-TO USE
----------

Provide path for data set in: params.afspath

Provide path for features: params.featurepath

And some other parameters in params.

Voila, you run the BoW_main.m file for each dataset.

TESTED ON
---------

Matlab2012a, Linux x64.

If you run it successfully on Windows or Mac OS X, please give me a feedback.

EXTENSIONS
-------------

You can extend to the other action datasets by looking at the code at BoW_API/HMDB_stdAPI/.

Developers
----------

* An Tran

License
-------

The code is available under GPL 3 license.

Enquiries, Question and Comments
--------------------------------

If you have any further enquiries, question, or comments, please send an email
to [tranlaman@gmail.com](). If you would like to file a bug report or a feature request, use the  [Github issue tracker](https://github.com/howtobeahacker/BoW_frameworks/issues).
