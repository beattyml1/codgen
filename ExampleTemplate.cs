using System;

namespace {{ApplicationName}}.Models
{
	public class {{EntityName%CapCamel}} : ModelBaseClass<{{EntityName}}DataStore> where T: DataStoreBase, new()
	{
		{{EntityName}}DataStore _dataStore;

		public {{EntityName}} : this(new {{EntityName}}DataStore()) { }

		public {{EntityName}}({{EntityName}}DataStore dataStore)
		{
			_dataStore = dataStore
		}

		<<< start fields >>>
		[Required] ##:required?
		[ReadOnly] ##:ReadOnly?
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

		public static ModelFieldInfo {{fieldName:CapCamel}}FieldInfo;
		
		<<< end fields >>>
	}
}
