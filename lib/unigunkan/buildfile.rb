class BuildFile
  attr_accessor :id

  def initialize(fileref)
    @id = SecureRandom.hex(8)
    @fileref = fileref
  end

  def to_s
    "#{@id} /* #{@fileref.name} */ = {isa = PBXBuildFile; fileRef = #{@fileref.id} /* #{@fileref.name} */; };"
  end
end