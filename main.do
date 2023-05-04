// Setup

global box "/Users/bbdaniels/Library/CloudStorage/Box-Box"
global dir "/Users/bbdaniels/GitHub/covet-tb-india"
ieboilstart, v(16.1) adopath("${dir}/ado" , strict)

// Install ado-files

  ssc install iefieldkit
  net install grc1leg, from("http://www.stata.com/users/vwiggins")

  net from https://github.com/bbdaniels/stata/raw/main/
    net install labelcollapse
    net install betterbar
    net install sumstats
    net install outwrite
    net install forest

// Graph scheming

  copy "https://github.com/graykimbrough/uncluttered-stata-graphs/raw/master/schemes/scheme-uncluttered.scheme" ///
    "${dir}/ado/scheme-uncluttered.scheme" , replace

  set scheme uncluttered , perm
  graph set eps fontface "Helvetica"

// Globals

  global pct 0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%"
  global pct75 0 "0%" .25 "25%" .5 "50%" .75 "75%"
  global pct20 0 "0%" .05 "5%" .1 "10%" .15 "15%" .2 "20%"
  global hist_opts ylab(, format(%9.0f) angle(0) axis(2)) yscale(noline alt axis(2)) ytit("Frequency (Histogram)", axis(2)) ytit(, axis(1)) yscale(alt)

// Get raw data

  iecodebook export ///
   "${box}/_Papers/SP Mumbai/data/raw/mumbai-sp.dta" ///
  using "${dir}/data/raw/mumbai.xlsx" ///
    , save sign reset replace

  iecodebook export ///
   "${box}/_Papers/SP Patna/data/raw/patna-sp.dta" ///
  using "${dir}/data/raw/patna.xlsx" ///
    , save sign reset replace

  iecodebook append ///
    "${dir}/data/raw/patna.dta" ///
    "${dir}/data/raw/mumbai.dta" ///
  using "${dir}/do/sp-combined.xlsx" ///
  , gen(city) surveys(Patna Mumbai) clear

    iecodebook export ///
    using "${dir}/data/constructed/sp-combined.xlsx" ///
      , save sign reset replace

// Run sub-files
-
  do "${dir}/do/makedata.do"
  do "${dir}/do/figures.do"
  do "${dir}/do/tables.do"

//
