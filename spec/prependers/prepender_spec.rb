# frozen_string_literal: true

RSpec.describe Prependers::Prepender do
  context 'without a namespace' do
    before do
      class Dog; end

      module Dog::AddBarking # rubocop:disable Style/ClassAndModuleChildren
        include Prependers::Prepender.new

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

  context 'with a namespace' do
    before do
      class Cat; end

      module Acme
        module Cat
          module AddMeow
            include Prependers::Prepender.new(Acme)

            module ClassMethods
              def meow
                'Class meow!'
              end
            end

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

    it "prepends the ClassMethods module to the prepended module's singleton class" do
      expect(Cat.meow).to eq('Class meow!')
    end
  end
end
