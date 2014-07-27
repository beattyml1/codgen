module Resources
  INSERT_REGEX = /\{\{[a-zA-Z0-9_%]*\}\}/
  SWITCH_REGEX = /##:!?[a-zA-Z0-9_%]*\?/
  SWITCHED_LINE_REGEX = /^.*##:!?[a-zA-Z0-9_%]*\?.*$/
  IDENTIFIER_REGEX = /[a-zA-Z0-9_%]+/
end