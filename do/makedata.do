// Get data files set up for analysis

// Create blended data
use "${dir}/data/constructed/sp-combined.dta" ///
  /// if case == 1 | case == 9 ///
  , clear

  keep if case < 5

  replace fid = pid if pid != ""

  encode fid , gen(uid)
    lab var uid "Unique ID"

  iecodebook export ///
  using "${dir}/data/constructed/sp-all.xlsx" ///
    , save sign reset replace

// End
