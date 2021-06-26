library IEEE;
use IEEE.std_logic_1164.all;

entity sala_de_reunioes is
  port (
    Clock:                         in std_logic;
    Reset:                         in std_logic;
    Entrou:                        in std_logic;
    Saiu:                          in std_logic;
    Cheio:                        out std_logic;
    Vazio:                        out std_logic;
    Liga_Desliga_Luz:             out std_logic;
    Liga_Desliga_Ar_Condicionado: out std_logic;
    Display_estados_0:            out std_logic_vector(6 downto 0);
    Display_estados_1:            out std_logic_vector(6 downto 0);
    Display_participantes_0:      out std_logic_vector(6 downto 0);
    Display_participantes_1:      out std_logic_vector(6 downto 0);
    dd_estados: out std_logic_vector(3 downto 0)
    -- dd_on_vazio: out std_logic;
    -- dd_off_vazio: out std_logic;
  );
end sala_de_reunioes;

architecture Estrutural of sala_de_reunioes is

  -- componentes
  component uc is
    port( 
      clock:                  in std_logic; 
      reset_uc:               in std_logic; 
      entrou_uc:              in std_logic; 
      saiu_uc:                in std_logic; 
      fd_sala_vazia:          in std_logic;
      fd_10_ou_mais:          in std_logic;
      fd_sala_cheia:          in std_logic;
      reset_counter_sub:     out std_logic;
      reset_flipflops:       out std_logic; 
      decrement_participant: out std_logic;
      enable_counter_sub:    out std_logic;
      turn_on_light:         out std_logic;
      turn_off_light:        out std_logic;
      turn_on_air:           out std_logic;
      turn_off_air:          out std_logic;
      turn_on_full:          out std_logic;
      turn_off_full:         out std_logic;
      turn_on_empty:         out std_logic;
      turn_off_empty:        out std_logic;
      estado:                out std_logic_vector(3 downto 0)
    );
  end component;

  component fd is
    port (
      decrement_participant: in std_logic;
      enable_counter_sub:    in std_logic;
      reset_counter_sub:     in std_logic;
      turn_on_full:          in std_logic;
      turn_off_full:         in std_logic;
      turn_on_empyt_led:     in std_logic;
      turn_off_empty_led:    in std_logic;
      turn_on_light:         in std_logic;
      turn_off_light:        in std_logic;
      turn_on_air:           in std_logic;
      turn_off_air:          in std_logic;
      Clock:                 in std_logic;
      reset_flipflops:       in std_logic;
      fd_10_ou_mais:        out std_logic;
      fd_cheio:             out std_logic;
      fd_vazio:             out std_logic;
      saida_luz:            out std_logic;
      saida_ar:             out std_logic;
      saida_cheio:          out std_logic;
      saida_vazio:          out std_logic;
      participantes0:       out std_logic;
      participantes1:       out std_logic;
      participantes2:       out std_logic;
      participantes3:       out std_logic
    );
  end component;

  component cond_sinais is
    port( 
      clock:        in std_logic;
      reset:        in std_logic;
      entrou:       in std_logic;
      saiu:         in std_logic;
      reset_cond:  out std_logic;
      entrou_cond: out std_logic;
      saiu_cond:   out std_logic
    );
  end component;

  component dual_seven_segment_DEO_CV is
    port(
      entrada:   in std_logic_vector(6 downto 0);
      bar1	:		out	std_logic_vector(6 downto 0);
      bar0	:		out	std_logic_vector(6 downto 0)
    );									
  end component;

