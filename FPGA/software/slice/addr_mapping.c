/*
 * addr_mapping.c
 *
 *  Created on: May 31, 2017
 *      Author: Jianshen Liu
 */

#include "addr_mapping.h"

#include <stdio.h>
#include <math.h>

#define DEBUG    FALSE

typedef alt_u32 item;
const int kItemSize = sizeof(item);

void start_mapping_listener(alt_u32 baseAddr, alt_u32 byteLen) {
    const int kResetValue = 0;
    const int kRingSize = pow(2, 10);
    const int kCacheSize = pow(2, 8);
    const item *kEdgeAddr = (item *)baseAddr + kRingSize;

    item *pSrc = (item *)baseAddr;
    while (TRUE) {
        int fetchSize = kCacheSize;
        if (pSrc + fetchSize > kEdgeAddr) {
            fetchSize = kEdgeAddr - pSrc;
        }
        alt_dcache_flush(pSrc, fetchSize * kItemSize);

        item *pStart = pSrc;
        while (pSrc < pStart + fetchSize) {
            if (*pSrc == kResetValue) {
                if (pSrc != pStart) {
                    alt_dcache_flush(pStart, (pSrc - pStart) * kItemSize);
                    debug(pSrc, pStart);
                }
                break;
            }

            *pSrc = kResetValue;
            pSrc++;
        }

        if (pSrc >= pStart + fetchSize) {
            alt_dcache_flush(pStart, fetchSize * kItemSize);
            debug(pSrc, pStart);
        }

        if (pSrc >= kEdgeAddr) {
            pSrc = (item *)baseAddr;
        }
    }
}

void debug(item *pSrc, item *pStart) {
    if (DEBUG) {
        printf("Flushed %d bytes from %08Xh to %08Xh\n", (pSrc - pStart) * kItemSize, pStart, pSrc - 1);
    }
}
