from cpython.mem cimport PyMem_Malloc, PyMem_Free
from contextlib import contextmanager
from os import dup, dup2, fdopen
from sys import stdout
from tempfile import TemporaryFile
from _api cimport *
from ._types import MetisError

__all__ = ['part_graph', 'node_nd', 'compute_vertex_separator']


@contextmanager
def redirect(source, target):
    """Temporarily redirect operations on file ``source`` to file ``target``.
    """
    source.flush()
    fd = source.fileno()
    with fdopen(dup(fd), source.mode) as source2:
        dup2(target.fileno(), fd)
        try:
            yield
        finally:
            source.flush()
            dup2(source2.fileno(), fd)


cdef void* checked_malloc(idx_t size) except NULL:
    cdef void* ptr = PyMem_Malloc(size)
    if ptr == NULL:
        raise MemoryError()
    return ptr


cdef idx_t* convert_idx_array(array) except NULL:
    """Convert a list of ints to a C array of idx_t's.
    """
    cdef idx_t size = len(array)
    cdef idx_t *_array = <idx_t*> checked_malloc(sizeof(idx_t) * size)
    cdef idx_t i
    try:
        for i from 0 <= i < size:
            _array[i] = array[i]
    except:
        PyMem_Free(_array)
        raise
    return _array


cdef real_t* convert_real_array(array) except NULL:
    """Convert a list of floats to a C array of real_t's.
    """
    cdef idx_t size = len(array)
    cdef real_t *_array = <real_t*> checked_malloc(sizeof(real_t) * size)
    cdef idx_t i
    try:
        for i from 0 <= i < size:
            _array[i] = array[i]
    except:
        PyMem_Free(_array)
        raise
    return _array


cdef convert_options(options, idx_t *_options):
    """Convert a MetisOptions object to a C array.
    """
    METIS_SetDefaultOptions(_options)
    if options is None:
        return

    _options[<idx_t> METIS_OPTION_PTYPE]     = options.ptype
    _options[<idx_t> METIS_OPTION_OBJTYPE]   = options.objtype
    _options[<idx_t> METIS_OPTION_CTYPE]     = options.ctype
    _options[<idx_t> METIS_OPTION_IPTYPE]    = options.iptype
    _options[<idx_t> METIS_OPTION_RTYPE]     = options.rtype
    _options[<idx_t> METIS_OPTION_NCUTS]     = options.ncuts
    _options[<idx_t> METIS_OPTION_NSEPS]     = options.nseps
    _options[<idx_t> METIS_OPTION_NUMBERING] = options.numbering
    _options[<idx_t> METIS_OPTION_NITER]     = options.niter
    _options[<idx_t> METIS_OPTION_SEED]      = options.seed
    _options[<idx_t> METIS_OPTION_MINCONN]   = options.minconn
    _options[<idx_t> METIS_OPTION_NO2HOP]    = options.no2hop
    _options[<idx_t> METIS_OPTION_CONTIG]    = options.contig
    _options[<idx_t> METIS_OPTION_COMPRESS]  = options.compress
    _options[<idx_t> METIS_OPTION_CCORDER]   = options.ccorder
    _options[<idx_t> METIS_OPTION_PFACTOR]   = options.pfactor
    _options[<idx_t> METIS_OPTION_UFACTOR]   = options.ufactor
    _options[<idx_t> METIS_OPTION_DBGLVL]    = options.dbglvl


