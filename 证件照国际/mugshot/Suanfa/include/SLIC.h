/**
 * Interface for the SLIC class.
 *
 * This code implements the superpixel method described in
 * Radhakrishna Achanta, Appu Shaji, Kevin Smith, Aurelien Lucchi,
 * Pascal Fua, and Sabine Susstrunk, "SLIC Superpixels",
 * EPFL Technical Report no. 149300, June 2010.
 *
 * @copyright   Radhakrishna Achanta [EPFL]. All rights reserved.
 */
#ifndef SLIC_H_
#define SLIC_H_
#include "JY_Head.h"
#include <vector>

class SLIC
{
public:
    /**
     * Superpixel segmentation for a given step size (superpixel size ~= step*step)
     *
     * @param ubuff Each 32 bit unsigned int contains ARGB pixel values.
     */
    void DoSuperpixelSegmentation_ForGivenSuperpixelSize(
                                                         unsigned int const         *ubuff,
                                                         int                        width,
                                                         int                        height,
                                                         std::vector<int>&          klabels,
                                                         int&                       numlabels,
                                                         int                        superpixelsize,
                                                         double                     compactness);

    /**
     * Superpixel segmentation for a given number of superpixels
     *
     * @param K     Required number of superpixels
     * @compactness 10 - 20 is a good value for CIELAB space
     */
    void DoSuperpixelSegmentation_ForGivenNumberOfSuperpixels(
                                                              unsigned int const    *ubuff,
                                                              int                   width,
                                                              int                   height,
                                                              std::vector<int>&     klabels,
                                                              int&                  numlabels,
                                                              int                   K,
                                                              double                compactness);

    /**
     * Supervoxel segmentation for a given step size (supervoxel size ~= step*step*step)
     */
    void DoSupervoxelSegmentation(
                                  unsigned int**&   ubuffvec,
                                  int               width,
                                  int               height,
                                  int               depth,
                                  int**&            klabels,
                                  int&              numlabels,
                                  int               supervoxelsize,
                                  double            compactness);

    /**
     * Function to draw boundaries around superpixels of a given 'color'.
     * Can also be used to draw boundaries around supervoxels, i.e layer by layer.
     */
    void DrawContoursAroundSegments(
                                    unsigned int*           segmentedImage,
                                    const int*              labels,
                                    int                     width,
                                    int                     height);

private:
    /**
     * The main SLIC algorithm for generating superpixels
     */
    void PerformSuperpixelSLIC(
                               std::vector<double>&         kseedsl,
                               std::vector<double>&         kseedsa,
                               std::vector<double>&         kseedsb,
                               std::vector<double>&         kseedsx,
                               std::vector<double>&         kseedsy,
                               std::vector<int>&            klabels,
                               int                          STEP,
                               std::vector<double> const&   edgemag,
                               double                       m = 10.0);

    /**
     * The main SLIC algorithm for generating supervoxels
     */
    void PerformSupervoxelSLIC(
                               std::vector<double>&         kseedsl,
                               std::vector<double>&         kseedsa,
                               std::vector<double>&         kseedsb,
                               std::vector<double>&         kseedsx,
                               std::vector<double>&         kseedsy,
                               std::vector<double>&         kseedsz,
                               int**&                       klabels,
                               int                          STEP,
                               double                       compactness);

    /**
     * Pick seeds for superpixels when step size of superpixels is given.
     */
    void GetLABXYSeeds_ForGivenStepSize(
                                        std::vector<double>&        kseedsl,
                                        std::vector<double>&        kseedsa,
                                        std::vector<double>&        kseedsb,
                                        std::vector<double>&        kseedsx,
                                        std::vector<double>&        kseedsy,
                                        int                         STEP,
                                        bool                        perturbseeds,
                                        std::vector<double> const&  edgemag);

    /**
     * Pick seeds for supervoxels
     */
    void GetKValues_LABXYZ(
                           std::vector<double>&         kseedsl,
                           std::vector<double>&         kseedsa,
                           std::vector<double>&         kseedsb,
                           std::vector<double>&         kseedsx,
                           std::vector<double>&         kseedsy,
                           std::vector<double>&         kseedsz,
                           int                          STEP);

    /**
     * Move the superpixel seeds to low gradient positions to avoid putting seeds at region boundaries.
     */
    void PerturbSeeds(
                      std::vector<double>&          kseedsl,
                      std::vector<double>&          kseedsa,
                      std::vector<double>&          kseedsb,
                      std::vector<double>&          kseedsx,
                      std::vector<double>&          kseedsy,
                      std::vector<double> const&    edges);

    /**
     * Detect color edges, to help PerturbSeeds()
     */
    void DetectLabEdges(
                        std::vector<double> const&  lvec,
                        std::vector<double> const&  avec,
                        std::vector<double> const&  bvec,
                        int                     width,
                        int                     height,
                        std::vector<double>&    edges);

    /**
     * sRGB to XYZ conversion; helper for RGB2LAB()
     */
    void RGB2XYZ(
                 int        sR,
                 int        sG,
                 int        sB,
                 double&    X,
                 double&    Y,
                 double&    Z);

    /**
     * sRGB to CIELAB conversion (uses RGB2XYZ function)
     */
    void RGB2LAB(
                 int        sR,
                 int        sG,
                 int        sB,
                 double&    lval,
                 double&    aval,
                 double&    bval);

    /**
     * sRGB to CIELAB conversion for 2-D images
     */
    void DoRGBtoLABConversion(
                              unsigned int const    *ubuff,
                              std::vector<double>&  lvec,
                              std::vector<double>&  avec,
                              std::vector<double>&  bvec);

    /**
     * sRGB to CIELAB conversion for 3-D volumes
     */
    void DoRGBtoLABConversion(
                              unsigned int                      **ubuff,
                              std::vector<std::vector<double> >& lvec,
                              std::vector<std::vector<double> >& avec,
                              std::vector<std::vector<double> >& bvec);

    /**
     * Post-processing of SLIC segmentation, to avoid stray labels.
     *
     * @param nlabels       Input labels that need to be corrected to remove stray labels.
     * @param numlabels     The number of labels changes in the end if segments are removed.
     * @param K             The number of super pixels desired by the user.
     */
    void EnforceLabelConnectivity(
                                  int const                 *labels,
                                  int                       width,
                                  int                       height,
                                  std::vector<int>&         nlabels,
                                  int&                      numlabels,
                                  int                       K);

    /**
     * Post-processing of SLIC supervoxel segmentation, to avoid stray labels.
     *
     * @param labels    Input: previous labels. Output: new labels.
     */
    void EnforceSupervoxelLabelConnectivity(
                                            int**       labels,
                                            int         width,
                                            int         height,
                                            int         depth,
                                            int&        numlabels,
                                            int         STEP);

private:
    int         m_width;
    int         m_height;
    int         m_depth;

    std::vector<double> m_lvec;
    std::vector<double> m_avec;
    std::vector<double> m_bvec;

    std::vector<std::vector<double> >   m_lvecvec;
    std::vector<std::vector<double> >   m_avecvec;
    std::vector<std::vector<double> >   m_bvecvec;
};

#endif  // SLIC_H_
