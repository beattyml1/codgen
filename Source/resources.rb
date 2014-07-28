module Resources
  INSERT_REGEX = /\{\{[a-zA-Z0-9_%]*\}\}/
  SWITCH_REGEX = /##:!?[a-zA-Z0-9_%]*\?/
  SWITCHED_LINE_REGEX = /^.*##:!?[a-zA-Z0-9_%]*\?.*$/
  IDENTIFIER_REGEX = /[a-zA-Z0-9_%]+/
  TEMPLATE_TAG_REGEX = /<<<[a-zA-Z0-9_% ]+>>>/
  TEMPLATE_START_TAG_REGEX = /<<<[ ]*start[ ]*[a-zA-Z0-9_%]+[ ]*>>>/
  TEMPLATE_END_TAG_REGEX = /<<<[ ]*end[ ]*[a-zA-Z0-9_%]+[ ]*>>>/
end