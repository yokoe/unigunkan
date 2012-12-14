class BuildFile
  attr_accessor :id

  def initialize(fileref)
    @id = SecureRandom.hex(12)
    @fileref = fileref
  end

  def key
    "#{@id} /* #{@fileref.name} in #{@fileref.group} */"
  end
  def to_s
    "#{self.key} = {isa = PBXBuildFile; fileRef = #{@fileref.id} /* #{@fileref.name} */; };"
  end
end