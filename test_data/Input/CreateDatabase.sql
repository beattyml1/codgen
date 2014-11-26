Create Database {{ApplicationName}}
{{#entities}}

Create Table {{EntityNames}} (
  {{#fields}}
  {{FieldName}} {{type}}
  , ##:!IsLastTemplateInstance?
  {{/fields}}
)
{{/entities}}