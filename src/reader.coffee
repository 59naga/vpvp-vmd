# Dependencies
Utility= (require './utility').Utility

iconv= require 'iconv-lite'

# Public
class Reader extends Utility
  encode: 'shift_jis'
  
  headerByte:  50
  boneByte:   111
  morphByte:   23
  cameraByte:  61
  lightByte:   28
  shadowByte:   9

  # データ種（ボーン、モーフ、カメラ、照明、自シャドウ、IK）ごとの開始位置を求める
  readMeta: (buffer)->
    header= {}
    header.begin= 0
    header.byte= @headerByte
    header.signature= 30
    header.name= 20
    header.total= 50

    begin= header.begin+(header.byte*1)
    bone= {}
    bone.count= buffer.readUInt32LE begin
    bone.begin= begin+4
    bone.byte= @boneByte
    bone.total= bone.byte*bone.count

    begin= bone.begin+(bone.byte*bone.count)
    morph= {}
    morph.count= buffer.readUInt32LE begin
    morph.begin= begin+4
    morph.byte= @morphByte
    morph.total= morph.byte*morph.count

    begin= morph.begin+(morph.byte*morph.count)
    camera= {}
    camera.count= buffer.readUInt32LE begin
    camera.begin= begin+4
    camera.byte= @cameraByte
    camera.total= camera.byte*camera.count

    begin= camera.begin+(camera.byte*camera.count)
    if buffer.length > begin
      light= {}
      light.count= buffer.readUInt32LE begin
      light.begin= begin+4
      light.byte= @lightByte
      light.total= light.byte*light.count

      # Fix issue#1
      light= null if buffer.length < light.begin+light.total

    begin= light?.begin+(light?.byte*light?.count)
    if buffer.length > begin
      shadow= {}
      shadow.count= buffer.readUInt32LE begin
      shadow.begin= begin+4
      shadow.byte= @shadowByte
      shadow.total= shadow.byte*shadow.count

      shadow= null if buffer.length < shadow.begin+shadow.total

    # ik長に依存する(9+21*ik.number)*ik.count
    begin= shadow?.begin+(shadow?.byte*shadow?.count)
    if buffer.length > begin
      ik= {}
      ik.count= buffer.readUInt32LE begin
      ik.begin= begin+4
      ik.number= if ik.count > 0 then buffer.readUInt32LE begin+4+5 else 0
      ik.byte= (9+21*ik.number) # FIXME?: フレームごとにik長が変わる場合は無視する
      ik.total= ik.byte*ik.count

      ik= null if buffer.length < ik.begin+ik.total

    {header,bone,morph,camera,light,shadow,ik}
  
  # 先頭50バイトはファイルシグネチャとモデル名(shift_jis)である
  readHeader: (buffer)->
    meta= (@readMeta buffer).header
    return [] unless meta?

    signature= (@sliceTrim buffer,0,meta.signature).toString()
    name= iconv.decode (@sliceTrim buffer,meta.signature,meta.signature+meta.name),'shift_jis'

    {signature,name}

  readBone: (buffer)->
    meta= (@readMeta buffer).bone
    return [] unless meta?

    for i in [0...meta.count]
      begin= meta.begin+(meta.byte*i)
      j= 0

      name= iconv.decode (@sliceTrim buffer,begin,begin+15),@encode
      j+= 15

      frame= buffer.readUInt32LE begin+j
      j+= 4

      position= @readVector3LE buffer,begin+j
      j+= 12

      quaternion= @readVector4LE buffer,begin+j
      j+= 16

      bezier= @getBezier buffer.slice begin+j,begin+j+64
      j+= 64

      {frame,name,position,quaternion,bezier}

  readMorph: (buffer)->
    meta= (@readMeta buffer).morph
    return [] unless meta?

    for i in [0...meta.count]
      begin= meta.begin+(meta.byte*i)
      j= 0

      name= iconv.decode (@sliceTrim buffer,begin,begin+15),@encode
      j+= 15

      frame= buffer.readUInt32LE begin+j
      j+= 4

      weight= buffer.readFloatLE begin+j
      j+= 4

      {frame,name,weight}

  readCamera: (buffer)->
    meta= (@readMeta buffer).camera
    return [] unless meta?

    for i in [0...meta.count]
      begin= meta.begin+(meta.byte*i)
      j= 0

      frame= buffer.readUInt32LE begin+j
      j+= 4

      length= (buffer.readFloatLE begin+j)*-1
      j+= 4

      location= @readVector3LE buffer,begin+j
      j+= 12

      rotation= @readVector3LE buffer,begin+j
      rotation[0]*= -1# X軸は符号が反転している
      j+= 12

      bezier= @getBezierCamera buffer.slice begin+j,begin+j+24
      j+= 24

      viewAngle= buffer.readUInt32LE begin+j
      j+= 4

      parspective= (buffer.readUIntLE begin+j) is 0
      j+= 1

      {frame,length,location,rotation,bezier,viewAngle,parspective}

  readLight: (buffer)->
    meta= (@readMeta buffer).light
    return [] unless meta?

    for i in [0...meta.count]
      begin= meta.begin+(meta.byte*i)
      j= 0

      frame= buffer.readUInt32LE begin+j
      j+= 4

      rgb= @readVector3LE buffer,begin+j
      j+= 12

      location= @readVector3LE buffer,begin+j
      j+= 12

      {frame,rgb,location}

  readShadow: (buffer)->
    meta= (@readMeta buffer).shadow
    return [] unless meta?

    for i in [0...meta.count]
      begin= meta.begin+(meta.byte*i)
      j= 0

      frame= buffer.readUInt32LE begin+j
      j+= 4

      mode= buffer.readUInt8 begin+j
      j+= 1

      distance= buffer.readFloatLE begin+j
      j+= 4

      {frame,mode,distance}

  # http://harigane.at.webry.info/201103/article_1.html
  readIK: (buffer)->
    meta= (@readMeta buffer).ik
    return [] unless meta?

    for i in [0...meta.count]
      begin= meta.begin+(meta.byte*i)
      j= 0

      frame= buffer.readUInt32LE begin+j
      j+= 4

      show= (buffer.readUIntLE begin+j) is 1
      j+= 1

      count= buffer.readUInt32LE begin+j
      j+= 4

      iks=
        for k in [0...count]
          name= iconv.decode (@sliceTrim buffer,begin+j,begin+j+20),@encode
          j+= 20

          enable= (buffer.readUIntLE begin+j) is 1
          j+= 1

          {name,enable}

      {frame,show,count,iks}

module.exports= new Reader
module.exports.Reader= Reader
