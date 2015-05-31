/*!
\file  sort.c
\brief This file contains various sorting rountines using std::sort
*/
#include <algorithm>
#include <functional>

extern "C" {

#include <GKlib.h>



/*************************************************************************/
/*! Sorts an array of chars in increasing order */
/*************************************************************************/
void gk_csorti(size_t n, char *base)
{
  std::sort(base, base + n);
}


/*************************************************************************/
/*! Sorts an array of chars in decreasing order */
/*************************************************************************/
void gk_csortd(size_t n, char *base)
{
  std::sort(base, base + n, std::greater<char>());
}


/*************************************************************************/
/*! Sorts an array of integers in increasing order */
/*************************************************************************/
void gk_isorti(size_t n, int *base)
{
  std::sort(base, base + n);
}


/*************************************************************************/
/*! Sorts an array of integers in decreasing order */
/*************************************************************************/
void gk_isortd(size_t n, int *base)
{
  std::sort(base, base + n, std::greater<int>());
}


/*************************************************************************/
/*! Sorts an array of floats in increasing order */
/*************************************************************************/
void gk_fsorti(size_t n, float *base)
{
  std::sort(base, base + n);
}


/*************************************************************************/
/*! Sorts an array of floats in decreasing order */
/*************************************************************************/
void gk_fsortd(size_t n, float *base)
{
  std::sort(base, base + n, std::greater<float>());
}


/*************************************************************************/
/*! Sorts an array of doubles in increasing order */
/*************************************************************************/
void gk_dsorti(size_t n, double *base)
{
  std::sort(base, base + n);
}


/*************************************************************************/
/*! Sorts an array of doubles in decreasing order */
/*************************************************************************/
void gk_dsortd(size_t n, double *base)
{
  std::sort(base, base + n, std::greater<double>());
}


/*************************************************************************/
/*! Sorts an array of gk_idx_t in increasing order */
/*************************************************************************/
void gk_idxsorti(size_t n, gk_idx_t *base)
{
  std::sort(base, base + n);
}


/*************************************************************************/
/*! Sorts an array of gk_idx_t in decreasing order */
/*************************************************************************/
void gk_idxsortd(size_t n, gk_idx_t *base)
{
  std::sort(base, base + n, std::greater<gk_idx_t>());
}




/*************************************************************************/
/*! Sorts an array of gk_ckv_t in increasing order */
/*************************************************************************/
void gk_ckvsorti(size_t n, gk_ckv_t *base)
{
  std::sort(base, base + n);  
}


/*************************************************************************/
/*! Sorts an array of gk_ckv_t in decreasing order */
/*************************************************************************/
void gk_ckvsortd(size_t n, gk_ckv_t *base)
{
  std::sort(base, base + n, std::greater<gk_ckv_t>());
}


/*************************************************************************/
/*! Sorts an array of gk_ikv_t in increasing order */
/*************************************************************************/
void gk_ikvsorti(size_t n, gk_ikv_t *base)
{
  std::sort(base, base + n);
}


/*************************************************************************/
/*! Sorts an array of gk_ikv_t in decreasing order */
/*************************************************************************/
void gk_ikvsortd(size_t n, gk_ikv_t *base)
{
    std::sort(base, base + n, std::greater<gk_ikv_t>());
}


/*************************************************************************/
/*! Sorts an array of gk_i32kv_t in increasing order */
/*************************************************************************/
void gk_i32kvsorti(size_t n, gk_i32kv_t *base)
{
  std::sort(base, base + n);
}


/*************************************************************************/
/*! Sorts an array of gk_i32kv_t in decreasing order */
/*************************************************************************/
void gk_i32kvsortd(size_t n, gk_i32kv_t *base)
{
  std::sort(base, base + n, std::greater<gk_i32kv_t>());
}


/*************************************************************************/
/*! Sorts an array of gk_i64kv_t in increasing order */
/*************************************************************************/
void gk_i64kvsorti(size_t n, gk_i64kv_t *base)
{
  std::sort(base, base + n);
}


/*************************************************************************/
/*! Sorts an array of gk_i64kv_t in decreasing order */
/*************************************************************************/
void gk_i64kvsortd(size_t n, gk_i64kv_t *base)
{
  std::sort(base, base + n, std::greater<gk_i64kv_t>());
}


/*************************************************************************/
/*! Sorts an array of gk_zkv_t in increasing order */
/*************************************************************************/
void gk_zkvsorti(size_t n, gk_zkv_t *base)
{
  std::sort(base, base + n);
}


/*************************************************************************/
/*! Sorts an array of gk_zkv_t in decreasing order */
/*************************************************************************/
void gk_zkvsortd(size_t n, gk_zkv_t *base)
{
  std::sort(base, base + n, std::greater<gk_zkv_t>());
}


/*************************************************************************/
/*! Sorts an array of gk_fkv_t in increasing order */
/*************************************************************************/
void gk_fkvsorti(size_t n, gk_fkv_t *base)
{
  std::sort(base, base + n);
}


/*************************************************************************/
/*! Sorts an array of gk_fkv_t in decreasing order */
/*************************************************************************/
void gk_fkvsortd(size_t n, gk_fkv_t *base)
{
  std::sort(base, base + n, std::greater<gk_fkv_t>());
}


/*************************************************************************/
/*! Sorts an array of gk_dkv_t in increasing order */
/*************************************************************************/
void gk_dkvsorti(size_t n, gk_dkv_t *base)
{
  std::sort(base, base + n);
}


/*************************************************************************/
/*! Sorts an array of gk_fkv_t in decreasing order */
/*************************************************************************/
void gk_dkvsortd(size_t n, gk_dkv_t *base)
{
  std::sort(base, base + n, std::greater<gk_dkv_t>());
}


/*************************************************************************/
/*! Sorts an array of gk_skv_t in increasing order */
/*************************************************************************/
void gk_skvsorti(size_t n, gk_skv_t *base)
{
  std::sort(base, base + n);
}


/*************************************************************************/
/*! Sorts an array of gk_skv_t in decreasing order */
/*************************************************************************/
void gk_skvsortd(size_t n, gk_skv_t *base)
{
  std::sort(base, base + n, std::greater<gk_skv_t>());
}


/*************************************************************************/
/*! Sorts an array of gk_idxkv_t in increasing order */
/*************************************************************************/
void gk_idxkvsorti(size_t n, gk_idxkv_t *base)
{
  std::sort(base, base + n);
}


/*************************************************************************/
/*! Sorts an array of gk_idxkv_t in decreasing order */
/*************************************************************************/
void gk_idxkvsortd(size_t n, gk_idxkv_t *base)
{
  std::sort(base, base + n, std::greater<gk_idxkv_t>());
}

}
