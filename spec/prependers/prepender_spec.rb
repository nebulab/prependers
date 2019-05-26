# frozen_string_literal: true

RSpec.describe Prependers::Prepender do
  context 'without a namespace' do
    before do
      class Dog; end

      module Dog::AddBarking # rubocop:disable Style/ClassAndModuleChildren
        include Prependers::Prepender.new

        def bark
          'Woof!'
        end
      end
    end

    it 'prepends the base module to the prepended module' do
      expect(Dog.new.bark).to eq('Woof!')
    end
  end

  context 'with a namespace' do
    before do
      class Cat; end

      module Acme
        module Cat
          module AddMeow
            include Prependers::Prepender.new(Acme)

            def meow
              'Meow!'
            end
          end
        end
      end
    end

    it 'prepends the base module to the prepended module' do
      expect(Cat.new.meow).to eq('Meow!')
    end
  end
end
