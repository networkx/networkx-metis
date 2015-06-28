import itertools
import nose.tools

from networkx.addons.metis import exceptions
from networkx.addons.metis import _metis
from networkx.addons.metis import types


def make_cycle(n):
    xadj = list(range(0, 2 * n + 1, 2))
    adjncy = list(
        itertools.chain.from_iterable(
            zip(itertools.chain([n - 1], range(n - 1)),
                itertools.chain(range(1, n), [0]))))
    return xadj, adjncy


class TestMetis(object):

    def test_node_nd(self):
        n = 16
        xadj, adjncy = make_cycle(n)
        perm, iperm = _metis.node_nd(xadj, adjncy)
        nose.tools.assert_equal(set(perm), set(range(n)))
        nose.tools.assert_equal(abs(perm[-1] - perm[-2]), n // 2)
        nose.tools.ok_(set(range(min(perm[-2:]) + 1, max(perm[-2:]))) in
                       (set(perm[0:n // 2 - 1]), set(perm[n // 2 - 1:-2])))
        nose.tools.ok_(all(i == perm[iperm[i]] for i in range(n)))

    def test_selfloops(self):
        n = 16
        xadj = list(range(0, 3 * n + 1, 3))
        adjncy = list(
            itertools.chain.from_iterable(
                zip(itertools.chain([n - 1], range(n - 1)),
                    range(n),
                    itertools.chain(range(1, n), [0]))))
        perm, iperm = _metis.node_nd(xadj, adjncy)
        nose.tools.assert_equal(set(perm), set(range(n)))
        nose.tools.assert_equal(abs(perm[-1] - perm[-2]), n // 2)
        nose.tools.ok_(set(range(min(perm[-2:]) + 1, max(perm[-2:]))) in
                       (set(perm[0:n // 2 - 1]), set(perm[n // 2 - 1:-2])))
        nose.tools.ok_(all(i == perm[iperm[i]] for i in range(n)))

    def test_part_graph(self):
        n = 16
        xadj, adjncy = make_cycle(n)
        for recursive in (False, True):
            objval, part = _metis.part_graph(
                xadj, adjncy, 2, recursive=recursive)
            nose.tools.assert_equal(objval, 2)
            nose.tools.assert_equal(set(part), set(range(2)))
            it = itertools.dropwhile(lambda x: x == 0, itertools.cycle(part))
            nose.tools.assert_equal(
                list(itertools.takewhile(lambda x: x == 1, it)), [1] * (n // 2))

    def test_compute_vertex_separator(self):
        n = 16
        xadj, adjncy = make_cycle(n)
        sepsize, part = _metis.compute_vertex_separator(xadj, adjncy)
        nose.tools.assert_equal(sepsize, 2)
        nose.tools.assert_equal(len(part), n)
        part1, part2, sep = (list(filter(lambda i: part[i] == k, range(n)))
                             for k in range(3))
        nose.tools.assert_equal(sorted(part1 + part2 + sep), list(range(n)))
        nose.tools.assert_equal(len(sep), 2)
        nose.tools.assert_equal(abs(sep[1] - sep[0]), n // 2)
        nose.tools.assert_equal(
            sorted(map(sorted, [part1, part2])),
            sorted(map(sorted,
                       [[(sep[0] + i) % n for i in range(1, n // 2)],
                        [(sep[1] + i) % n for i in range(1, n // 2)]])))

    def test_MetisOptions(self):
        n = 16
        xadj, adjncy = make_cycle(n)
        options = types.MetisOptions(niter=-2)
        nose.tools.assert_raises_regexp(exceptions.MetisError,
                                        'Input Error: Incorrect niter.',
                                        _metis.part_graph, xadj, adjncy, 2,
                                        options=options)
