import base64, json, times, os


proc clearTerminal() =
  if defined(windows):
    discard execShellCmd("cls")
  else:
    discard execShellCmd("clear")


type
  LoggerConfig = object
    LoggerName: string
    DisplayTime: bool
    Level: string
    LoggerText: string

proc processLog(config: LoggerConfig) =
  let timeDisplay = if config.DisplayTime: "Current Time: " & $getTime() else: ""
  clearTerminal()
  echo(timeDisplay & "[" & config.Level & "] " & config.LoggerName & ": " & config.LoggerText)

when isMainModule:
  # Check if a command-line argument is provided
  if paramCount() < 1:
    echo("Usage: nim c -r your_file.nim <base64_encoded_json>")
    quit(1)

  # Get the Base64 encoded JSON string from command-line argument
  let base64String = paramStr(1)

  # Decode Base64 to JSON string
  var decodedString = base64.decode(base64String)
  
  # Parse JSON
  let jsonData = parseJson(decodedString)
  
  # Create LoggerConfig object from JSON
  let config = LoggerConfig(
    LoggerName: jsonData["LoggerName"].getStr(),
    DisplayTime: jsonData["DisplayTime"].getBool(),
    Level: jsonData["Level"].getStr(),
    LoggerText: jsonData["LoggerText"].getStr()
  )

  # Process the log based on the config
  processLog(config)
