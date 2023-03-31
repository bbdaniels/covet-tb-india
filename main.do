// Setup

global box "/Users/bbdaniels/Library/CloudStorage/Box-Box"
global dir "/Users/bbdaniels/GitHub/covet-tb-india"
ieboilstart, v(16.1) adopath("${dir}/ado" , strict)

// Install ado-files

  ssc install iefieldkit

  net from https://github.com/bbdaniels/stata/raw/main/
    net install labelcollapse

// Graph scheming

  copy "https://github.com/graykimbrough/uncluttered-stata-graphs/raw/master/schemes/scheme-uncluttered.scheme" ///
    "${dir}/scheme-uncluttered.scheme" , replace

  sysdir set PERSONAL "${dir}/"
  set scheme uncluttered , perm
  graph set eps fontface "Helvetica"

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



//
