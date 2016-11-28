library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.p_MI0.all;

entity pc_back is
       	   	port(
       	   		reset:			in	std_logic;
       	   		clk:			in	std_logic;
       	   		IF_pc:			in	reg32;
       	   		IF_flush:		in	std_logic_vector(1 downto 0);
				ID_btgt:		in	reg32;
				ID_acha_desvia:	in	std_logic_vector(1 downto 0);
				EX_btgt:		in	reg32;
				EX_pc4:			in	reg32;
				IF_pc_next:		out reg32;
				IF_pc4:			out reg32
           		);
end pc_back;

--input: clk, IF_pc, IF_flush, ID_btgt, ID_acha_desvia, EX_btgt, EX_pc4;
--output: IF_pc_next, IF_pc4;

architecture pc_back_arq of pc_back is 

signal pc4: reg32; -- auxiliar

begin

	process
	begin
			wait until rising_edge(clk);
			pc4			<=	IF_pc + x"00000004";
			IF_pc4 <= pc4;
			if IF_flush = "01" then -- caso erro de previsao no EX
				IF_pc_next <= EX_pc4;
			else if IF_flush = "10" then
					 IF_pc_next	<= EX_btgt;
				 else if ID_acha_desvia = "01" then -- caso previsao de branch no ID
				 	 	 IF_pc_next <= ID_btgt;
				 	  else
						 IF_pc_next <= pc4; -- caso nao eh salto ou preve que nao desvia
				 	  end if;
				 end if;
			end if;

	end process;
end pc_back_arq;
