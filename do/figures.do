// Figures for SP Covet Paper

// Figure 1




// Figure 2

use "${dir}/data/constructed/sp-covet.dta" , clear

  tw ///
    (lowess correct pre_correct if city == 1 , lc(black) lw(thick)) ///
    (lowess checklist pre_correct  if city == 1 , lc(black) lw(thick) lp(dash)) ///
    (lowess correct pre_correct if city == 2 , lc(navy) lw(thick)) ///
    (lowess checklist pre_correct  if city == 2 , lc(navy) lw(thick) lp(dash)) ///
  , legend(on pos(12) c(3) ///
           order(0 "Patna:" 1 "Correct" 2 "Checklist" 0 "Mumbai:" 3 "Correct" 4 "Checklist"))






// End
