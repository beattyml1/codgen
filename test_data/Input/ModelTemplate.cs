using System;
using System.Collections.Generic;
using System.Data.Entity.Spatial;
using System.ComponentModel.DataAnnotations.Schema;


namespace {{ApplicationName}}.Models
{
	public class {{EntityName}}
	{
        {{#fields}}
		[Required] ##:Required?
		{{#hasMaxLength}}
		[StringLength({{maxLength}})]
		{{/hasMaxLength}}
		public {{cstype}} {{FieldName}} { get; set; }
		<<< end fields >>>
		<<< start hasmany >>>
		##:IsFirstTemplateInstance?
		ICollection<{{EntityName}}> {{EntityNames}} { get; set; }
		##:!IsLastTemplateInstance?
		<<< end hasmany >>>
		<<< start belongsto >>>
		##:IsFirstTemplateInstance?
		{{EntityName}} {{EntityName}} { get; set; }
		##:!IsLastTemplateInstance?
		<<< end belongsto >>>
	}
}
