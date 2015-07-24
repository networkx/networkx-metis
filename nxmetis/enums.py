import enum

__all__ = ['MetisPType', 'MetisObjType', 'MetisCType', 'MetisIPType',
           'MetisRType', 'MetisNumbering', 'MetisDbgLvl', 'MetisRStatus']


@enum.unique
class MetisPType(enum.IntEnum):
    """Partitioning method.

        ==== =================================
        rb   Multilevel recursive bisectioning
        kway Multilevel `k`-way partitioning
        ==== =================================
    """

    default, rb, kway = range(-1, 2)


@enum.unique
class MetisObjType(enum.IntEnum):
    """Type of objective.

        === =======================================
        cut Edge-cut minimization
        vol Total communication volume minimization
        === =======================================
    """

    default, cut, vol = range(-1, 2)


@enum.unique
class MetisCType(enum.IntEnum):
    """Catching scheme to be used during coarsening.

        ==== ==========================
        rm   Random matching
        shem Sorted heavy-edge matching
        ==== ==========================
    """

    default, rm, shem = range(-1, 2)


@enum.unique
class MetisIPType(enum.IntEnum):
    """Algorithm used during initial partitioning.

        ====== ======================================================
        grow   Grow a bisection using a greedy strategy
        random Compute a bisection at random followed by a refinement
        edge   Derive a separator from an edge cut
        node   Grow a bisection using a greedy node-based strategy
        ====== ======================================================
    """

    default, grow, random, edge, node = range(-1, 4)


@enum.unique
class MetisRType(enum.IntEnum):
    """Algorithm used for refinement.

        ========= ======================================
        fm        FM-based cut refinement
        greedy    Greedy-based cut and volume refinement
        sep2sided Two-sided node FM refinement
        sep1sided One-sided node FM refinement
        ========= ======================================
    """

    default, fm, greedy, sep2sided, sep1sided = range(-1, 4)


@enum.unique
class MetisNumbering(enum.IntEnum):
    """Numbering scheme is used for the adjacency structure of a graph or the
    element-node structure of a mesh.

        ==== =================================
        zero C-style zero-based numbering
        one  Fortran-style one-based numbering
        ==== =================================
    """

    default, zero, one = range(-1, 2)


@enum.unique
class MetisDbgLvl(enum.IntEnum):
    """Amount of progress/debugging information will be printed during the
    execution of the algorithms. Can be combined by bit-wise OR.

        ========== ======================================================
        info       Print various diagnostic messages
        time       Perform timing analysis
        coarsen    Display various statistics during coarsening
        refine     Display various statistics during refinement
        ipart      Display various statistics during initial partitioning
        moveinfo   Display detailed information about vertex moves during
                   refinement
        sepinfo    Display information about vertex separators
        conninfo   Display information related to the minimization of
                   subdomain connectivity
        contiginfo Display information related to the elimination of
                   connected components
        ========== ======================================================
    """

    default = -1
    (info, time, coarsen, refine, ipart, moveinfo, sepinfo, conninfo,
     contiginfo, memory) = [1 << x for x in list(range(9)) + [11]]


@enum.unique
class MetisRStatus(enum.IntEnum):
    """Return codes by METIS

        ============ ===============================================
        ok           Returned normally
        error_input  Returned due to erroneous inputs and/or options
        error_memory Returned due to insufficient memory
        error        Some other errors
        ============ ===============================================
    """
    ok, error_input, error_memory, error = 1, -2, -3, -4
