--                   _____     
--                  |  0  |   
--                  |5   1|    
--                  |_____|   
--                  |  6  |  
--                  |4   2|  
--                  |_____|  
--                     3      

library IEEE;
use IEEE.std_logic_1164.all;

entity seven_segment_DEO_CV is
port(
	entrada_single: in std_logic_vector(3 downto 0);
	bar	:		out	std_logic_vector(6 downto 0)
);									
end seven_segment_DEO_CV;

architecture hardware of seven_segment_DEO_CV is
	signal s_bar: std_logic_vector(6 downto 0);
begin
	bar <= not s_bar;
	s_bar <=  "0111111" when entrada_single = "0000" else		-- Quando counter igual a 0, envia '0' para o barramento do display
					"0000110" when entrada_single = "0001" else		-- Quando counter igual a 1, envia '1' para o barramento do display
					"1011011" when entrada_single = "0010" else		-- Quando counter igual a 2, envia '2' para o barramento do display
					"1001111" when entrada_single = "0011" else		-- Quando counter igual a 3, envia '3' para o barramento do display
					"1100110" when entrada_single = "0100" else		-- Quando counter igual a 4, envia '4' para o barramento do display
					"1101101" when entrada_single = "0101" else		-- Quando counter igual a 5, envia '5' para o barramento do display
					"1111100" when entrada_single = "0110" else		-- Quando counter igual a 6, envia '6' para o barramento do display
					"0000111" when entrada_single = "0111" else		-- Quando counter igual a 7, envia '7' para o barramento do display
					"1111111" when entrada_single = "1000" else		-- Quando counter igual a 8, envia '8' para o barramento do display
					"1100111" when entrada_single = "1001" else		-- Quando counter igual a 9, envia '9' para o barramento do display
					"0000000";															-- Quando outros valores, desliga display 
end hardware;