require 'rails_helper'

describe BlacklightAdvancedSearch::RenderConstraintsOverride, type: :helper do
  describe '#render_constraint_element' do
    context 'when a bounding box constraint is applied' do
      let(:params) do
        { bbox: '-43.9453125 04.214943 043.9453125 036.597889' }
      end

      before do
        allow(controller).to receive(:params).and_return(params)
      end

      it 'does not render values for bounding box constraints' do
        # byebug
        expect(helper.render_constraint_element('Bounding Box',\
                                                '-43.9453125 04.214943 043.9453125 036.597889'))\
          .not_to have_content('-43.9453125 04.214943 043.9453125 036.597889')
      end

      it 'renders other constaints' do
        expect(helper.render_constraint_element('Data type', 'Polygon')).to have_content('Polygon')
      end
    end
  end
end
