library IEEE;
use IEEE.std_logic_1164.all;

entity uc is
  port( 
    clock:                  in std_logic; -- clock
    reset_uc:               in std_logic; -- entradas do usuário
    entrou_uc:              in std_logic; -- entrada do sensor
    saiu_uc:                in std_logic; -- entrada do sensor
    -- entrada do fluxo de dados
    fd_sala_vazia:          in std_logic; -- entrada do fd
    fd_10_ou_mais:          in std_logic; -- entrada do fd
    fd_sala_cheia:          in std_logic; -- entrada do fd
    -- saidas para o fluxo de dados
    reset_counter_sub:     out std_logic; -- reset assíncrono do contador/subtrator
    reset_flipflops:       out std_logic; -- reset assíncrono do flipflop
    decrement_participant: out std_logic; -- configura o funcionamento do contador. Quando 0 -> incrementa. Quando 1 -> decrementa
    enable_counter_sub:    out std_logic; -- a saída é uma borda de subida para contar ou subtrair o contador
    turn_on_light:         out std_logic; -- liga o interruptor da luz
    turn_off_light:        out std_logic; -- desliga o interruptor da luz
    turn_on_air:           out std_logic; -- liga o interruptor do ar condicionado
    turn_off_air:          out std_logic; -- desliga o interruptor do ar condicionado
    turn_on_full:          out std_logic; -- liga o interruptor do led de sala cheia
    turn_off_full:         out std_logic; -- desliga o interruptor do led de sala cheia
    turn_on_empty:         out std_logic; -- liga o interruptor do led de sala vazia
    turn_off_empty:        out std_logic; -- desliga o interruptor do led de sala vazia
    -- saida para depuração
    estado:                out std_logic_vector(3 downto 0) 
  );
end uc;

architecture comportamental of uc is

  type Tipo_estado is (aguarda_reset, reset, espera, liga_luz_desliga_led_sala_vazia, incrementa, pos_incrementa,
                      liga_led_sala_cheia, liga_ar, desliga_led_sala_cheia, troca_func_contador, decrementa,
                      pos_decrementa, desliga_ar, desliga_luz_liga_led_sala_vazia, liga_led_sala_vazia);
  signal Eatual, Eprox: Tipo_estado;

 
begin
  
  process(clock)
  begin
    if rising_edge(clock) then
      Eatual <= Eprox;
    end if;
  end process;

  -- estados
  process(fd_sala_vazia, fd_10_ou_mais, fd_sala_cheia, Eatual, saiu_uc, reset_uc, entrou_uc)
  begin 
    case Eatual is

      when aguarda_reset => if reset_uc = '1' then
                              Eprox <= reset;
                            else
                              Eprox <= aguarda_reset;
                            end if;

      when reset => Eprox <= liga_led_sala_vazia;

      when liga_led_sala_vazia => Eprox <= espera;

      when espera =>  if saiu_uc = '1' and fd_sala_vazia = '1' then
                        Eprox <= espera;
                      elsif saiu_uc = '1' and fd_sala_vazia = '0' and fd_sala_cheia = '1' then
                        Eprox <= desliga_led_sala_cheia;
                      elsif saiu_uc = '1' and fd_sala_vazia = '0' and fd_sala_cheia = '0' then
                        Eprox <= troca_func_contador;
                      elsif saiu_uc = '0' and fd_sala_cheia = '0' and entrou_uc = '1' and fd_sala_vazia = '1' then
                        Eprox <= liga_luz_desliga_led_sala_vazia;
                      elsif saiu_uc = '0' and fd_sala_cheia = '0' and entrou_uc = '1' and fd_sala_vazia = '0' then
                        Eprox <= incrementa;
                      else
                        Eprox <= espera;
                      end if;
                      
      when desliga_led_sala_cheia => Eprox <= troca_func_contador;
      
      when troca_func_contador => Eprox <= decrementa;
      
      when decrementa => Eprox <= pos_decrementa;
      
      when pos_decrementa =>  if fd_10_ou_mais = '0' then
                                Eprox <= desliga_ar;
                              else
                                Eprox <= espera;
                              end if;

      when desliga_ar =>  if fd_sala_vazia = '1' then
                            Eprox <= desliga_luz_liga_led_sala_vazia;
                          else
                            Eprox <= espera;
                          end if;

      when desliga_luz_liga_led_sala_vazia => Eprox <= espera;

      when liga_luz_desliga_led_sala_vazia => Eprox <= incrementa;
      
      when incrementa => Eprox <= pos_incrementa;

      when pos_incrementa =>  if fd_sala_cheia = '1' then
                                Eprox <= liga_led_sala_cheia;                          
                              elsif fd_sala_cheia = '0' and fd_10_ou_mais = '1' then
                                Eprox <= liga_ar;
                              else
                                Eprox <= espera;
                              end if;
                              
      when liga_led_sala_cheia => Eprox <= espera;

      when liga_ar =>  eprox <= espera;
                            
      when others =>  Eprox <= espera;
      
    end case;
  end process;

  -- CONTROLE FLIPFLOPS
  with Eatual select
    reset_flipflops <= '1' when reset,
                       '0' when others;
  -- CONTROLE CONTADOR/SUBTRATOR
  with Eatual select
    reset_counter_sub <= '1' when reset,
                         '0' when others;
  with Eatual select
    decrement_participant <= '1' when troca_func_contador,
                             '1' when decrementa,
                             '0' when others;
  with Eatual select
    enable_counter_sub <= '1' when decrementa,
                          '1' when incrementa,
                          '0' when others;
  -- CONTROLE AR CONDICIONADO                                
  with Eatual select
    turn_off_air <= '1' when desliga_ar,
                    '0' when others;
  with Eatual select
    turn_on_air <= '1' when liga_ar,
                   '0' when others;
  -- CONTROLE LUZ
  with Eatual select
    turn_on_light <= '1' when liga_luz_desliga_led_sala_vazia,
                     '0' when others;                    
  with Eatual select
    turn_off_light <= '1' when desliga_luz_liga_led_sala_vazia,
                      '0' when others;
  -- CONTROLE SALA VAZIA
  with Eatual select
    turn_on_empty <= '1' when desliga_luz_liga_led_sala_vazia,
                     '1' when liga_led_sala_vazia,
                     '0' when others;
  with Eatual select
    turn_off_empty <= '1' when liga_luz_desliga_led_sala_vazia,
                      '0' when others;
  -- CONTROLE SALA CHEIA
  with Eatual select
    turn_on_full <= '1' when liga_led_sala_cheia,
                    '0' when others;
  with Eatual select
    turn_off_full <= '1' when desliga_led_sala_cheia,
                     '0' when others;
  -- CODIFICAÇÃO ESTADOS
  with Eatual select
    estado <= "0000" when aguarda_reset,
              "0001" when reset,
              "0010" when liga_led_sala_vazia,
              "0011" when espera,
              "0100" when liga_luz_desliga_led_sala_vazia,
              "0101" when incrementa,
              "0110" when pos_incrementa,
              "0111" when liga_led_sala_cheia,
              "1000" when liga_ar,
              "1001" when desliga_led_sala_cheia,
              "1010" when troca_func_contador,
              "1011" when decrementa,
              "1100" when pos_decrementa,
              "1101" when desliga_ar,
              "1110" when desliga_luz_liga_led_sala_vazia;

end comportamental;                           