library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alu is
	port(
		operanda: in std_logic_vector(31 downto 0);
		operandb: in std_logic_vector(31 downto 0);
		Binvert: in std_logic;
		--ALUop: in std_logic_vector(1 downto 0);
		aluctrl: in std_logic_vector(3 downto 0);
		shamt: in std_logic_vector(4 downto 0);
		result: out std_logic_vector(31 downto 0));
		carryin: in std_logic;
		carryout: in std_logic;
		Zero: out std_logic
		);
end alu ;

architecture behavioural of alu is
	signal add_out, and_out, sub_out, or_out, nor_out : std_logic_vector(31 downto 0);
	signal var_carry: std_logic_vector(32 downto 0);
	signal mul_out : std_logic_vector(61 downto 0);--(5 downto 0);
	constant subone : std_logic_vector(31 downto 0):= "00000000000000000000000000000001";
begin
	var_carry(0) <= carryin;
--	add_out <= operanda + operandb;
	process(operanda,operandb,var_carry, ALUop)
	begin
	-- here I wanted to compute all the operation add, sub, or... at first scan.
	-- After, I selected the result base on aluctrl
			FOR i in 0 to 31 loop
				add_out(i)<= operanda(i) xor operandb(i)xor var_carry(i);
				var_carry(i+1)<= (operanda(i) and operandb(i)) or (var_carry(i) and(operanda(i) or operandb(i)));
				sub_out(i) <= operanda(i) xor (not(operandb(i)))xor var_carry(i);
				and_out <= operanda(i) and operandb(i);
				or_out <= operanda(i) or operandb(i);
				nor_out <= not(operanda(i)) and not(operandb(i));
			end loop;
				sub_out <= sub_out + subone;
	end process;
	
	process(ALUop, 
				--sub_out <= operanda - operandb;
				--	mul_out <= operanda * operandb;
				--and_out <= operanda AND operandb;

	with aluctrl(3 downto 0) select
		result <= add_out when "0010",
					 sub_out when "0110",
					 and_out when "0000",
					 or_out when "0001",
	
	
--	with aluctrl(3 downto 0) select
--		result <=  add_out when "00",
--					sub_out when "01",
--					mul_out(2 downto 0) when "10",
--					and_out when others;
					
end behavioural;