cdef void convert_graph(xadj, adjncy, idx_t *nvtxs_ptr, idx_t **_xadj_ptr,
                        idx_t **_adjncy_ptr) except *:
    """Convert a list-based graph structure to C arrays.
    """
    cdef idx_t nvtxs
    cdef idx_t *_xadj = NULL
    cdef idx_t *_adjncy = NULL
    cdef idx_t i, j, k, l
    try:
        _xadj = convert_idx_array(xadj)
        nvtxs = len(xadj) - 1
        if nvtxs < 1:
            raise ValueError('len(xadj) < 2')
        if _xadj[0] != 0:
            raise ValueError('xadj[0] != 0')
        for i from 0 <= i < nvtxs:
            if _xadj[i] > _xadj[i + 1]:
                raise ValueError('xadj[{0}] > xadj[{1}]'.format(i, i + 1))

        _adjncy = convert_idx_array(adjncy)
        if len(adjncy) != _xadj[nvtxs]:
            raise ValueError('len(adjncy) != xadj[-1]')

    except:
        PyMem_Free(_xadj)
        PyMem_Free(_adjncy)
        raise
    with nogil:
        # Remove selfloops to prevent METIS crashes.
        k = 0
        for i from 0 <= i < nvtxs:
            l = k
            for j from _xadj[i] <= j < _xadj[i + 1]:
                if _adjncy[j] != i:
                    _adjncy[k] = _adjncy[j]
                    k += 1
            _xadj[i] = l
        _xadj[nvtxs] = k

        nvtxs_ptr[0] = nvtxs
        _xadj_ptr[0] = _xadj
        _adjncy_ptr[0] = _adjncy


cdef void check_result(int result, msg) except *:
    if result != METIS_OK:
        raise MetisError(msg)


def part_graph(xadj, adjncy, nparts, vwgt=None, vsize=None, adjwgt=None,
               tpwgts=None, ubvec=None, options=None, recursive=False):
    """Partition a graph into `k` parts using either multilevel recursive
    bisection or multilevel `k`-way partitioning.

    Parameters
    ----------
    xadj, adjncy : lists of ints
        Adjacency structure of the graph.

    nparts : int
        Number of parts to partition the graph. It should be at least 2.

    vwgt : list of ints
        Weights of the vertices. Default value: None.

    vsize : list of ints
        Sizes of the vertices for computing the total communication volume.
        Default value: None.

    adjwgt : list of ints
        Weights of the edges.

    tpwgts : list of floats
        List of size `\text{nparts} \times \text{ncon}` that specifies the
        desired weight for each partition and constraint. The target partition
        weight for the `i`th partition and `j`th constraint is specified at
        `\text{tpwgts}[i \ast \text{ncon} + j]` (the numbering for both
        partitions and constraints starts from 0). For each constraint, the sum
        of the `\text{tpwghts}[]` entries must be 1.0 (i.e.,
        `\sum_i \text{tpwgts}[i \ast \text{ncon} + j] = 1.0`).

        If None, the graph is equally divided among the partitions. Default
        value: None.

    ubvec : list of floats.
        List of size `\text{ncon}` that specifies the allowed load imbalance
        tolerance for each constraint. For the ith partition and jth constraint
        the allowed weight is the
        `\text{ubvec}[j] \ast \text{tpwgts}[i \ast \text{ncon} + j]` fraction
        of the `j`th constraint's total weight. The load imbalances must be
        greater than 1.0.

        If None, the load imbalance tolerance for each constraint is 1.001 (for
        `\text{ncon} = 1`) or 1.01 (for `\text{ncon} \ne 1`). Default value:
        None.

    options : MetisOptions
        Options. Default value: None

    Returns
    -------
    objval : int
        The edge-cut or the total communication volume of the partitioning
        solution. The value returned depends on the partitioning's objective
        function.

    part : list of ints
        The partition vector of the graph. The numbering of this vector starts
        from either 0 or 1, depending on the value of options.numbering.

    Raises
    ------
    MetisError
        If METIS returns an error status.

    Notes
    -----
    This wrapper function performs only minimal input validation to ensure
    memory safety in invocation of METIS.
    """
    cdef idx_t nvtxs
    cdef idx_t *_xadj = NULL
    cdef idx_t *_adjncy = NULL
    cdef idx_t _nparts
    cdef idx_t *_vwgt = NULL
    cdef idx_t *_vsize = NULL
    cdef idx_t *_adjwgt = NULL
    cdef real_t *_tpwgts = NULL
    cdef idx_t ncon
    cdef real_t *_ubvec = NULL
    cdef idx_t _options[METIS_NOPTIONS]
    cdef idx_t objval
    cdef idx_t *_part = NULL
    cdef int _recursive
    cdef int result
    cdef int i
    try:
        convert_graph(xadj, adjncy, &nvtxs, &_xadj, &_adjncy)
        _nparts = nparts
        if _nparts < 2:
            raise ValueError('nparts < 2')

        if vwgt is not None:
            _vwgt = convert_idx_array(vwgt)
            if len(vwgt) != nvtxs:
                raise ValueError('len(vwgt) != len(xadj) - 1')

        if vsize is not None:
            _vsize = convert_idx_array(vsize)
            if len(vsize) != nvtxs:
                raise ValueError('len(vsize) != len(xadj) - 1')

        if adjwgt is not None:
            _adjwgt = convert_idx_array(adjwgt)
            if len(adjwgt) != len(adjncy):
                raise ValueError('len(adjwgt) != len(adjncy)')

        if tpwgts is not None:
            _tpwgts = convert_real_array(tpwgts)
            if len(tpwgts) % _nparts != 0:
                raise ValueError('len(tpwgts) % nparts != 0')
            ncon = len(tpwgts) / _nparts
        else:
            ncon = 1

        if ubvec is not None:
            _ubvec = convert_real_array(ubvec)
            if len(ubvec) != ncon:
                raise ValueError('len(ubvec) != ncon')

        convert_options(options, _options)
        _part = <idx_t*> checked_malloc(sizeof(idx_t) * nvtxs)
        _recursive = bool(recursive)

        with TemporaryFile() as tmp:
            with redirect(stdout, tmp), nogil:
                if _recursive:
                    result = METIS_PartGraphRecursive(
                        &nvtxs, &ncon, _xadj, _adjncy, _vwgt, _vsize, _adjwgt,
                        &_nparts, _tpwgts, _ubvec, _options, &objval, _part)
                else:
                    result = METIS_PartGraphKway(
                        &nvtxs, &ncon, _xadj, _adjncy, _vwgt, _vsize, _adjwgt,
                        &_nparts, _tpwgts, _ubvec, _options, &objval, _part)
            tmp.seek(0)
            msg = unicode(tmp.read(), stdout.encoding)

        check_result(result, msg)

        part = [_part[i] for i from 0 <= i < nvtxs]
        return objval, part
    finally:
        PyMem_Free(_xadj)
        PyMem_Free(_adjncy)
        PyMem_Free(_vwgt)
        PyMem_Free(_vsize)
        PyMem_Free(_adjwgt)
        PyMem_Free(_tpwgts)
        PyMem_Free(_ubvec)
        PyMem_Free(_part)


