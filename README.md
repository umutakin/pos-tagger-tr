pos-tagger
==========

This is the Turkish POS tagger trained on the GTP Viterbi decoder.

Installation
------------

* Obtain and install GTP binaries and the GTP Turkish grammar rules. The GTP binaries must be accessible from the command line for a successful training.

* Install the IRSTLM toolkit which is used to build the n-gram tables in the POS tagger model. Make sure that the IRSTLM binaries are accessible from the command line. The POS tagger is currently tested with IRSTLM version 5.60.02.

* Clone the github repository:

<pre>git clone git@github.com:tekno/pos-tagger.git</pre>

Training
--------

* Run 'train.sh' script in the 'src' folder to create the POS tagging models. This script requires two parameters in order to run properly:

<pre>./train.sh 'model-name' 'gtp-fs-path'</pre>

* The *model-name* parameter is the name of the experiment in the referenced paper, e.g. *exp-02*, *exp-28*.
* The *gtp-fs-path* parameter is the path to the GTP file system folder.
