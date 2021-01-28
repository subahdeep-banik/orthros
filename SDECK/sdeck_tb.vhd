-------------------------------------------------------------------------------
-- Project    : 
-------------------------------------------------------------------------------
 
-- Author     : Subhadeep Banik  
 
-- Platform   : ModelSim (simulation), Synopsys (synthesis)
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
 
-------------------------------------------------------------------------------
 
-------------------------------------------------------------------------------
 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
--use work.aes_pack.all;

entity sdeck_tb is
end sdeck_tb;


architecture tb of sdeck_tb is   

 
 signal   InxD      : std_logic_vector (127 downto 0);
 signal   KeyxD      : std_logic_vector (127 downto 0);
 
 signal   OutxD     : std_logic_vector (127 downto 0);

 

  signal ClkxC : std_logic;                    -- driving clock
    




  component sdeck
  port(
        InxDI     : in  std_logic_vector(127 downto 0);
        KeyxDI    : in  std_logic_vector(127 downto 0);
        OutxDO    : out std_logic_vector(127 downto 0);
        ClkxCI    : in  std_logic
  );
  end component;
       


   
begin

  -- Instantiate the module under test (MUT)
  mut: sdeck
    port map (
      InxDI     => InxD,
      KeyxDI    => KeyxD, 
      OutxDO    => OutxD,
      ClkxCI    => ClkxC
  );

  -- Generate the clock
--  ClkxC <= not (ClkxC) after clkphasehigh;


  Tb_clkgen : process
  begin
     ClkxC <= '1';
     wait for 50 ns;
     ClkxC <= '0';
     wait for 50 ns;
  end process Tb_clkgen;

  -- obtain stimulus and apply it to MUT
  ----------------------------------------------------------------------------
  B1 : block
   begin


  -- timing of clock and simulation events
 


  Tb_stimappli : process
    variable INLine   : line;
    variable temp_d   : STD_LOGIC_VECTOR(127 downto 0);
    variable temp_i   : STD_LOGIC_VECTOR(127 downto 0); 
    variable temp_t   : STD_LOGIC_VECTOR(127 downto 0); 
    variable temp_w   : STD_LOGIC_VECTOR(127 downto 0); 
     constant clkphasehigh: time:= 50 ns;
  constant clkphaselow: time:= 50 ns;
  constant responseacquisitiontime: time:= 75 ns;
  constant stimulusapplicationtime: time:= 25 ns;
  constant resetactivetime:         time:= 25 ns;


  file tfile,keyfile,ptfile ,wfile: TEXT;



  begin
    -- Opening Input File
    file_open(keyfile, "Key.txt", read_mode);
    file_open(ptfile, "PT.txt", read_mode);
 
    
    -- default values



    -- process until we run out of stimuli
    appli_loop : while not (endfile(keyfile)) loop
      readline(keyfile,INLine);
      hread(INLine,temp_d);
      KeyxD <= temp_d;
      
      readline(ptfile,INLine);
      hread(INLine,temp_i);
      InxD <= temp_i;
       
    wait for 2*clkphasehigh;

    end loop appli_loop;
    wait until ClkxC'event and ClkxC = '1';
    file_close(keyfile);
    wait;
  end process Tb_stimappli;
end block;
end tb;


