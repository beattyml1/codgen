
using System;

// To insert a value from JSON just use double curly brackets with the name inside
// Casing changing and pluralizing isn't currently supported automatically but putting in this format now should allow your templates to use it once we add that feature
namespace TestApp.Models
{
	public class TestModel : ModelBaseClass<T> where T: DataStoreBase, new()
	{
		T _dataStore;

		public TestModel : this(new T()) { }

		public TestModel(T dataStore)
		{
			_dataStore = dataStore
		}

		
		[ReadOnly] 
		public Guid TestModelId
		{
			get { return _dataStore.TestModelId }
			set
			{
				_dataStore.TestModelId = value;
				NotifyPropertyChanged("TestModelId")
			}
		}

		public static ModelFieldInfo {{fieldName:CapCamel}}FieldInfo;
		
		
		[Required] 
		[MaxLength(5)] 
		public Guid TestModelName
		{
			get { return _dataStore.TestModelName }
			set
			{
				_dataStore.TestModelName = value;
				NotifyPropertyChanged("TestModelName")
			}
		}

		public static ModelFieldInfo {{fieldName:CapCamel}}FieldInfo;
		
		
	}
}