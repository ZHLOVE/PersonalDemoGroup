#ifndef GENERATOR_H_
#define GENERATOR_H_
#include "JY_Head.h"
#include <stdint.h>
#include <vector>

typedef std::vector<float>          FloatVector;
typedef std::vector<FloatVector>    FloatMatrix;
typedef std::vector<int>            IntVector;
typedef std::vector<IntVector>      IntMatrix;

int const kHeight      = 200;
int const kWidth       = 200;
int const kNumClusters = 64;

void computeNodeFeatures(uint8_t const *data, size_t stride,
                         IntMatrix const& superpixels, int numSP,
                         FloatMatrix const& clusters, IntVector const& texClusters,
                         FloatMatrix& meanLab, FloatMatrix& texthists,
                         int& numFeatures,
                         FloatMatrix& instanceNF);

void computeEdgeFeatures(FloatMatrix const& pb, IntMatrix const& superpixels,
                         int& numFeatures,
                         std::vector<float>& edgeFeatures,
                         std::vector<std::pair<int, int> >& instanceEdges);

float dist(FloatVector const& a, FloatVector const& b);

float chisquared(FloatVector const& a, FloatVector const& b);

#endif  // GENERATOR_H_
