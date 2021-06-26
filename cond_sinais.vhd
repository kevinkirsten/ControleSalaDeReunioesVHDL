library IEEE;
use IEEE.std_logic_1164.all;

entity cond_sinais is
  port( 
    clock:        in std_logic; -- entrada de clock
    reset:        in std_logic; -- entrada de sinal a ser condicionado
    entrou:       in std_logic; -- entrada de sinal a ser condicionado
    saiu:         in std_logic; -- entrada de sinal a ser condicionado
    reset_cond:  out std_logic; -- saída de sinal condicionado
    entrou_cond: out std_logic; -- saída de sinal condicionado
    saiu_cond:   out std_logic  -- saída de sinal condicionado
  );
end cond_sinais;

architecture comportamental of cond_sinais is

  signal entrou_s, saiu_s, reset_s: std_logic := '0';
  signal entrou_s_aux, saiu_s_aux, reset_s_aux: std_logic := '0';

begin

  process(clock)
  begin
    if rising_edge(clock) and reset = '1' and reset_s_aux = '0' then
      reset_cond <= '1';
      reset_s_aux <= '1';
    elsif rising_edge(clock) and reset = '1' and reset_s_aux = '1' then
      reset_cond <= '0';
    elsif rising_edge(clock) and reset = '0' and reset_s_aux = '1' then
      reset_s_aux <= '0';

    elsif rising_edge(clock) and entrou = '1' and entrou_s_aux = '0' then
      entrou_cond <= '1';
      entrou_s_aux <= '1';
    elsif rising_edge(clock) and entrou = '1' and entrou_s_aux = '1' then
      entrou_cond <= '0';
    elsif rising_edge(clock) and entrou = '0' and entrou_s_aux = '1' then
      entrou_s_aux <= '0';

    elsif rising_edge(clock) and saiu = '1' and saiu_s_aux = '0' then
      saiu_cond <= '1';
      saiu_s_aux <= '1';
    elsif rising_edge(clock) and saiu = '1' and saiu_s_aux = '1' then
      saiu_cond <= '0';
    elsif rising_edge(clock) and saiu = '0' and saiu_s_aux = '1' then
      saiu_s_aux <= '0';
    end if;
  end process;

end comportamental;