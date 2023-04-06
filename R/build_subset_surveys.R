#' Build subset-RICH surveys (e.g., for partner choice or PG games.)
#' 
#' This is a wraper function to create suveys (PDFs) to collect data for PGG contributions and similar games.
#'
#' @param path Path to RICH folder.
#' @param pid ID code of focal recipient.
#' @param id_set IDs of alter recipients (as vector).
#' @param game_name Used to label PDF surveys.
#' @param entry_type Plull from all files in SubsetData folder using: "random" or "choice". For eeach CSVs in that folder you can build a choice PDF and a random PDF.
#' set entry_type to "predefined" and a add  specific "pid" and "id_set" to the inputs in order to build a single predefined file.
#' @param set_size Size of set of possible alters.
#' @param token_color Number or "color" of tokens placed. If data was entered manually, place whatever value was tored to indiciate a tie: "1"
#' @param pattern Should JPG be jpg be used to load photos?
#' @param height Size of PDF output.
#' @param width Size of PDF output.
#' @param seed Number to use in RNG.
#' @param gid_size Number of terms in hashcodes for the game IDs.
#' @param max_iter Max time to search for full-scope legal permutations.
#' @return A file folder, SubsetSurveys, full of selective sub-surveys to run, and a second folder, SubsetContributions, full of csv files to stord=e results.
#' @export
#' @examples
#' \dontrun{
#' build_subset_surveys(path, pattern = ".jpg", token_color="navyblue", entry_type="random", set_size=4, 
#'                                  height=8.5, width=11, seed=123, gid_size=4, max_iter=10000)
#' }
#'

build_subset_surveys = function (path, pid=NULL, id_set=NULL, game_name="Choice", entry_type="random", set_size=4, 
                                    pattern = ".jpg", token_color="navyblue",  max_iter=10000, 
                                    height=8.5, width=11, seed=NA, gid_size=4){

  ################################################################## Build Selection
  if(entry_type=="choice"){
   subset_survey_compiler_partner_choice(path=path, token_color=token_color, game_name=game_name, set_size=set_size, 
                                         height=height, width=width, pattern = pattern, seed=seed, gid_size=gid_size)
   }
 
  ################################################################## Build Random
  else if(entry_type=="random"){
   subset_survey_compiler_random(path=path, token_color=token_color, game_name=game_name, max_iter=max_iter, set_size=set_size, 
                                 height=height, width=width, pattern = pattern, seed=seed, gid_size=gid_size)     
   }

  ################################################################## Build Selection
  else if(entry_type=="predefined"){
   subset_survey_compiler_predefined(path=path, pid = pid, id_set = id_set, game_name=game_name, set_size=set_size, 
                                     height=height, width=width, pattern = pattern, seed=seed, gid_size=gid_size)
  }

  ##### Otherwise return error
  else stop("entry_type must be either: 'predefined', 'choice', or 'random'.")       
}

