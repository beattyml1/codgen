using System;

namespace {{ApplicationName}}.Models
{
	public class {{EntityName}} : ModelBaseClass<{{EntityName}}DataStore> where T: DataStoreBase, new()
	{
		{{EntityName}}DataStore _dataStore;

		public {{EntityName}} : this(new {{EntityName}}DataStore()) { }

		public {{EntityName}}({{EntityName}}DataStore dataStore)
		{
			_dataStore = dataStore
		}
        <<< start fields >>>
		##:IsFirstTemplateInstance?
		[ReadOnly] ##:ReadOnly?
		[Required] ##:required?
		[MaxLength({{maxLength}})] ##:hasMaxLength?
		public {{cstype}} {{FieldName}}
		{
			get { return _dataStore.{{FieldName}} }
			set
			{
				_dataStore.{{fieldName:CapCamel:Single}} = value;
				NotifyPropertyChanged("{{FieldName}}")
			}
		}
		##:!IsLastTemplateInstance?
		<<< end fields >>>
	}
}
