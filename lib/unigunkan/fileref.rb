class FileRef
  attr_accessor :id, :name, :isa,  :last_known_type, :path, :source_tree

  def initialize(hash)
    @id = SecureRandom.hex(8)
    @isa = :PBXFileReference
    @name = hash[:name]
    @last_known_type = hash[:last_known_type]
    @path = hash[:path]
    @source_tree = hash[:source_tree]
  end

  def fields
    ["isa = #{@isa}", "lastKnownType = \"#{@last_known_type}\"", "name = #{@name}", "path = #{@path}", "sourceTree = #{@source_tree}"].join("; ")
  end

  def to_s
    "#{@id} /* #{@name} */ = {#{self.fields}};"
  end
end