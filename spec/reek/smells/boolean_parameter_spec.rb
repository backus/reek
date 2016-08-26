require_relative '../../spec_helper'
require_lib 'reek/smells/boolean_parameter'

RSpec.describe Reek::Smells::BooleanParameter do
  it 'reports the right values' do
    src = <<-EOS
      class Klass
        def cc(arga = true)
          arga
        end
      end
    EOS

    expect(src).to reek_of(:BooleanParameter,
                           lines: [2],
                           context: 'Klass#cc',
                           message: "has boolean parameter 'arga'",
                           source: 'string',
                           parameter: 'arga')
  end

  context 'parameter defaulted with boolean' do
    context 'in a method' do
      it 'reports a parameter defaulted to true' do
        src = 'def cc(arga = true); arga; end'
        expect(src).to reek_of(:BooleanParameter, parameter: 'arga')
      end

      it 'reports a parameter defaulted to false' do
        src = 'def cc(arga = false) end'
        expect(src).to reek_of(:BooleanParameter, parameter: 'arga')
      end

      it 'reports two parameters defaulted to booleans' do
        src = 'def cc(nowt, arga = true, argb = false, &blk) end'
        expect(src).
          to reek_of(:BooleanParameter, parameter: 'arga').
          and reek_of(:BooleanParameter, parameter: 'argb')
      end

      it 'reports keyword parameters defaulted to booleans' do
        src = 'def cc(arga: true, argb: false) end'
        expect(src).
          to reek_of(:BooleanParameter, parameter: 'arga').
          and reek_of(:BooleanParameter, parameter: 'argb')
      end

      it 'does not report regular parameters' do
        src = 'def cc(a, b) end'
        expect(src).not_to reek_of(described_class)
      end

      it 'does not report array decomposition parameters' do
        src = 'def cc((a, b)) end'
        expect(src).not_to reek_of(described_class)
      end

      it 'does not report keyword parameters with no default' do
        src = 'def cc(a:, b:) end'
        expect(src).not_to reek_of(described_class)
      end

      it 'does not report keyword parameters with non-boolean default' do
        src = 'def cc(a: 42, b: "32") end'
        expect(src).not_to reek_of(described_class)
      end
    end

    context 'in a singleton method' do
      it 'reports a parameter defaulted to true' do
        src = 'def self.cc(arga = true) end'
        expect(src).to reek_of(:BooleanParameter, parameter: 'arga')
      end

      it 'reports a parameter defaulted to false' do
        src = 'def fred.cc(arga = false) end'
        expect(src).to reek_of(:BooleanParameter, parameter: 'arga')
      end

      it 'reports two parameters defaulted to booleans' do
        src = 'def Module.cc(nowt, arga = true, argb = false, &blk) end'
        expect(src).
          to reek_of(:BooleanParameter, parameter: 'arga').
          and reek_of(:BooleanParameter, parameter: 'argb')
      end
    end
  end
end
