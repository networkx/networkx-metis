/*!
\file  gklib.c
\brief Various helper routines generated using GKlib's templates

\date   Started 4/12/2007
\author George  
\author Copyright 1997-2009, Regents of the University of Minnesota 
\version\verbatim $Id: gklib.c 10395 2011-06-23 23:28:06Z karypis $ \endverbatim
*/
#include <algorithm>
#include <functional>
#include <utility>

namepace {

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

  struct rkv_t_greater {
    bool operator()(const rkv_t &a, const rkv_t &b) const {
        return a.key > b.key;
    }
  };

  struct rkv_t_less {
    bool operator()(const rkv_t &a, const rkv_t &b) const {
        return a.key < b.key;
    }
  };

  struct ikv_t_greater {
    bool operator()(const ikv_t &a, const ikv_t &b) const {
        return a.key > b.key;
    }
  };

  struct ikv_t_less {
    bool operator()(const ikv_t &a, const ikv_t &b) const {
        return a.key < b.key;
    }
  };
}

extern "C" {

#include "metislib.h"


/*************************************************************************/
/*! BLAS routines */
/*************************************************************************/
GK_MKBLAS(i,  idx_t,  idx_t)
GK_MKBLAS(r,  real_t, real_t)

/*************************************************************************/
/*! Memory allocation routines */
/*************************************************************************/
GK_MKALLOC(i,    idx_t)
GK_MKALLOC(r,    real_t)
GK_MKALLOC(ikv,  ikv_t)
GK_MKALLOC(rkv,  rkv_t)

/*************************************************************************/
/*! Priority queues routines */
/*************************************************************************/
#define key_gt(a, b) ((a) > (b))
GK_MKPQUEUE(ipq, ipq_t, ikv_t, idx_t, idx_t, ikvmalloc, IDX_MAX, key_gt)
GK_MKPQUEUE(rpq, rpq_t, rkv_t, real_t, idx_t, rkvmalloc, REAL_MAX, key_gt)
#undef key_gt

/*************************************************************************/
/*! Random number generation routines */
/*************************************************************************/
GK_MKRANDOM(i, idx_t, idx_t)

/*************************************************************************/
/*! Utility routines */
/*************************************************************************/
GK_MKARRAY2CSR(i, idx_t)

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
  std::sort(base, base + n, ikv_t_less())
}

/* Sorts based both on key and val */
void ikvsortii(size_t n, ikv_t *base)
{
  std::sort(base, base + n, ikvi_t_less());
}

void ikvsortd(size_t n, ikv_t *base)
{
  std::sort(base, base + n, ikv_t_greater());  
}

void rkvsorti(size_t n, rkv_t *base)
{
  std::sort(base, base + n, rkv_t_less());
}

void rkvsortd(size_t n, rkv_t *base)
{
  std::sort(base, base + n, rkv_t_greater());
}

void uvwsorti(size_t n, uvw_t *base)
{
  std::sort(base, base + n, uvwi_t_less());
}

}
