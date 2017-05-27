
module nios_system (
	clk_clk,
	reset_reset_n,
	tse_mac_mdio_connection_mdc,
	tse_mac_mdio_connection_mdio_in,
	tse_mac_mdio_connection_mdio_out,
	tse_mac_mdio_connection_mdio_oen,
	tse_mac_misc_connection_magic_wakeup,
	tse_mac_misc_connection_magic_sleep_n,
	tse_mac_misc_connection_ff_tx_crc_fwd,
	tse_mac_misc_connection_ff_tx_septy,
	tse_mac_misc_connection_tx_ff_uflow,
	tse_mac_misc_connection_ff_tx_a_full,
	tse_mac_misc_connection_ff_tx_a_empty,
	tse_mac_misc_connection_rx_err_stat,
	tse_mac_misc_connection_rx_frm_type,
	tse_mac_misc_connection_ff_rx_dsav,
	tse_mac_misc_connection_ff_rx_a_full,
	tse_mac_misc_connection_ff_rx_a_empty,
	tse_mac_rgmii_connection_rgmii_in,
	tse_mac_rgmii_connection_rgmii_out,
	tse_mac_rgmii_connection_rx_control,
	tse_mac_rgmii_connection_tx_control,
	tse_mac_status_connection_set_10,
	tse_mac_status_connection_set_1000,
	tse_mac_status_connection_eth_mode,
	tse_mac_status_connection_ena_10,
	tse_pcs_mac_rx_clock_connection_clk,
	tse_pcs_mac_tx_clock_connection_clk);	

	input		clk_clk;
	input		reset_reset_n;
	output		tse_mac_mdio_connection_mdc;
	input		tse_mac_mdio_connection_mdio_in;
	output		tse_mac_mdio_connection_mdio_out;
	output		tse_mac_mdio_connection_mdio_oen;
	output		tse_mac_misc_connection_magic_wakeup;
	input		tse_mac_misc_connection_magic_sleep_n;
	input		tse_mac_misc_connection_ff_tx_crc_fwd;
	output		tse_mac_misc_connection_ff_tx_septy;
	output		tse_mac_misc_connection_tx_ff_uflow;
	output		tse_mac_misc_connection_ff_tx_a_full;
	output		tse_mac_misc_connection_ff_tx_a_empty;
	output	[17:0]	tse_mac_misc_connection_rx_err_stat;
	output	[3:0]	tse_mac_misc_connection_rx_frm_type;
	output		tse_mac_misc_connection_ff_rx_dsav;
	output		tse_mac_misc_connection_ff_rx_a_full;
	output		tse_mac_misc_connection_ff_rx_a_empty;
	input	[3:0]	tse_mac_rgmii_connection_rgmii_in;
	output	[3:0]	tse_mac_rgmii_connection_rgmii_out;
	input		tse_mac_rgmii_connection_rx_control;
	output		tse_mac_rgmii_connection_tx_control;
	input		tse_mac_status_connection_set_10;
	input		tse_mac_status_connection_set_1000;
	output		tse_mac_status_connection_eth_mode;
	output		tse_mac_status_connection_ena_10;
	input		tse_pcs_mac_rx_clock_connection_clk;
	input		tse_pcs_mac_tx_clock_connection_clk;
endmodule
