require 'spec_helper'

describe RestBase::Exceptions::CBMultiError do
  describe "Default Construction" do
    it "should use type: Error, code: 400, status: 400 with given error messages" do
      errors = ["Message 1", "Message 2", "Message 3"]
      expected_array = []
      errors.each { |message| expected_array << { :type => "Error", :code => "400", :message => message } }
      expected_message = "Multiple Errors of type Error with code 400 occured:\n#{errors.join(",\n")}"
      
      target = RestBase::Exceptions::CBMultiError.new(:errors => errors)
      
      expect(target).to_not be_nil
      expect(target.type).to eq("Error")
      expect(target.code).to eq("400")
      expect(target.status).to eq(400)
      expect(target.messages).to eq(errors)
      expect(target.to_a).to eq(expected_array)
      expect(target.message).to eq(expected_message)
    end
  end
  
  describe "Custom Construction" do
    it "should set all the error fields" do
      error_hash = {
        :type => "CustomError",
        :code => "500",
        :status => 500,
        :errors => ["Message 1", "Message 2", "Message 3"]
      }
      expected_array = []
      error_hash[:errors].each { |message| expected_array << { :type => error_hash[:type], :code => error_hash[:code], :message => message } }
      expected_message = "Multiple Errors of type #{error_hash[:type]} with code #{error_hash[:code]} occured:\n#{error_hash[:errors].join(",\n")}"
      
      target = RestBase::Exceptions::CBMultiError.new(error_hash)
      
      expect(target).to_not be_nil
      expect(target.type).to eq(error_hash[:type])
      expect(target.code).to eq(error_hash[:code])
      expect(target.status).to eq(error_hash[:status])
      expect(target.messages).to eq(error_hash[:errors])
      expect(target.to_a).to eq(expected_array)
      expect(target.message).to eq(expected_message)
    end
  end
  
  describe "Comparison" do
    it "should be true for equal objects" do
      target_1 = RestBase::Exceptions::CBMultiError.new({
        :type => "CustomError",
        :code => "500",
        :status => 500,
        :errors => ["Message 1", "Message 2", "Message 3"]
      })
      
      target_2 = RestBase::Exceptions::CBMultiError.new({
        :type => "CustomError",
        :code => "500",
        :status => 500,
        :errors => ["Message 1", "Message 2", "Message 3"]
      })
      
      expect(target_1).to eq(target_2)
    end
    
    it "should fail for objects with different types" do
      target_1 = RestBase::Exceptions::CBMultiError.new({
        :type => "CustomError",
        :code => "500",
        :status => 500,
        :errors => ["Message 1", "Message 2", "Message 3"]
      })
      
      target_2 = RestBase::Exceptions::CBMultiError.new({
        :type => "DifferentError",
        :code => "500",
        :status => 500,
        :errors => ["Message 1", "Message 2", "Message 3"]
      })
      
      expect(target_1).to_not eq(target_2)
    end
    
    it "should fail for objects with different codes" do
      target_1 = RestBase::Exceptions::CBMultiError.new({
        :type => "CustomError",
        :code => "500",
        :status => 500,
        :errors => ["Message 1", "Message 2", "Message 3"]
      })
      
      target_2 = RestBase::Exceptions::CBMultiError.new({
        :type => "CustomError",
        :code => "400",
        :status => 500,
        :errors => ["Message 1", "Message 2", "Message 3"]
      })
      
      expect(target_1).to_not eq(target_2)
    end
    
    it "should fail for objects with different statuses" do
      target_1 = RestBase::Exceptions::CBMultiError.new({
        :type => "CustomError",
        :code => "500",
        :status => 500,
        :errors => ["Message 1", "Message 2", "Message 3"]
      })
      
      target_2 = RestBase::Exceptions::CBMultiError.new({
        :type => "CustomError",
        :code => "500",
        :status => 400,
        :errors => ["Message 1", "Message 2", "Message 3"]
      })
      
      expect(target_1).to_not eq(target_2)
    end
    
    it "should fail for objects with different errors" do
      target_1 = RestBase::Exceptions::CBMultiError.new({
        :type => "CustomError",
        :code => "500",
        :status => 500,
        :errors => ["Message 1", "Message 2", "Message 3"]
      })
      
      target_2 = RestBase::Exceptions::CBMultiError.new({
        :type => "CustomError",
        :code => "500",
        :status => 500,
        :errors => ["Message 1"]
      })
      
      expect(target_1).to_not eq(target_2)
    end
  end
end
