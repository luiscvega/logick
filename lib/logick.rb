require "scrivener"

class Logick < Scrivener
  def self.perform(&block)
    catch(:fail) { Result.new(type: :success, output: block.call) }
  end

  def self.run(atts)
    scrivener = new(atts)
    scrivener.failure(scrivener.errors) unless scrivener.valid?
    scrivener.run
  end

  def failure(errors)
    throw(:fail, Result.new(type: :fail, output: self, errors: errors))
  end

  class Result
    attr_accessor :type, :output, :errors

    def initialize(atts)
      @type   = atts[:type]
      @output = atts[:output]
      @errors = atts[:errors]
    end

    def success?
      @type == :success
    end

    def fail?
      @type == :fail
    end
  end
end
