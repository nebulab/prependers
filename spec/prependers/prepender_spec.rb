# frozen_string_literal: true

RSpec.describe Prependers::Prepender do
  before do
    class Dog; end

    module Dog::AddBarking # rubocop:disable Style/ClassAndModuleChildren
      include Prependers::Prepender[]

      module ClassMethods
        def bark
          'Class woof!'
        end
      end

      def bark
        'Woof!'
      end
    end
  end

  it 'prepends the base module to the prepended module' do
    expect(Dog.new.bark).to eq('Woof!')
  end

  it "prepends the ClassMethods module to the prepended module's singleton class" do
    expect(Dog.bark).to eq('Class woof!')
  end
end
