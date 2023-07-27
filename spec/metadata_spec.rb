# frozen_string_literal: true

require 'spec_helper'

describe SparkPostRails::DeliveryMethod do
  subject { described_class.new }

  let(:metadata) { { item1: 'test data 1', item2: 'test data 2' } }

  describe 'Metadata' do
    context 'template-based message' do
      context 'when metadata is passed' do
        it 'includes metadata' do
          test_email = Mailer.test_email sparkpost_data: { template_id: 'test_template', metadata: }
          subject.deliver!(test_email)
          expect(subject.data[:metadata]).to eq(metadata)
        end
      end

      context "when metadata isn't passed" do
        it "doesn't include metadata" do
          test_email = Mailer.test_email sparkpost_data: { template_id: 'test_template' }
          subject.deliver!(test_email)
          expect(subject.data).not_to have_key(:metadata)
        end
      end
    end

    context 'inline-content message' do
      context 'when metadata is passed' do
        it 'includes metadata' do
          test_email = Mailer.test_email sparkpost_data: { metadata: }
          subject.deliver!(test_email)
          expect(subject.data[:metadata]).to eq(metadata)
        end
      end

      context "when metadata isn't passed" do
        it "doesn't include metadata" do
          test_email = Mailer.test_email sparkpost_data: { metadata: nil }
          subject.deliver!(test_email)
          expect(subject.data).not_to have_key(:metadata)
        end
      end
    end
  end
end
