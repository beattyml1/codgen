using System;

namespace TestApp.Models
{
	public class TestModel : ModelBaseClass<TestModelDataStore> where T: DataStoreBase, new()
	{
		TestModelDataStore _dataStore;

		public TestModel : this(new TestModelDataStore()) { }

		public TestModel(TestModelDataStore dataStore)
		{
			_dataStore = dataStore
		}

		
		[ReadOnly] 
		public Guid TestModelId
		{
			get { return _dataStore.TestModelId }
			set
			{
				_dataStore.{{fieldName:CapCamel:Single}} = value;
				NotifyPropertyChanged("TestModelId")
			}
		}

		public static ModelFieldInfo {{fieldName:CapCamel}}FieldInfo;
		
		
		[Required] 
		[MaxLength(5)] 
		public string TestModelName
		{
			get { return _dataStore.TestModelName }
			set
			{
				_dataStore.{{fieldName:CapCamel:Single}} = value;
				NotifyPropertyChanged("TestModelName")
			}
		}

		public static ModelFieldInfo {{fieldName:CapCamel}}FieldInfo;
		
		
	}
}