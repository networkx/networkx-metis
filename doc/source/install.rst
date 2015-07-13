**********
Installing
**********

Before installing NetworkX-METIS, you need to have
`setuptools <https://pypi.python.org/pypi/setuptools>`_ ,
`Cython <https://pypi.python.org/pypi/cython>`_ and
`NetworkX <https://pypi.python.org/pypi/networkx>`_ installed.

Quick install
=============

Get NetworkX-METIS from the Python Package Index at
http://pypi.python.org/pypi/networkx-metis

or install it with

::

   pip install networkx-metis

and an attempt will be made to find and install an appropriate version
that matches your operating system and Python version.

You can install the development version (at github.com) with manully checking out

::

  https://github.com/networkx/networkx-metis


Installing from source
======================

You can install from source by downloading a source archive file
(tar.gz or zip) or by checking out the source files from the
git source code repository.

NetworkX-METIS needs a compiler to build the C library of METIS. For Linux/Mac OS, gcc
should be installed and for Windows OS, `mingw32 <http://www.mingw.org/>`_ must be installed.

Source archive file
-------------------

  1. Download the source (tar.gz or zip file) from
     https://pypi.python.org/pypi/networkx-metis/
     or get the latest development version from
     https://github.com/networkx/networkx-metis/

  2. Unpack and change directory to the source directory
     (it should have the setup.py on top level).

  3. Run 
     ::

       python setup.py build
     to build, and
     ::

       python setup.py install
     to install.

  4. (Optional) Run :samp:`nosetests` to execute the tests if you have
     `nose <https://pypi.python.org/pypi/nose>`_ installed.


GitHub
------

  1. Clone the networkx-metis repostitory
    ::

       git clone https://github.com/networkx/networkx-metis.git

  (see https://github.com/networkx/networkx-metis/ for other options)

  2. Change directory to :samp:`networkx-metis`

  3. Run 
     ::

       python setup.py build
     to build, and
     ::

       python setup.py install
     to install.

  4. (Optional) Run :samp:`nosetests` to execute the tests if you have
     `nose <https://pypi.python.org/pypi/nose>`_ installed.


If you don't have permission to install software on your
system, you can install into another directory using
the :samp:`--user`, :samp:`--prefix`, or :samp:`--home` flags to setup.py.

For example

::

    python setup.py install --prefix=/home/username/python

or

::

    python setup.py install --home=~

or

::

    python setup.py install --user

If you didn't install in the standard Python site-packages directory
you will need to set your PYTHONPATH variable to the alternate location.
See http://docs.python.org/2/install/index.html#search-path for further details.


Requirements
============

Python
------

To use NetworkX-METIS you need Python 2.7, 3.2 or later.


NetworkX
--------

To use NetworkX-METIS you need NetworkX 2.0 or later installed.


Cython
------

For NetworkX-METIS to work, you need Cython installed.


The easiest way to get Python and most optional packages is to install
the Enthought Python distribution "`Canopy <https://www.enthought.com/products/canopy/>`_".

There are several other distributions that contain the key packages you need for scientific computing.  See http://scipy.org/install.html for a list.
