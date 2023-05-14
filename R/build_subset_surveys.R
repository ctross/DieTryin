#' Build photo-roster subset surveys (e.g., for RICH-PGG games.)
#' 
#' This is a wraper function to create suveys (PDFs) to collect data for RICH-PGG contributions and similar games.
#'
#' @param path Path to RICH folder.
#' @param pid ID code of focal recipient.
#' @param id_set IDs of alter recipients (as vector).
#' @param game_name Used to label PDF surveys.
#' @param entry_type Pull from all files in SubsetData folder using: "random", "choice", or "predefined". 
#'  If entry_type is "random", all alters will be selected randomly, in such a way as to fairly balance the number of games 
#'  in which each alter appears.
#'  If entry_type is "choice", then alters will be defined as in the partner-choice game data.
#'  If entry_type is "predefined", then a specific "pid" and "id_set" can be added to the inputs in order to build a 
#'  single PDF file with a specific predefined set of alters file. This can be used, for example, if the researcher wants
#'  to manipulate the roster to feature alters with specific characteristics.
#' @param set_size Size of set of possible alters.
#' @param token_color Number or "color" of tokens placed. If data was entered manually, place whatever value was stored 
#'  to indiciate a tie: "1"
#' @param full_alter_set Include all alters on roster, or only those who played first round of game?
#' @param pattern Should "JPG" be "jpg" file endings be used to load photos?
#' @param height Size of PDF output.
#' @param width Size of PDF output.
#' @param seed Number to use in seeding the randomization process if used.
#' @param gid_size Number of characters in hashcodes for the game IDs.
#' @param max_iter Max time to search for full-scope legal permutations. In random mode, we seek to ensure that each
#'  alter appears in exactly the same number of games. Thus, we iterate randomizations until we find such a set. 
#' @return A file folder, SubsetSurveys, filled with PDFs of sub-surveys to run, and a second folder, SubsetContributions, 
#'  filled with CSV files that will be used to record survey results.
#' @export
#' @examples
#' \dontrun{
#' build_subset_surveys(path, pattern = ".jpg", token_color="navyblue", full_alter_set = TRUE,
#'                       entry_type="random", max_iter=10000, set_size=4, 
#'                       height=8.5, width=11, seed=123, gid_size=4)
#' }
#'

build_subset_surveys = function (path, pid=NULL, id_set=NULL, game_name="Choice", entry_type="random", set_size=4, 
                                    pattern = ".jpg", token_color="navyblue",  max_iter=10000, full_alter_set = TRUE,
                                    height=8.5, width=11, seed=NA, gid_size=4){

  ################################################################## Build Selection
  if(entry_type=="choice"){
   subset_survey_compiler_partner_choice(path=path, token_color=token_color, game_name=game_name, set_size=set_size, 
                                         height=height, width=width, pattern = pattern, seed=seed, gid_size=gid_size)
   }
 
  ################################################################## Build Random
  else if(entry_type=="random"){
   subset_survey_compiler_random(path=path, token_color=token_color, game_name=game_name, max_iter=max_iter, set_size=set_size, 
                                 full_alter_set = full_alter_set, height=height, width=width, pattern = pattern, seed=seed, 
                                 gid_size=gid_size)     
   }

  ################################################################## Build Selection
  else if(entry_type=="predefined"){
   subset_survey_compiler_predefined(path=path, pid = pid, id_set = id_set, game_name=game_name,  
                                     height=height, width=width, pattern = pattern, seed=seed, gid_size=gid_size)
  }

  ##### Otherwise return error
  else stop("entry_type must be either: 'predefined', 'choice', or 'random'.")       
}

