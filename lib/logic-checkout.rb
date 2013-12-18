class Logic
  def self.perform(&block)
    result = catch(:logic) do
      Result.new(:success, block.call)
    end
  end

  class Result
    attr_reader :type, :payload

    def initialize(type, payload)
      @type = type; @output = output
    end

    def fail?
      @type == :fail
    end

    def success?
      @type == :success
    end
  end

  class Scrivener
  end
end
