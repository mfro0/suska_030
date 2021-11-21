library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.utils.memarray;
use work.utils.hdump;
use std.textio.all;

entity tb is
end entity tb;

architecture sim of tb is
    signal clk_25               : std_ulogic := '1';

    function to32(a : work.m68k_rom.ubyte_array) return memarray is
        variable res : memarray(0 to (a'length + 4) / 4)(31 downto 0);
        variable last32 : std_ulogic_vector(31 downto 0);
    begin
        for i in 0 to res'length - 3 loop
            res(i) := a(4 * i + 0) & a(4 * i + 1) & a(4 * i + 2) & a(4 * i + 3);
        end loop;
        last32 := (others => '0');
        for i in a'length mod 4 to 3 loop
            last32 := last32 or std_ulogic_vector(resize(shift_left(unsigned(a(i * 8)), i mod 4), 32));
        end loop;

        res(res'length - 1) := last32;

        return res;
    end function to32;

    signal memory               : memarray(0 to 100)(31 downto 0) := 
    (
        0 to (work.m68k_rom.m68k_binary'length + 3) / 4 => to32(work.m68k_rom.m68k_binary),
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
        dsack_n <= (others => 'Z');
        adr := to_integer(unsigned(adr_out)) / 4;
        
        if rising_edge(clk_25) then
            if rw_n = '1' then
                if adr >= memory'low and adr <= memory'high then
                    data_in <= memory(adr);
                    dsack_n <= (others => '0');           -- indicate 32 bit port size
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