def node_nd(xadj, adjncy, vwgt=None, options=None):
    """Computes fill reducing orderings of sparse matrices using the multilevel
    nested dissection algorithm.

    Parameters
    ----------

    xadj, adjncy : lists of ints
        Adjacency structure of the graph.

    vwgt : list of ints, optional
        Weights of the vertices. If the graph is weighted, the nested
        dissection ordering computes vertex separators that minimize the sum of
        the weights of the vertices on the separators. Default value: None.

    options : MetisOptions
        Options. Default value: None

    Returns
    -------
    perm, iperm : lists of ints
        Upon successful completion, they store the fill-reducing permutation
        and inverse permutation. Let A be the original matrix and `A'` be the
        permuted matrix. The arrays perm and iperm are defined as follows. Row
        (column) `i` of `A'` is the perm[`i`] row (column) of `A`, and row
        (column) `i` of `A` is the iperm[`i`] row (column) of `A'`. The
        numbering of this vector starts from either 0 or 1, depending on the
        value of options.numbering.

    Raises
    ------
    MetisError
        If METIS returns an error status.

    Notes
    -----
    This wrapper function performs only minimal input validation to ensure
    memory safety in invocation of METIS.
    """
    cdef idx_t nvtxs
    cdef idx_t *_xadj = NULL
    cdef idx_t *_adjncy = NULL
    cdef idx_t *_vwgt = NULL
    cdef idx_t _options[METIS_NOPTIONS]
    cdef idx_t *_perm = NULL
    cdef idx_t *_iperm = NULL
    cdef int result
    cdef idx_t i
    try:
        convert_graph(xadj, adjncy, &nvtxs, &_xadj, &_adjncy)

        if vwgt is not None:
            _vwgt = convert_idx_array(vwgt)
            if len(vwgt) != nvtxs:
                raise ValueError(
                    'length of vwgt is not equal to len(xadj) - 1')

        convert_options(options, _options)

        _perm = <idx_t*> checked_malloc(sizeof(idx_t) * nvtxs)
        _iperm = <idx_t*> checked_malloc(sizeof(idx_t) * nvtxs)

        with TemporaryFile() as tmp:
            with redirect(stdout, tmp), nogil:
                result = METIS_NodeND(&nvtxs, _xadj, _adjncy, _vwgt, _options,
                                      _perm, _iperm)
            tmp.seek(0)
            msg = unicode(tmp.read(), stdout.encoding)

        check_result(result, msg)

        perm = [_perm[i] for i from 0 <= i < nvtxs]
        iperm = [_iperm[i] for i from 0 <= i < nvtxs]
        return perm, iperm
    finally:
        PyMem_Free(_xadj)
        PyMem_Free(_adjncy)
        PyMem_Free(_vwgt)
        PyMem_Free(_perm)
        PyMem_Free(_iperm)


