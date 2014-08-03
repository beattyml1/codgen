using System;
using System.Collections.Generic;
using System.Data.Entity.Spatial;
using System.ComponentModel.DataAnnotations.Schema;


namespace {{ApplicationName}}.Models
{
	public class {{EntityName}}
	{
        <<< start fields >>>
		[Required] ##:Required?
		[StringLength({{maxLength}})] ##:hasMaxLength?
		public {{cstype}} {{FieldName}} { get; set; }
		##:!IsLastTemplateInstance?
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
