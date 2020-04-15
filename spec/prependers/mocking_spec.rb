require 'spec_helper'

RSpec.describe 'Mocking' do
  before(:all) do
    module PrependersTest
      class BaseClass
        def new_method; end
      end
    end

    module PrependersTest::AddClassMethod
      include Prependers::Prepender.new

      module ClassMethods
        def new_method; end
      end
    end
  end

  before do
    allow(PrependersTest::BaseClass).to receive_messages(new_method: 'test')
  end

  it 'works when mocking a class method' do
    expect(PrependersTest::BaseClass.new_method).to eq('test')
  end
end
