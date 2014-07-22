<<< start root >>>
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
		// Note that it will look for the value prioritizing deepest applicable level first ie
		// It will look first in the fields element level and then at the root level
		[Required] ##:required? // Switches: Includes line if required is true
		[MaxLength({{maxLength}})] ##:maxLength? // This is eventual syntax right now you'd have to use a seperate HasMaxLength property for the switch
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
		##::last?
		<<< end fields >>>
	}
}
<<< end root >>>