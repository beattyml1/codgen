module RegularExpressions
  INSERT_REGEX = /\{\{[a-zA-Z0-9_%]*\}\}/
  SWITCH_REGEX = /##:!?[a-zA-Z0-9_%]*\?/
  SWITCHED_LINE_REGEX = /^.*##:!?[a-zA-Z0-9_%]*\?.*$/
  IDENTIFIER_REGEX = /[a-zA-Z0-9_%]+/
  TAG_REGEX = /<<<[a-zA-Z0-9_% &!|()]+>>>/
  TEMPLATE_START_TAG_REGEX = /<<<[ ]*start[ ]+[a-zA-Z0-9_%]+[ ]*>>>/
  TEMPLATE_END_TAG_REGEX = /<<<[ ]*end[ ]+[a-zA-Z0-9_%]+[ ]*>>>/
  MACRO_REGEX = /~~[a-zA-Z0-9_%]+:/

  IF_TAG_REGEX = /<<<[ ]*if[ ]+[a-zA-Z0-9_% |&!()]+[ ]*>>>/
  ELSEIF_TAG_REGEX = /<<<[ ]*elseif[ ]+[a-zA-Z0-9_% |!&()]+[ ]*>>>/
  ELSE_TAG_REGEX = /<<<[ ]*else[ ]+>>>/
  ENDIF_TAG_REGEX = /<<<[ ]*endif[ ]+>>>/
  CONDITIONAL_TAG_REGEX = /<<<[ ]*if|elseif|else|endif[ ]+[a-zA-Z0-9_% |!&()]+[ ]*>>>/
  STATEMENT_REGEX = /[a-zA-Z0-9_% |&!()]+/
end