signal si_reset:                 std_logic;
signal si_entrou:                std_logic;
signal si_saiu:                  std_logic;
signal si_fd_sala_vazia:         std_logic;
signal si_fd_10_ou_mais:         std_logic;
signal si_fd_sala_cheia:         std_logic;
signal si_reset_counter_sub:     std_logic;
signal si_reset_flipflops:       std_logic; 
signal si_decrement_participant: std_logic;
signal si_enable_counter_sub:    std_logic;
signal si_turn_on_light:         std_logic;
signal si_turn_off_light:        std_logic;
signal si_turn_on_air:           std_logic;
signal si_turn_off_air:          std_logic;
signal si_turn_on_full:          std_logic;
signal si_turn_off_full:         std_logic;
signal si_turn_on_empty:         std_logic;
signal si_turn_off_empty:        std_logic;
signal si_fd_cheio:              std_logic;
signal si_fd_vazio:              std_logic;
signal si_estados:               std_logic_vector(3 downto 0);
signal si_estados7:              std_logic_vector(6 downto 0);
signal si_participantes:         std_logic_vector(6 downto 0);


begin

  condicionamento_sinais: cond_sinais port map ( 
    clock       => Clock,
    reset       => Reset,
    entrou      => Entrou,
    saiu        => Saiu,
    reset_cond  => si_reset,
    entrou_cond => si_entrou,
    saiu_cond   => si_saiu
  );

  data_flow: fd port map(
      decrement_participant => si_decrement_participant,
      enable_counter_sub    => si_enable_counter_sub,
      reset_counter_sub     => si_reset_counter_sub,
      turn_on_full          => si_turn_on_full,
      turn_off_full         => si_turn_off_full,
      turn_on_empyt_led     => si_turn_on_empty,
      turn_off_empty_led    => si_turn_off_empty,
      turn_on_light         => si_turn_on_light,
      turn_off_light        => si_turn_off_light,
      turn_on_air           => si_turn_on_air,
      turn_off_air          => si_turn_off_air,
      reset_flipflops       => si_reset_flipflops,
      Clock                 => Clock,
      fd_10_ou_mais         => si_fd_10_ou_mais,
      fd_cheio              => si_fd_cheio,
      fd_vazio              => si_fd_vazio,
      saida_luz             => liga_desliga_luz,
      saida_ar              => liga_desliga_ar_condicionado,
      saida_cheio           => Cheio,
      saida_vazio           => Vazio,
      participantes0        => si_participantes(0),
      participantes1        => si_participantes(1),
      participantes2        => si_participantes(2),
      participantes3        => si_participantes(3)
  );
  control_unity: uc port map(
      clock                 => clock,
      reset_uc              => si_reset,
      entrou_uc             => si_entrou,
      saiu_uc               => si_saiu,
      fd_sala_vazia         => si_fd_vazio,
      fd_10_ou_mais         => si_fd_10_ou_mais,
      fd_sala_cheia         => si_fd_cheio,
      reset_counter_sub     => si_reset_counter_sub,
      reset_flipflops       => si_reset_flipflops,
      decrement_participant => si_decrement_participant,
      enable_counter_sub    => si_enable_counter_sub,
      turn_on_light         => si_turn_on_light,
      turn_off_light        => si_turn_off_light,
      turn_on_air           => si_turn_on_air,
      turn_off_air          => si_turn_off_air,
      turn_on_full          => si_turn_on_full,
      turn_off_full         => si_turn_off_full,
      turn_on_empty         => si_turn_on_empty,
      turn_off_empty        => si_turn_off_empty,
      estado                => si_estados
  );
  
  si_estados7(6) <= '0';
  si_estados7(5) <= '0';
  si_estados7(4) <= '0';
  si_estados7(3) <=  si_estados(3);
  si_estados7(2) <=  si_estados(2);
  si_estados7(1) <=  si_estados(1);
  si_estados7(0) <=  si_estados(0);

  si_participantes(6) <= '0';
  si_participantes(5) <= '0';
  si_participantes(4) <= '0';

  dd_estados <= si_estados;
  -- dd_on_vazio <= si_turn_on_empty;
  -- dd_off_vazio <= si_turn_off_empty;
  display_estados: dual_seven_segment_DEO_CV port map (si_estados7, Display_estados_1, Display_estados_0);
  display_participantes: dual_seven_segment_DEO_CV port map (si_participantes, Display_participantes_1, Display_participantes_0);
  
end Estrutural;