require 'spec_helper'

describe ApplicationHelper do
  context '.current_order' do
    context 'if any cookie[:current_order]' do
      context 'if any order with id == cookie[:current_order]' do
        it 'returns that order' do
          @order = FactoryGirl.create :order
          cookies[:current_order] = @order.id
          expect(current_order).to eq(@order)
        end
      end
    end
  end
end