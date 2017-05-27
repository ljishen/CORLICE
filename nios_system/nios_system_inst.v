	nios_system u0 (
		.clk_clk                               (<connected-to-clk_clk>),                               //                             clk.clk
		.reset_reset_n                         (<connected-to-reset_reset_n>),                         //                           reset.reset_n
		.tse_mac_mdio_connection_mdc           (<connected-to-tse_mac_mdio_connection_mdc>),           //         tse_mac_mdio_connection.mdc
		.tse_mac_mdio_connection_mdio_in       (<connected-to-tse_mac_mdio_connection_mdio_in>),       //                                .mdio_in
		.tse_mac_mdio_connection_mdio_out      (<connected-to-tse_mac_mdio_connection_mdio_out>),      //                                .mdio_out
		.tse_mac_mdio_connection_mdio_oen      (<connected-to-tse_mac_mdio_connection_mdio_oen>),      //                                .mdio_oen
		.tse_mac_misc_connection_magic_wakeup  (<connected-to-tse_mac_misc_connection_magic_wakeup>),  //         tse_mac_misc_connection.magic_wakeup
		.tse_mac_misc_connection_magic_sleep_n (<connected-to-tse_mac_misc_connection_magic_sleep_n>), //                                .magic_sleep_n
		.tse_mac_misc_connection_ff_tx_crc_fwd (<connected-to-tse_mac_misc_connection_ff_tx_crc_fwd>), //                                .ff_tx_crc_fwd
		.tse_mac_misc_connection_ff_tx_septy   (<connected-to-tse_mac_misc_connection_ff_tx_septy>),   //                                .ff_tx_septy
		.tse_mac_misc_connection_tx_ff_uflow   (<connected-to-tse_mac_misc_connection_tx_ff_uflow>),   //                                .tx_ff_uflow
		.tse_mac_misc_connection_ff_tx_a_full  (<connected-to-tse_mac_misc_connection_ff_tx_a_full>),  //                                .ff_tx_a_full
		.tse_mac_misc_connection_ff_tx_a_empty (<connected-to-tse_mac_misc_connection_ff_tx_a_empty>), //                                .ff_tx_a_empty
		.tse_mac_misc_connection_rx_err_stat   (<connected-to-tse_mac_misc_connection_rx_err_stat>),   //                                .rx_err_stat
		.tse_mac_misc_connection_rx_frm_type   (<connected-to-tse_mac_misc_connection_rx_frm_type>),   //                                .rx_frm_type
		.tse_mac_misc_connection_ff_rx_dsav    (<connected-to-tse_mac_misc_connection_ff_rx_dsav>),    //                                .ff_rx_dsav
		.tse_mac_misc_connection_ff_rx_a_full  (<connected-to-tse_mac_misc_connection_ff_rx_a_full>),  //                                .ff_rx_a_full
		.tse_mac_misc_connection_ff_rx_a_empty (<connected-to-tse_mac_misc_connection_ff_rx_a_empty>), //                                .ff_rx_a_empty
		.tse_mac_rgmii_connection_rgmii_in     (<connected-to-tse_mac_rgmii_connection_rgmii_in>),     //        tse_mac_rgmii_connection.rgmii_in
		.tse_mac_rgmii_connection_rgmii_out    (<connected-to-tse_mac_rgmii_connection_rgmii_out>),    //                                .rgmii_out
		.tse_mac_rgmii_connection_rx_control   (<connected-to-tse_mac_rgmii_connection_rx_control>),   //                                .rx_control
		.tse_mac_rgmii_connection_tx_control   (<connected-to-tse_mac_rgmii_connection_tx_control>),   //                                .tx_control
		.tse_mac_status_connection_set_10      (<connected-to-tse_mac_status_connection_set_10>),      //       tse_mac_status_connection.set_10
		.tse_mac_status_connection_set_1000    (<connected-to-tse_mac_status_connection_set_1000>),    //                                .set_1000
		.tse_mac_status_connection_eth_mode    (<connected-to-tse_mac_status_connection_eth_mode>),    //                                .eth_mode
		.tse_mac_status_connection_ena_10      (<connected-to-tse_mac_status_connection_ena_10>),      //                                .ena_10
		.tse_pcs_mac_rx_clock_connection_clk   (<connected-to-tse_pcs_mac_rx_clock_connection_clk>),   // tse_pcs_mac_rx_clock_connection.clk
		.tse_pcs_mac_tx_clock_connection_clk   (<connected-to-tse_pcs_mac_tx_clock_connection_clk>)    // tse_pcs_mac_tx_clock_connection.clk
	);

