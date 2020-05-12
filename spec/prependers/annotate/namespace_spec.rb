# frozen_string_literal: true

RSpec.describe Prependers::Annotate::Namespace do
  before do
    class Cat; end

    module Acme
      module Cat
        module AddMeow
          include Prependers::Prepender[namespace: Acme]

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
