/*
 * addr_mapping.c
 *
 *  Created on: May 31, 2017
 *      Author: Jianshen Liu
 */

#include "addr_mapping.h"
#include "kroki_cuckoo/cuckoo_hash.h"

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define DEBUG FALSE
#define RESET_VAL 0

/* initial hash table size, which is (bin_size << power) */
#define HASH_TABLE_POWER 7

const int kItemSize = sizeof(alt_u32);

void debug_flush(alt_u32 *pSrc, alt_u32 *pStart) {
    if (DEBUG) {
        printf("Flushed %d bytes from %8p to %8p\n\n",
                (pSrc - pStart) * kItemSize, pStart, pSrc - 1);
    }
}

void start_mapping_listener(alt_u32 baseAddr, alt_u32 byteLen) {
    const int kRingSize = pow(2, 5);
    const int kCacheSize = pow(2, 3);
    const alt_u32 *kEndAddr = (alt_u32 *) baseAddr + kRingSize;

    struct cuckoo_hash hash_table;
    if (!cuckoo_hash_init(&hash_table, HASH_TABLE_POWER)) {
        fprintf(stderr,
                "### System Halted: fail to initialize Cuckoo Hash Table ###\n");
        exit(EXIT_FAILURE);
    }
    printf("### Cuckoo Hash Table Initialized ###\n\n");

    alt_u32 *pSrc = (alt_u32 *) baseAddr;

    // start the main loop
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
                    debug_flush(pSrc, pStart);
                }
                break;
            }

            // Insert address into hash table
            if (CUCKOO_HASH_FAILED
                    == cuckoo_hash_insert(&hash_table, pSrc, kItemSize, pSrc)) {
                fprintf(stderr, "\n\n### Fail to insert 0x%08X=0x%08X "
                        "into table (%d elements in the table) ###\n\n",
                        (unsigned int) *pSrc, (unsigned int) *pSrc,
                        cuckoo_hash_count(&hash_table));
                cuckoo_hash_destroy(&hash_table);

                // FIXME: Because of the onchip memory is too small in the current
                // hardware design.
                if (!cuckoo_hash_init(&hash_table, HASH_TABLE_POWER)
                        ||
                        CUCKOO_HASH_FAILED
                                == cuckoo_hash_insert(&hash_table, pSrc,
                                        kItemSize, pSrc)) {
                    fprintf(stderr,
                            "\n\n### System Halted: Fail to insert 0x%08X=0x%08X "
                                    "into table (%d elements in the table) ###\n",
                            (unsigned int) *pSrc, (unsigned int) *pSrc,
                            cuckoo_hash_count(&hash_table));
                    cuckoo_hash_destroy(&hash_table);
                    exit(EXIT_FAILURE);
                }
            }

            if (DEBUG) {
                struct cuckoo_hash_item *item = cuckoo_hash_lookup(&hash_table,
                        pSrc, kItemSize);
                printf(
                        "Lookup value by key [0x%08X=0x%08X] (%d elements in the table)\n",
                        (unsigned int) *pSrc,
                        (unsigned int) *((alt_u32 *) item->value),
                        cuckoo_hash_count(&hash_table));
            }

            // reset the shared memory address so that HPS can set a new value
            *pSrc = RESET_VAL;

            pSrc++;
        }

        if (pSrc >= pStart + fetchSize) {
            alt_dcache_flush(pStart, fetchSize * kItemSize);
            debug_flush(pSrc, pStart);
        }

        if (pSrc >= kEndAddr) {
            pSrc = (alt_u32 *) baseAddr;
        }
    }
}
