library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rotater_tb is
end rotater_tb;

architecture tb of rotater_tb is
    component rotater is
        port (
            d    : in std_logic_vector(3 downto 0);
            k    : in std_logic_vector(1 downto 0);
            ld   : in std_logic;
            lk   : in std_logic;
            clk  : in std_logic;
            v    : out std_logic_vector(3 downto 0);
            busy : out std_logic;
            done : out std_logic);
    end component rotater;

    signal d : std_logic_vector(3 downto 0) := "1001";
    signal k : std_logic_vector(1 downto 0) := "10";

    constant seq_length : integer := 10;
    signal ld, lk : std_logic := '0';
    signal ld_seq : std_logic_vector (0 to (seq_length - 1)) := "0100000000";
    signal lk_seq : std_logic_vector (0 to (seq_length - 1)) := "0010000000";

    constant clk_period : time := 2 ns;
    signal clk : std_logic := '1';

    signal v : std_logic_vector(3 downto 0);
    signal busy : std_logic;
    signal done : std_logic;

    signal seq_idx : integer := 0;
    signal sim_finish : std_logic;
begin
    clk <= not clk after clk_period/2;
    sim_finish <= '1' when (seq_idx = seq_length) else '0';
    rotater_inst : rotater port map(d, k, ld, lk, clk, v, busy, done);

    process (clk) begin
        if rising_edge(clk) then
            if (seq_idx < seq_length) then
                ld <= ld_seq(seq_idx);
                lk <= lk_seq(seq_idx);
                seq_idx <= seq_idx + 1;
            end if;
            if (seq_idx = seq_length) then
                std.env.finish;
            end if;
        end if;
    end process;

end tb;

