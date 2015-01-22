#ifndef __UTILITY_H_
#define __UTILITY_H_

#include <limits>
#include <cstdio>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>
#include <iomanip>

#include <perf.h>

#include <device_matrix.h>
typedef device_matrix<float> mat;

#define float_min std::numeric_limits<float>::min()
#define float_max std::numeric_limits<float>::max()

#define __WHERE__ (std::string("In function \"") + __func__ \
    + std::string("\" (at ") + __FILE__ \
    + std::string(":") + to_string(__LINE__) + std::string("): "))

#define RED_ERROR (util::red("[Error] ") + __WHERE__ )
#define YELLOW_WARNING (util::yellow("[WARNING] ") + __WHERE__ )

#define DEBUG_STR(x) ("\33[33m"#x"\33[0m = " + to_string(x) + "\t")

#ifdef DEBUG

#define PAUSE {\
  printf("Press Enter key to continue...");\
  fgetc(stdin);\
}

#define matlog(x) {\
  printf(#x": ");\
  (x).status();\
  printf("\33[34m"#x"\33[0m = [\n");\
  (x).print();\
  printf("];\n");\
}

#define mylog(x) {\
  std::cout << #x << " = " << x << std::endl;\
}

#else

#define PAUSE {}
#define matlog(x) {}
#define mylog(x) {}

#endif

enum ConvType {
  SAME,
  SAME_SHM,
  VALID,
  VALID_SHM,
  FULL,
  FULL_SHM
};

struct SIZE {
  size_t m, n;
  SIZE(): m(0), n(0) {}
  SIZE(size_t m, size_t n): m(m), n(n) {}

  bool operator == (const SIZE& rhs) const { return m == rhs.m && n == rhs.n; }

  SIZE operator + (const SIZE& rhs) const { return SIZE(m + rhs.m, n + rhs.n); }
  SIZE operator - (const SIZE& rhs) const { return SIZE(m - rhs.m, n - rhs.n); }

  SIZE operator + (size_t x) const { return SIZE(m + x, n + x); }
  SIZE operator - (size_t x) const { return SIZE(m - x, n - x); }
  SIZE operator * (size_t x) const { return SIZE(m * x, n * x); }
  SIZE operator / (size_t x) const { return SIZE(m / x, n / x); }

  size_t area() const { return m * n; }

  friend SIZE max(const SIZE& s1, const SIZE& s2) {
    return SIZE(std::max(s1.m, s2.m), std::max(s1.n, s2.n));
  }

  operator std::string () {
    char buffer[12];
    sprintf(buffer, "%2lu x %-2lu", m, n);
    return buffer;
  }

  friend std::ostream& operator << (std::ostream& os, const SIZE& s) {
    os << std::setw(3) << s.m <<  " x " << std::left << std::setw(3) << s.n;
    return os;
  }
};

enum ERROR_MEASURE {
  L2ERROR,	/* for binary-classification only */
  CROSS_ENTROPY /* for multi-class classification */
};

void SetGpuCardId(size_t card_id);

namespace util {
  inline std::string red(const std::string& str) {
    return "\33[31m" + str + "\33[0m";
  }

  inline std::string green(const std::string& str) {
    return "\33[32m" + str + "\33[0m";
  }

  inline std::string yellow(const std::string& str) {
    return "\33[33m" + str + "\33[0m";
  }

  inline std::string blue(const std::string& str) {
    return "\33[34m" + str + "\33[0m";
  }

  inline std::string purple(const std::string& str) {
    return "\33[35m" + str + "\33[0m";
  }

  inline std::string cyan(const std::string& str) {
    return "\33[36m" + str + "\33[0m";
  }
};

template <typename T>
void print(const std::vector<T>& v) {
  cout << "[";
  for (int i=0; i<v.size(); ++i)
    cout << v[i] << ", ";
  cout << "\b\b]" << endl;
}

template <typename T>
std::string to_string(T n) {
  std::stringstream ss;
  ss << n;
  return ss.str();
}

// trim from start
static inline std::string ltrim(std::string s) {
  s.erase(s.begin(), std::find_if(s.begin(), s.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
  return s;
}

// trim from end
static inline std::string rtrim(std::string s) {
  s.erase(std::find_if(s.rbegin(), s.rend(), std::not1(std::ptr_fun<int, int>(std::isspace))).base(), s.end());
  return s;
}

// trim from both ends
static inline std::string trim(const std::string &s) {
  return ltrim(rtrim(s));
}

int str2int(const std::string &s);
float str2float(const std::string &s);
std::vector<std::string> split(const std::string &s, char delim);
std::vector<std::string>& split(const std::string &s, char delim, std::vector<std::string>& elems);
std::vector<size_t> splitAsInt(const std::string &s, char delim);
std::vector<size_t> randperm(size_t N);
bool is_number(const std::string& s);
void linearRegression(const std::vector<float> &x, const std::vector<float>& y, float* const &m, float* const &c);

void showAccuracy(size_t nError, size_t nTotal);

size_t parseInputDimension(const std::string &input_dim);
SIZE parseImageDimension(const std::string &m_by_n);

#endif
