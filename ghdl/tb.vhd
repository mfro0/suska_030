-------------------------------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.utils.memarray;
use work.utils.hdump;
use work.utils.stackdisplay;
use std.textio.all;


entity tb is
end entity tb;

architecture sim of tb is
    signal clk_25               : std_ulogic := '1';

    --
    -- convert a byte-organised array into a longword-organised
    -- one.
    function to32(a : work.m68k_rom.ubyte_array) return memarray is
        variable res : memarray(0 to (a'length + 4) / 4)(31 downto 0);
        variable last32 : std_ulogic_vector(31 downto 0);
        constant rest : natural := a'length mod 4;
    begin
        for i in 0 to res'length - 3 loop
            res(i) := a(4 * i + 0) & a(4 * i + 1) & a(4 * i + 2) & a(4 * i + 3);
        end loop;

        last32 := (others => '0');
        for i in rest to rest + 3 loop
            last32 := last32 or std_ulogic_vector(resize(shift_left(unsigned(a(i * 8)), i mod 4), 32));
        end loop;

        res(res'length - 1) := last32;

        return res;
    end function to32;


    -- 64K of 32 bit memory
    signal memory               : memarray(0 to 10240 - 1)(31 downto 0) :=
    (
        0 to (work.m68k_rom.m68k_binary'length + 4) / 4 => to32(work.m68k_rom.m68k_binary),
        others => (others => '0')
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
    signal sp                   : std_ulogic_vector(31 downto 0);
    signal counter25            : std_ulogic_vector(31 downto 0) := (others => '0');

    signal stack                : stackdisplay := (others => (others => '0'));

    --
    -- Build a small array around memory the stack pointer points to.
    -- This enables waveform viewers to display stack and memory around
    -- (-5 to +5 long words below and above where s points to)
    --
    procedure stack_viewer(signal s : in std_logic_vector(31 downto 0);
                           signal mem : in memarray;
                           signal sd : out stackdisplay) is
    begin
        if not is_x(s) then             -- only if we have a valid stack pointer
            for i in sd'low to sd'high loop
                -- do a sanity check to avoid bailout when stackpointer is
                -- uninitialised during core startup
                if unsigned(sp) / 4 > mem'low + d"5" and unsigned(sp) / 4 < mem'high - d"5"  then
                    sd(i) <= mem(to_integer(unsigned(s)) / 4 + i);
                end if;
            end loop;
        end if;
    end procedure stack_viewer;

    --
    -- this is a trivial stupid copy of table 12-1
    -- from the MC68030 User's manual
    --
    function byteselect(mem_in : in std_ulogic_vector(31 downto 0);
                        s_n : in std_ulogic_vector(1 downto 0);
                        bs : in std_ulogic_vector(1 downto 0);
                        dout : in std_ulogic_vector(31 downto 0)) return std_ulogic_vector is
        variable mem : std_ulogic_vector(mem_in'range);
    begin
        mem := mem_in;
        case s_n is
            when "01" => -- byte size
                case bs is  -- select byte in long
                    when "00" =>
                        mem(31 downto 24) := dout(31 downto 24);
                    when "01" =>
                        mem(23 downto 16) := dout(23 downto 16);
                    when "10" =>
                        mem(15 downto 8) := dout(15 downto 8);
                    when "11" =>
                        mem(7 downto 0) := dout(7 downto 0);
                    when others =>
                        null;
                end case;

            when "10" =>
                case bs is -- select word in long
                    when "00" =>
                        mem(31 downto 16) := dout(31 downto 16);
                    when "01" =>
                        mem(23 downto 8) := dout(23 downto 8);
                    when "10" =>
                        mem(15 downto 0) := dout(15 downto 0);
                    when "11" =>
                        mem(7 downto 0) := dout(7 downto 0);
                    when others =>
                        null;
                end case;

            when "11" =>
                case bs is -- select three bytes in long
                    when "00" =>
                        mem(31 downto 8) := dout(31 downto 8);
                    when "01" =>
                        mem(23 downto 0) := dout(23 downto 0);
                    when "10" =>
                        mem(15 downto 0) := dout(15 downto 0);
                    when "11" =>
                        mem(7 downto 0) := dout(7 downto 0);
                    when others =>
                        null;
                end case;

            when "00" =>
                case bs is -- select appropriate part of long word
                    when "00" =>
                        mem(31 downto 0) := dout(31 downto 0);
                    when "01" =>
                        mem(23 downto 0) := dout(23 downto 0);
                    when "10" =>
                        mem(15 downto 0) := dout(15 downto 0);
                    when "11" =>
                        mem(7 downto 0) := dout(7 downto 0);
                    when others =>
                        null;
                end case;
            when others =>
                null;
        end case;

        return mem;
    end function byteselect;
begin

    reset_n <= '0', '1' after 520 * 40 ns;
    halt_n <= '0', '1' after 520 * 40 ns;

    p_crash : process(all)
    begin
        if berr_n = '0' then
            report "Bus error accessing " & to_hstring(adr_out) & ". Halt and catch fire!" severity error;
            std.env.stop(0);
        end if;
    end process p_crash;

    p_clkit : process(all)
        variable presc : unsigned(31 downto 0) := (others => '0');
    begin
        presc := presc + 1;
        if presc = x"100" then
            presc := (others => '0');
            counter25 <= std_ulogic_vector(unsigned(counter25) + 1);
        else
            presc := presc + 1;
        end if;

        clk_25 <= not clk_25 after 40 ns;  -- 25 MHz
    end process p_clkit;

    -- external names not (yet) working in ghdl
    -- stack_viewer(<<signal .i_m68030.i_addressregisters.isp_reg : std_logic_vector(31 downto 0)>>, stack);
    stack_viewer(sp, memory, stack);

    p_read : process(all)
        variable adr : integer;
        variable cs  : string(1 to 1);
        variable l   : line;
    begin
        --if rising_edge(clk_25) then
            dsack_n <= (others => 'Z');

            if as_n = '0' then
                if adr_out = x"fffffff0" then
                    if rw_n = '1' then      -- read cycle
                        -- UART status register, ready when = '1'
                        -- pretend we are always ready in simulation
                        data_in <= x"00000001";
                        dsack_n <= (others => '0');
                    end if;
                elsif adr_out = x"fffffff4" then
                    -- UART output register
                    if rw_n = '0' then                      -- write cycle
                        if dben_n = '0' then
                            cs(1) := character'val(to_integer(unsigned(data_out(7 downto 0))));
                            if cs(1) = CR then
                                -- we only pass the CR through
                                writeline(OUTPUT, l);
                            else
                                write(l, cs);
                            end if;
                            dsack_n <= (others => '0');
                            --report l.all severity note;
                        end if;
                    end if;
                elsif adr_out = x"fffffff8" then
                    -- simple timer
                    if rw_n = '1' then      -- read cycle
                        -- return the current value of our 25 MHz counter
                        data_in <= counter25;
                        dsack_n <= (others => '0');
                    end if;
                elsif unsigned(adr_out) / 4 >= to_unsigned(memory'low, 32) and
                      unsigned(adr_out) / 4 <= to_unsigned(memory'high, 32) then
                    adr := to_integer(unsigned(adr_out)) / 4;

                    if rw_n = '1' then
                        if dben_n = '0' then
                            data_in <= memory(adr);
                        end if;
                    else        -- write to memory
                        --if dben_n = '0' then
                            memory(adr) <= byteselect(memory(adr), size_n, adr_out(1 downto 0), data_out);
                            -- report to_hstring(adr_out) & "=" & to_hstring(byteselect(memory(adr), size_n, adr_out(1 downto 0), data_out)) severity note;
                            -- memory(adr) <= data_out;
                        --end if;
                    end if;
                    dsack_n <= (others => '0');           -- indicate 32 bit port size
                    --dsack_n <= size_n;
                elsif reset_n = '1' and dben_n = '0' then
                    berr_n <= '0';
                end if;
            end if;
        --end if;
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

            -- status controls
            STATUSn             => status_n,
            REFILLn             => refill_n,

            -- bus arbitration control
            BRn                 => br_n,
            BGn                 => bg_n,
            BGACKn              => bgack_n,

            -- debugging
            sp                  => sp
        );
end architecture sim;

