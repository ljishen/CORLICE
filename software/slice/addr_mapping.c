/*
 * addr_mapping.c
 *
 *  Created on: May 31, 2017
 *      Author: Jianshen Liu
 */

#include "addr_mapping.h"
#include <stdio.h>

void start_mapping_listener(alt_u32 BaseAddr, alt_u32 ByteLen) {
    typedef alt_u32 my_data;
    const int item_num = 5;

    my_data *pSrc;
    pSrc = (my_data *)BaseAddr;

    my_data szData[5];
    szData[0] = 0xAAAAAAAA;
    szData[1] = 0x11111111;
    szData[2] = 0x44444444;
    szData[3] = 0x3CCEEEE1;
    szData[4] = 0x123321AA;

    printf("12aa");
    memcpy(pSrc, szData, sizeof(szData));
    alt_dcache_flush_all();

    printf("123123");

    my_data *pDes;
    pDes = (my_data *)BaseAddr;

    int i;
    for (i = 0; i < item_num; i++) {
        printf("address=%08Xh, read=%08Xh\n", pDes, (int)*pDes);
        *pDes++;
    }
}
