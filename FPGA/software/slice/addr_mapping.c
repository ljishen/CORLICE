/*
 * addr_mapping.c
 *
 *  Created on: May 31, 2017
 *      Author: Jianshen Liu
 */

#include "addr_mapping.h"

#include <stdio.h>
#include <math.h>

#define DEBUG     FALSE
#define RESET_VAL 0

const int kItemSize = sizeof(alt_u32);

void debug_print(alt_u32 *pSrc, alt_u32 *pStart) {
    if (DEBUG) {
        printf("Flushed %d bytes from %08X to %08X\n", (pSrc - pStart) * kItemSize, pStart, pSrc - 1);
    }
}

void start_mapping_listener(alt_u32 baseAddr, alt_u32 byteLen) {
    const int kRingSize = pow(2, 10);
    const int kCacheSize = pow(2, 5);
    const alt_u32 *kEndAddr = (alt_u32 *)baseAddr + kRingSize;

    alt_u32 *pSrc = (alt_u32 *)baseAddr;
    while (TRUE) {
        int fetchSize = kCacheSize;
        if (pSrc + fetchSize > kEndAddr) {
            fetchSize = kEndAddr - pSrc;
        }
        alt_dcache_flush(pSrc, fetchSize * kItemSize);

        alt_u32 *pStart = pSrc;
        while (pSrc < pStart + fetchSize) {
            if (*pSrc == RESET_VAL) {
                if (pSrc != pStart) {
                    alt_dcache_flush(pStart, (pSrc - pStart) * kItemSize);
                    debug_print(pSrc, pStart);
                }
                break;
            }

            *pSrc = RESET_VAL;
            pSrc++;
        }

        if (pSrc >= pStart + fetchSize) {
            alt_dcache_flush(pStart, fetchSize * kItemSize);
            debug_print(pSrc, pStart);
        }

        if (pSrc >= kEndAddr) {
            pSrc = (alt_u32 *)baseAddr;
        }
    }
}
