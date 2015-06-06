/*!
\file  gklib_sort.cc
\brief Various sorting routines

*/

#include <algorithm>
#include <functional>
#include <utility>

extern "C" {
#include "metislib.h"
}

namespace {

  struct ikvi_t_less {
    bool operator()(const ikv_t &lhs, const ikv_t &rhs) const {
        return std::make_pair(lhs.key, lhs.val) < std::make_pair(rhs.key, rhs.val);
    }
  };

  struct uvwi_t_less {
    bool operator()(const uvw_t &lhs, const uvw_t &rhs) const {
        return std::make_pair(lhs.u, lhs.v) < std::make_pair(rhs.u, rhs.v);
    }
  };

  struct kv_t_greater {
    template<typename T>
    bool operator()(const T &a, const T &b) const {
        return a.key > b.key;
    }
  };

  struct kv_t_less {
    template<typename T>
    bool operator()(const T &a, const T &b) const {
        return a.key < b.key;
    }
  };

}

extern "C" {

/*************************************************************************/
/*! Sorting routines */
/*************************************************************************/

void isorti(size_t n, idx_t *base)
{
  std::sort(base, base + n);
}

void isortd(size_t n, idx_t *base)
{
  std::sort(base, base + n, std::greater<idx_t>());
}

void rsorti(size_t n, real_t *base)
{
  std::sort(base, base + n);
}

void rsortd(size_t n, real_t *base)
{
  std::sort(base, base + n, std::greater<real_t>());
}

void ikvsorti(size_t n, ikv_t *base)
{
  std::sort(base, base + n, kv_t_less());
}

/* Sorts based both on key and val */
void ikvsortii(size_t n, ikv_t *base)
{
  std::sort(base, base + n, ikvi_t_less());
}

void ikvsortd(size_t n, ikv_t *base)
{
  std::sort(base, base + n, kv_t_greater());
}

void rkvsorti(size_t n, rkv_t *base)
{
  std::sort(base, base + n, kv_t_less());
}

void rkvsortd(size_t n, rkv_t *base)
{
  std::sort(base, base + n, kv_t_greater());
}

void uvwsorti(size_t n, uvw_t *base)
{
  std::sort(base, base + n, uvwi_t_less());
}

}
