require 'rspec'
require_relative 'flattener'

describe 'Flattener' do
  @data_root = {
    'root_prop1' => 'root_prop1_val',
    'prop2' => 'root_prop2_val',
    'object1' => {
      'object2' => {
        'array'  =>[
          {
              'prop1' => 'prop1_val',
              'prop2' => 'prop2_val'
          }
        ]
      }
    }
  }

  def flatten_to_object1_object2_array_0
    Flattener.flatten(@data_root, ['object1', 'object2', 'array', 0])
  end

  it 'should have prop1 = prop1_val when it flattens to object1.object2[0] given @data_root' do
    expect(flatten_to_object1_object2_array_0['prop1']).to eq('prop1_val')
  end

  it 'should have prop2 = prop2_val when it flattens to object1.object2[0] given @data_root' do
    expect(flatten_to_object1_object2_array_0['prop2']).to eq('prop2_val')
  end

  it 'should have root_prop1 = root_prop1_val when it flattens to object1.object2[0] @given data_root' do
    expect(flatten_to_object1_object2_array_0['root_prop1']).to eq('root_prop1_val')
  end
end