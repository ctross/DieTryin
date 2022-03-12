#' say_something
#'
#' This is a helper function.
#' @param 
#' stuff  the message to read.
#' @param 
#' stuff  the voice to use.
#' @export


say_something = function(message , voice) {
        
  voice = paste0("\"$speak.SelectVoice('Microsoft ", voice, " Desktop');" )
  message = paste0("$speak.Speak('", message, "');\"")
      
  system2(command = "PowerShell", 
          args = c("-Command", 
                    "\"Add-Type -AssemblyName System.Speech;",
                    "$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer;",
                    voice,
                    message
          ))
}