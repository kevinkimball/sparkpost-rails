# frozen_string_literal: true

require 'spec_helper'

describe SparkPostRails::DeliveryMethod do
  before do
    @delivery_method = SparkPostRails::DeliveryMethod.new
  end

  context 'No Attachments' do
    it 'does not include attachment elements in the data' do
      test_email = Mailer.test_email
      @delivery_method.deliver!(test_email)

      expect(@delivery_method.data[:content].key?(:attachments)).to eq(false)
      expect(@delivery_method.data[:content].key?(:inline_images)).to eq(false)
    end
  end

  context 'Standard Attachments' do
    it 'accepts a single attachment' do
      test_email = Mailer.test_email attachments: 1
      @delivery_method.deliver!(test_email)

      expect(@delivery_method.data[:content][:attachments]).to eq([{ name: 'file_0.txt',
                                                                     type: 'text/plain; filename=file_0.txt', data: 'VGhpcyBpcyBmaWxlIDA=' }])
    end

    it 'accepts multiple attachments' do
      test_email = Mailer.test_email attachments: 2
      @delivery_method.deliver!(test_email)

      expect(@delivery_method.data[:content][:attachments]).to eq([
                                                                    { name: 'file_0.txt', type: 'text/plain; filename=file_0.txt',
                                                                      data: 'VGhpcyBpcyBmaWxlIDA=' }, { name: 'file_1.txt', type: 'text/plain; filename=file_1.txt', data: 'VGhpcyBpcyBmaWxlIDE=' }
                                                                  ])
    end

    it 'accepts a single image attachment' do
      test_email = Mailer.test_email images: 1
      @delivery_method.deliver!(test_email)

      expect(@delivery_method.data[:content][:attachments]).to eq([{ name: 'image_0.png',
                                                                     type: 'image/png; filename=image_0.png', data: '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' }])
    end
  end

  context 'Inline Attachments' do
    it 'accepts an inline attachment' do
      test_email = Mailer.test_email inline_attachments: 1
      @delivery_method.deliver!(test_email)

      images = @delivery_method.data[:content][:inline_images]
      expect(images.length).to eq(1)
      image = images[0]
      expect(image).to include(:name, type: 'image/png; filename=image_0.png',
                                      data: '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')
      expect(image[:name]).to match(/.*@.*/)
    end
  end
end
