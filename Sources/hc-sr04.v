/* ------------------------------------------------ *
 * Title       : HC-SR04 Interface v1               *
 * Project     : HC-SR04 Interface                  *
 * ------------------------------------------------ *
 * File        : hc-sr04.v                          *
 * Author      : Yigit Suoglu                       *
 * Last Edit   : 16/01/2021                         *
 * Licence     : CERN-OHL-W                         *
 * ------------------------------------------------ *
 * Description : A verilog interface for HC-SR04    *
 *               ultrasonic ranging module. HC-SR04 *
 *               uses 5V logic!                     *
 * ------------------------------------------------ *
 * Revisions                                        *
 *     v1      : Inital version                     *
 * ------------------------------------------------ */

module hc_sr04#(parameter ten_us = 10'd1000)(
  input clk, //100 MHz
  input rst,
  input measure,
  output reg [1:0] state,
  output ready,
  //HC-SR04 signals
  input echo, //JA1
  output trig, //JA2
  output reg [21:0] distanceRAW);
  localparam IDLE = 2'b00,
          TRIGGER = 2'b01,
             WAIT = 2'b11,
        COUNTECHO = 2'b10;
  wire inIDLE, inTRIGGER, inWAIT, inCOUNTECHO;
  reg [9:0] counter;
  wire trigcountDONE, counterDONE;

  //Ready
  assign ready = inIDLE;
  
  //Decode states
  assign inIDLE = (state == IDLE);
  assign inTRIGGER = (state == TRIGGER);
  assign inWAIT = (state == WAIT);
  assign inCOUNTECHO = (state == COUNTECHO);

  //State transactions
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        begin
          state <= IDLE;
        end
      else
        begin
          case(state)
            IDLE:
              begin
                state <= (measure & ready) ? TRIGGER : state;
              end
            TRIGGER:
              begin
                state <= (trigcountDONE) ? WAIT : state;
              end
            WAIT:
              begin
                state <= (echo) ? COUNTECHO : state;
              end
            COUNTECHO:
              begin
                state <= (echo) ? state : IDLE;
              end
          endcase
          
        end
    end
  
  //Trigger
  assign trig = inTRIGGER;
  
  //Counter
  always@(posedge clk)
    begin
      if(inIDLE)
        begin
          counter <= 10'd0;
        end
      else
        begin
          counter <= counter + {9'd0, (|counter | inTRIGGER)};
        end
    end
  assign trigcountDONE = (counter == ten_us);

  //Get distance
  always@(posedge clk)
    begin
      if(inWAIT)
        distanceRAW <= 22'd0;
      else
        distanceRAW <= distanceRAW + {21'd0, inCOUNTECHO};
    end
endmodule

module refresher250ms(
  input clk,
  input en,
  output measure);
  reg [24:0] counter;

  assign measure = (counter == 25'd1);

  always@(posedge clk)
    begin
      if(~en | (counter == 25'd25_000_000))
        counter <= 25'd0;
      else
        counter <= 25'd1 + counter;
    end
endmodule