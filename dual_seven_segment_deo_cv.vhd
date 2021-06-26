--            _____     _____   
--           |  0  |   |  a  |  
--           |5   1|   |f   b|  
--           |_____|   |_____|  
--           |  6  |   |  g  |
--           |4   2|   |e   c|
--           |_____|   |_____|
--              3         d 

library IEEE;
use IEEE.std_logic_1164.all;

entity dual_seven_segment_DEO_CV is
port(
	entrada:   in std_logic_vector(6 downto 0);
	bar1	:		out	std_logic_vector(6 downto 0);
	bar0	:		out	std_logic_vector(6 downto 0)
);									
end dual_seven_segment_DEO_CV;

architecture hardware of dual_seven_segment_DEO_CV is
	
	component seven_segment_DEO_CV is
		port(
			entrada_single: in std_logic_vector(3 downto 0);
			bar	:		out	std_logic_vector(6 downto 0)
		);									
	end component;

	signal s_entrada1 : std_logic_vector(3 downto 0);
	signal s_entrada0 : std_logic_vector(3 downto 0);

begin
	
	s_entrada0 <=  entrada(3 downto 0) when (entrada < "0001010") else		
								 "0000"	when  (entrada = "0001010") or (entrada = "0010100") or (entrada = "0011110") or 
								 						  (entrada = "0101000") or (entrada = "0110010") or (entrada = "0111100") or 
														  (entrada = "1000110") or (entrada = "1010000") or (entrada = "1011010") else		

								 "0001"	when  (entrada = "0001011") or (entrada = "0010101") or (entrada = "0011111") or
								 							(entrada = "0101001") or (entrada = "0110011") or (entrada = "0111101") or
															(entrada = "1000111") or (entrada = "1010001") or (entrada = "1011011") else	
															
								 "0010"	when  (entrada = "0001100") or (entrada = "0010110") or (entrada = "0100000") or
								 							(entrada = "0101010") or (entrada = "0110100") or (entrada = "0111110") or
															(entrada = "1001000") or (entrada = "1010010") or (entrada = "1011100") else

								 "0011"	when  (entrada = "0001101") or (entrada = "0010111") or (entrada = "0100001") or
								 							(entrada = "0101011") or (entrada = "0110101") or (entrada = "0111111") or
															(entrada = "1001001") or (entrada = "1010011") or (entrada = "1011101") else

								 "0100"	when  (entrada = "0001110") or (entrada = "0011000") or (entrada = "0100010") or
								 							(entrada = "0101100") or (entrada = "0110110") or (entrada = "1000000") or
															(entrada = "1001010") or (entrada = "1010100") or (entrada = "1011110") else

								 "0101"	when  (entrada = "0001111") or (entrada = "0011001") or (entrada = "0100011") or
								 							(entrada = "0101101") or (entrada = "0110111") or (entrada = "1000001") or
															(entrada = "1001011") or (entrada = "1010101") or (entrada = "1011111") else

								 "0110"	when  (entrada = "0010000") or (entrada = "0011010") or (entrada = "0100100") or
								 							(entrada = "0101110") or (entrada = "0111000") or (entrada = "1000010") or
															(entrada = "1001100") or (entrada = "1010110") or (entrada = "1100000") else

								 "0111"	when  (entrada = "0010001") or (entrada = "0011011") or (entrada = "0100101") or
								 							(entrada = "0101111") or (entrada = "0111001") or (entrada = "1000011") or
															(entrada = "1001101") or (entrada = "1010111") or (entrada = "1100001") else

								 "1000"	when  (entrada = "0010010") or (entrada = "0011100") or (entrada = "0100110") or
								 							(entrada = "0110000") or (entrada = "0111010") or (entrada = "1000100") or
															(entrada = "1001110") or (entrada = "1011000") or (entrada = "1100010") else

								 "1001" when  (entrada = "0010011") or (entrada = "0011101") or (entrada = "0100111") or
								 							(entrada = "0110001") or (entrada = "0111011") or (entrada = "1000101") or
															(entrada = "1001111") or (entrada = "1011001") or (entrada = "1100011") else "0000";


	s_entrada1 <= "0000" when entrada < "0001010" else
								"0001" when (entrada > "0001001") and (entrada < "0010100") else -- s_entrada recebe 1 quando entrada >  9 e entrada < 20
								"0010" when (entrada > "0010011") and (entrada < "0011110") else -- s_entrada recebe 2 quando entrada > 19 e entrada < 30
								"0011" when (entrada > "0011101") and (entrada < "0101000") else -- s_entrada recebe 3 quando entrada > 29 e entrada < 40
								"0100" when (entrada > "0100111") and (entrada < "0110010") else -- s_entrada recebe 4 quando entrada > 39 e entrada < 50
								"0101" when (entrada > "0100111") and (entrada < "0111100") else -- s_entrada recebe 5 quando entrada > 49 e entrada < 60
								"0110" when (entrada > "0111011") and (entrada < "1000110") else -- s_entrada recebe 6 quando entrada > 59 e entrada < 70
								"0111" when (entrada > "1000101") and (entrada < "1010000") else -- s_entrada recebe 7 quando entrada > 69 e entrada < 80
								"1000" when (entrada > "1001111") and (entrada < "1011010") else -- s_entrada recebe 8 quando entrada > 79 e entrada < 90
								"1001" when (entrada > "1001111") and (entrada < "1100100") else -- s_entrada recebe 9 quando entrada > 89 e entrada < 100
								"0000";

	display_1 : seven_segment_DEO_CV port map (s_entrada1, bar1);
	display_0 : seven_segment_DEO_CV port map (s_entrada0, bar0);

end hardware;