library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;   
use work.p_MI0.all;

entity maq_estado_flush is

	port (clk, reset, ID_salto, EX_salto, EX_desviou:	in	std_logic;
		  EX_acha_desvia:								in	std_logic_vector(1 downto 0);
		  ID_acha_desvia:								out	std_logic_vector(1 downto 0);
		  IF_flush:										out	std_logic_vector(1 downto 0)
		 );

end maq_estado_flush;

--input: clk, reset, ID_salto, EX_salto, EX_desviou, EX_acha_desvia;
--output: ID_acha_desvia, IF_flush;

architecture arq_maq_estado_flush of maq_estado_flush is

signal estado: std_logic_vector(1 downto 0); -- signal que guarda  estado atual. Precisa começar resetado

begin

	process(clk) -- maq. de estados
	begin
	
		if rising_edge(clk) then
			if reset = '1' then
				estado	<=	"00";
			else
				if EX_salto = '1' then -- subida do clock e salto no EX. O prox. estado muda em relação ao anterior e se desviou ou nao
					case estado is
						when "00" =>
							if EX_desviou = '0' then
								estado <= "01";
							else
								estado <= "00";
							end if;
						when "01" =>
							if EX_desviou = '0' then
								estado <= "10";
							else
								estado <= "00";
							end if;
						when "10" =>
							if EX_desviou = '0' then
								estado <= "10";
							else
								estado <= "11";
							end if;
						when others =>
							if EX_desviou = '0' then
								estado <= "10";
							else
								estado <= "00";
		                    end if;
						end case;
				end if;
			end if;																					-- previsao de desvio
-------------------------------------------------------------------------------------------------------------------------------------------
			if ID_salto = '1' then -- Aqui jaz o "chute", no ID
				if ((estado = "00") or (estado = "01")) then
					ID_acha_desvia <= "01"; -- Preve que desvia
				else if ((estado = "10") or (estado = "11")) then
						 ID_acha_desvia <= "10"; -- Preve que nao desvia
					 end if;
				end if;
			else
				ID_acha_desvia <= "00"; -- Nao se aplica
			end if;																					-- detecçao de flush
--------------------------------------------------------------------------------------------------------------------------------------------
			if EX_salto = '1' then -- subida do clk e branch no EX. O "chute" eh feito no ID e confirmado no EX
				if ((EX_acha_desvia = "01") and (EX_desviou = '0')) then
					IF_flush <= "01"; -- Preveu errado, nao deveria desviar
				else if ((EX_acha_desvia = "10") and (EX_desviou = '1')) then
						 IF_flush <= "10"; -- Preveu errado, deveria desviar
					 end if;
				end if;
			else
				IF_flush <= "00"; -- Preveu certo
			end if;
		end if;
	
	end process;

end arq_maq_estado_flush;
