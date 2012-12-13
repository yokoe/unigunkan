class FileRef
  attr_accessor :id, :name, :last_known_type, :path, :source_tree

  def initialize(hash)
    @id = SecureRandom.hex(8)
    @name = hash[:name]
    @last_known_type = hash[:last_known_type]
    @path = hash[:path]
    @source_tree = hash[:source_tree]
  end

  def fields
    ["isa = PBXFileReference", "lastKnownType = \"#{@last_known_type}\"", "name = #{@name}", "path = #{@path}", "sourceTree = #{@source_tree}"].map{|a| "#{a};"}.join(" ")
  end

  def to_s
    "#{@id} /* #{@name} */ = {#{self.fields}};"
  end

  def self.file_group(filename)
    ext = filename.split(".").last
    case ext
    when "dylib"
      return "Frameworks"
    end
  end
end