def set_default_options(options):
    """Assign default values to a MetisOptions object.

    Parameters
    ----------
    options : MetisOptions
        Options.
    """
    cdef idx_t _options[METIS_NOPTIONS]
    METIS_SetDefaultOptions(_options)
    options.ptype     = _options[<idx_t> METIS_OPTION_PTYPE]
    options.objtype   = _options[<idx_t> METIS_OPTION_OBJTYPE]
    options.ctype     = _options[<idx_t> METIS_OPTION_CTYPE]
    options.iptype    = _options[<idx_t> METIS_OPTION_IPTYPE]
    options.rtype     = _options[<idx_t> METIS_OPTION_RTYPE]
    options.ncuts     = _options[<idx_t> METIS_OPTION_NCUTS]
    options.nseps     = _options[<idx_t> METIS_OPTION_NSEPS]
    options.numbering = _options[<idx_t> METIS_OPTION_NUMBERING]
    options.niter     = _options[<idx_t> METIS_OPTION_NITER]
    options.seed      = _options[<idx_t> METIS_OPTION_SEED]
    options.minconn   = _options[<idx_t> METIS_OPTION_MINCONN]
    options.no2hop    = _options[<idx_t> METIS_OPTION_NO2HOP]
    options.contig    = _options[<idx_t> METIS_OPTION_CONTIG]
    options.compress  = _options[<idx_t> METIS_OPTION_COMPRESS]
    options.ccorder   = _options[<idx_t> METIS_OPTION_CCORDER]
    options.pfactor   = _options[<idx_t> METIS_OPTION_PFACTOR]
    options.ufactor   = _options[<idx_t> METIS_OPTION_UFACTOR]
    options.dbglvl    = _options[<idx_t> METIS_OPTION_DBGLVL]


def compute_vertex_separator(xadj, adjncy, vwgt=None, options=None):
    cdef idx_t nvtxs
    cdef idx_t *_xadj = NULL
    cdef idx_t *_adjncy = NULL
    cdef idx_t *_vwgt = NULL
    cdef idx_t _options[METIS_NOPTIONS]
    cdef idx_t sepsize
    cdef idx_t *_part = NULL
    cdef int result
    cdef int i
    try:
        convert_graph(xadj, adjncy, &nvtxs, &_xadj, &_adjncy)

        if vwgt is not None:
            _vwgt = convert_idx_array(vwgt)
            if len(vwgt) != nvtxs:
                raise ValueError('len(vwgt) != len(xadj) - 1')

        convert_options(options, _options)
        _part = <idx_t*> checked_malloc(sizeof(idx_t) * nvtxs)

        with TemporaryFile() as tmp:
            with redirect(stdout, tmp), nogil:
                result = METIS_ComputeVertexSeparator(
                    &nvtxs, _xadj, _adjncy, _vwgt, _options, &sepsize, _part)
            tmp.seek(0)
            msg = unicode(tmp.read(), stdout.encoding)

        check_result(result, msg)

        part = [_part[i] for i from 0 <= i < nvtxs]
        return sepsize, part
    finally:
        PyMem_Free(_xadj)
        PyMem_Free(_adjncy)
        PyMem_Free(_vwgt)
        PyMem_Free(_part)
