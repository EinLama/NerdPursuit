#encoding: UTF-8
require 'minitest/autorun'
require 'json-schema'
require 'json'

SCHEMA_FILE = File.join(File.dirname(File.expand_path(__FILE__)) , 'schema', 'question.json')
QUESTIONS_PATH = File.join(File.dirname(File.expand_path(__FILE__)) , 'questions')
schema = File.open(SCHEMA_FILE) { |f| JSON.parse(f.read) }

describe 'question' do
  Dir["#{QUESTIONS_PATH}/**/*\.*"].each do |file|
    it "#{file.sub(/(\..*$)/,'').sub(/^#{QUESTIONS_PATH}/,'')} contains valid json" do


      begin
        question = File.open(file) { |f| JSON.parse(f.read.force_encoding('UTF-8')) }['question']
        JSON::Validator.validate!(schema, question, :version=> :draft3 )
      rescue JSON::Schema::ValidationError => schema_error
         assertion =  false, schema_error.message + "\nIn: #{file}\n[#{question['created_by']}, please fix this and send another pull request!]"
      rescue JSON::ParserError => parser_error
         assertion =  false, parser_error.message
      else
         assertion = true
      end

      assert *assertion
    end
  end
end
