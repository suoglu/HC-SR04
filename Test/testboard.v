/* ------------------------------------------------ *
 * Title       : Test module for HC-SR04            *
 * Project     : HC-SR04 Interface                  *
 * ------------------------------------------------ *
 * File        : testboard.v                        *
 * Author      : Yigit Suoglu                       *
 * Last Edit   : 16/01/2021                         *
 * ------------------------------------------------ *
 * Description : System to test HC-SR04 Interface   *
 *               Module. HC-SR04 uses 5V logic!     *
 * ------------------------------------------------ */
//`include "Sources/hc-sr04.v"
//`include "Test/btn_debouncer.v"
//`include "Test/ssd_util.v"

module board(
  input clk,
  input rst,
  input btnD,
  input echo,
  output trig,
  output [4:0] led,
  output ready,
  output [6:0] seg,
  output [3:0] an,
  input sw,
  output [1:0] state);
  wire [20:0] distance;
  wire measure, measure_single, measure_cont;

  assign measure = measure_single | measure_cont;
  assign led = distance[20:16];

  refresher250ms contMeA(clk, sw, measure_cont);
  ssdController4 ssdCntr(clk, rst, 4'b1111, distance[15:12], distance[11:8], distance[7:4], distance[3:0], seg, an);
  debouncer dbbtn(clk, rst, btnD, measure_single);
  hc_sr04 uut(clk, rst, measure, state, ready, echo, trig, distance);
endmodule
