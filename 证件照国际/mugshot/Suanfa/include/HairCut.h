#ifndef HAIRCUT_H_
#define HAIRCUT_H_
#include "JY_Head.h"
#include <stddef.h>
#include <stdint.h>

#define DETECT_HAIR_ERROR   -1
#define DETECT_HAIR_OK      0

int detectHair(uint8_t const *image, size_t width, size_t height, uint8_t *mask);

#endif  // HAIRCUT_H_
