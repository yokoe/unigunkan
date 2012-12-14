class FileRef
  attr_accessor :id, :name, :last_known_type, :path, :source_tree, :file_encoding

  def initialize(hash)
    @id = SecureRandom.hex(12)
    @name = hash[:name]
    @last_known_type = hash[:last_known_type]
    @path = hash[:path]
    @source_tree = hash[:source_tree]
    @file_encoding = hash[:file_encoding]
  end

  def fields
    last_known_type = @last_known_type
    last_known_type = "\"#{last_known_type}\"" if last_known_type == "compiled.mach-o.dylib"

    elements = ["isa = PBXFileReference", "lastKnownType = #{last_known_type}", "name = #{@name}", "path = #{@path}", "sourceTree = #{@source_tree}"]
    elements << "fileEncoding = #{@file_encoding}" if @file_encoding
    elements.map{|a| "#{a};"}.join(" ")
  end

  def key
    "#{@id} /* #{@name} */"
  end

  def to_s
    "#{self.key} = {#{self.fields}};"
  end

  def group
    FileRef.file_group(self.name)
  end

  def build_file
    @build_file = BuildFile.new(self) if !@build_file
    return @build_file
  end

  def self.file_group(filename)
    ext = filename.split(".").last
    case ext
    when "dylib"
      return "Frameworks"
    end
  end
end