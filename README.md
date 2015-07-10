# NetworkX-METIS

[![Build Status](https://travis-ci.org/networkx/networkx-metis.svg?branch=master)](https://travis-ci.org/networkx/networkx-metis)
[![Code Health](https://landscape.io/github/networkx/networkx-metis/master/landscape.svg?style=flat)](https://landscape.io/github/networkx/networkx-metis/master)
[![Documentation Status](https://readthedocs.org/projects/networkx-metis/badge/?version=latest)](https://networkx-metis.readthedocs.org/en/latest/)

 * [About](#what-is-networkx-metis)
 * [Installation](#installation)
 * [Documentation](#documentation)
 * [Contribute](#contribute-to-networkx-metis)

What is NetworkX-METIS?
-
NetworkX-METIS is a NetworkX Addon to allow graph partitioning with METIS.

[NetworkX](https://github.com/networkx/networkx) is a Python package for the creation,
manipulation and study of the structure, dynamics, and functions of complex networkx.
[METIS](http://glaros.dtc.umn.edu/gkhome/metis/metis/overview) is a C library written for
partitioning graphs, partitioning finite element meshes, and producing
fill reducing orderings for sparse matrices. NetworkX-METIS uses Cython to wrap the
METIS library to make it available in Python.

Documentation is available at 
[http://networkx-metis.readthedocs.org/en/latest](http://networkx-metis.readthedocs.org/en/latest)

Installation
-
## Linux/Mac

######Requirements

```sh
pip install Cython
```

###From PyPI

```sh
pip install networkx-metis
```

###From GitHub

```sh
git clone https://github.com/networkx/networkx-metis.git
cd networkx-metis
python setup.py install
```

## Windows

Installation on Windows is largely the same as on Linux/Mac except that unlike in Unix-based
Operating system, no "platform compiler" are pre-installed on Windows. So, an extra
`--compiler=msvc` flag is required for installation. The simple guide for installing and setting
up the compiler is given [here](https://github.com/cython/cython/wiki/CythonExtensionsOnWindows).

Here is an example,

```sh
git clone https://github.com/networkx/networkx-metis.git
cd networkx-metis
python setup.py build --compiler=msvc
python setup.py install
```

provided that Cython and NetworkX have been installed as described in above sections.

Example
-
```python
>>> import networkx as nx

>>> from networkx.addons import metis

>>> G = nx.complete_graph(10)

>>> metis.partition(G, 2)
(25, [[0, 1, 2, 3, 6], [4, 5, 7, 8, 9]])
```

Contribute to NetworkX-METIS
-

For a detailed summary of all the coding guidelines and development workflow, please visit
the [Developer Guide](https://networkx.readthedocs.org/en/latest/developer/index.html).

 - [Report Bugs and Issues](https://github.com/networkx/networkx-metis/issues)
 - [Solve Bugs and Issues](https://github.com/networkx/networkx-metis/issues?page=1&state=open)
 - Write Tutorials, Examples and Documentation
