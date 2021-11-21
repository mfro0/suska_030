library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.utils.all;

entity tb is
end entity tb;

architecture sim of tb is
    signal clk_25               : std_ulogic := '1';

    type mem_array is array(natural range <>) of std_ulogic_vector(31 downto 0);
    constant memstart           : mem_array :=
    (
        -- initial PC
        std_ulogic_vector(unsigned'(x"00000010")),
        -- initial SP
        std_ulogic_vector(unsigned'(x"00000080"))
    ); 

    signal memory               : mem_array(0 to 100) := 
    (
        -- set initial PC and initial SP in memory
        0 to 1 => memstart(0 to 1),
        others => std_ulogic_vector(unsigned'(x"4e714e71"))
    );

    signal adr_out              : std_ulogic_vector(31 downto 0);

    signal data_in,
           data_out             : std_ulogic_vector(31 downto 0);
    signal data_en              : std_ulogic;

    signal berr_n,
           reset_n,
           reset_n_out,
           halt_n,
           halt_n_out,
           avec_n,
           as_n,
           rw_n,
           rmc_n,
           ds_n,
           ecs_n,
           ocs_n,
           dben_n,
           bus_en,
           sterm_n,
           status_n,
           refill_n,
           br_n,
           bg_n,
           bgack_n              : std_ulogic;
    signal ipl_n                : std_ulogic_vector(2 downto 0);
    signal fc_n                 : std_ulogic_vector(2 downto 0);
    signal dsack_n              : std_ulogic_vector(1 downto 0);
    signal ipend_n              : std_ulogic;
    signal size_n               : std_ulogic_vector(1 downto 0);
        
begin

    reset_n <= '0', '1' after 520 * 40 ns;
    halt_n <= '0', '1' after 520 * 40 ns;

    p_clkit : process(all)
    begin
        clk_25 <= not clk_25 after 40 ns;  -- 25 MHz
    end process p_clkit;

    p_read : process(all)
        variable adr : integer;
    begin
        adr := to_integer(unsigned(adr_out)) / 4;
        
        if rising_edge(clk_25) then
            if rw_n = '1' then
                if adr >= memory'low and adr <= memory'high then
                    data_in <= memory(adr);
                end if;
            end if;
        end if;
    end process p_read;

    i_m68030 : entity work.wf68k30l_top
        port map
        (
            CLK                 => clk_25,

            -- address and data
            adr_out             => adr_out,
            data_in             => data_in,
            data_out            => data_out,
            data_en             => data_en,

            -- system control
            BERRn               => berr_n,
            RESET_INn           => reset_n,
            RESET_OUT           => reset_n_out,
            HALT_INn            => halt_n,
            HALT_OUTn           => halt_n_out,

            -- processor status
            FC_OUT              => fc_n,

            -- interrupt control
            AVECn               => avec_n,
            IPLn                => ipl_n,
            IPENDn              => ipend_n,

            -- asynchronous bus control
            DSACKn              => dsack_n,
            SIZE                => size_n,
            ASn                 => as_n,
            RWn                 => rw_n,
            RMCn                => rmc_n,
            DSn                 => ds_n,
            ECSn                => ecs_n,
            OCSn                => ocs_n,
            DBENn               => dben_n,
            BUS_en              => bus_en,

            -- synchronous bus control
            STERMn              => sterm_n,

            -- stauts controls
            STATUSn             => status_n,
            REFILLn             => refill_n,

            -- bus arbitration control
            BRn                 => br_n,
            BGn                 => bg_n,
            BGACKn              => bgack_n
        );
end architecture sim;
