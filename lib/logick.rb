require "scrivener"

class Logick
  def self.perform(&block)
    catch(:fail) { Result.new(type: :success, output: block.call) }
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

  class Scrivener < ::Scrivener
    def self.run(atts)
      scrivener = new(atts)

      if !scrivener.valid?
        throw(:fail, Result.new(type: :fail, errors: scrivener.errors))
      end

      scrivener.run
    end
  end
end
