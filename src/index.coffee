# Dependencies
Reader= (require './reader').Reader

# Public
class VpvpVmd extends Reader
  parse: (buffer)->
    unless Buffer.isBuffer buffer
      throw new TypeError 'argument is not a Buffer'

    unless (buffer.slice 0,25).toString() is 'Vocaloid Motion Data 0002'
      throw new TypeError 'buffer is not a Vocaloid Motion Data 0002'

    header= @readHeader buffer

    bone= @readBone buffer
    morph= @readMorph buffer
    ik= @readIK buffer

    camera= @readCamera buffer
    light= @readLight buffer
    shadow= @readShadow buffer

    {header,bone,morph,ik,camera,light,shadow}

module.exports= new VpvpVmd
module.exports.VpvpVmd= VpvpVmd
