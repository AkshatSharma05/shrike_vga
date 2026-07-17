-- {{TOP}}.vhd - top-level entity for SLG47910V (ForgeFPGA / Shrike Lite)
-- Vulcan's VHDL Blinky Demo
-- Signals must match io_map.pcf assignments.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity {{TOP}} is
  port (
    clk    : in  std_logic;
    LED    : out std_logic;
    LED_en : out std_logic;
    clk_en : out std_logic
  );

  attribute clkbuf_inhibit    : string;
  attribute iopad_external_pin : string;
  attribute clkbuf_inhibit     of clk    : signal is "true";
  attribute iopad_external_pin of clk    : signal is "true";
  attribute iopad_external_pin of LED    : signal is "true";
  attribute iopad_external_pin of LED_en : signal is "true";
  attribute iopad_external_pin of clk_en : signal is "true";

end entity {{TOP}};

architecture rtl of {{TOP}} is
  signal counter    : unsigned(31 downto 0) := (others => '0');
  signal LED_status : std_logic := '0';
begin

  LED_en <= '1';
  clk_en <= '1';

  process(clk)
  begin
    if rising_edge(clk) then
      if counter = 50_000_000 then
        LED_status <= not LED_status;
        counter    <= (others => '0');
      else
        counter <= counter + 1;
      end if;
    end if;
  end process;

  LED <= LED_status;

end architecture rtl;