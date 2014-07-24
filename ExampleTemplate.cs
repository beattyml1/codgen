
using System;

// To insert a value from JSON just use double curly brackets with the name inside
// Casing changing and pluralizing isn't currently supported automatically but putting in this format now should allow your templates to use it once we add that feature
namespace {{applicationName:CapCamel:Single}}.Models
{
	public class {{entityName:CapCamel:Single}} : ModelBaseClass<T> where T: DataStoreBase, new()
	{
		T _dataStore;

		public {{entityName:CapCamel:Single}} : this(new T()) { }

		public {{entityName:CapCamel:Single}}(T dataStore)
		{
			_dataStore = dataStore
		}

		<<< start fields >>>
		[Required] ##:required?
		[ReadOnly] ##:readOnly?
		[MaxLength({{maxLength}})] ##:hasMaxLength?
		public {{cstype}} {{fieldName:CapCamel:Single}}
		{
			get { return _dataStore.{{fieldName:CapCamel:Single}} }
			set
			{
				_dataStore.{{fieldName:CapCamel:Single}} = value;
				NotifyPropertyChanged("{{fieldName:CapCamel:Single}}")
			}
		}

		public static ModelFieldInfo {{fieldName:CapCamel}}FieldInfo;
		
		<<< end fields >>>
	}
}
