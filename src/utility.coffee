# Public
class Utility
  # for console.log
  slice: (buffer,begin,end=begin+1)->
    JSON.stringify (JSON.parse (JSON.stringify buffer.slice begin,end)).data

  # "初音ミク\0" -> "初音ミク"
  sliceTrim: (buffer,begin,end=begin+1)->
    subBuffer= buffer.slice begin,end

    nullIndex= Array::indexOf.call subBuffer,0
    subBuffer= subBuffer.slice 0,nullIndex if nullIndex > -1
    subBuffer

  readVector3LE: (buffer,offset)->
    x= buffer.readFloatLE offset+ 0
    y= buffer.readFloatLE offset+ 4
    z= buffer.readFloatLE offset+ 8

    [x,y,z]

  readVector4LE: (buffer,offset)->
    x= buffer.readFloatLE offset+ 0
    y= buffer.readFloatLE offset+ 4
    z= buffer.readFloatLE offset+ 8
    w= buffer.readFloatLE offset+12

    [x,y,z,w]

  # http://atupdate.web.fc2.com/vmd_format.htm
  getBezier: (bezier)->
    x= {}
    y= {}
    z= {}
    r= {}
    [
      x.x1,y.x1,z.x1,r.x1,x.y1,y.y1,z.y1,r.y1,x.x2,y.x2,z.x2,r.x2,x.y2,y.y2,z.y2,r.y2
      y.x1,z.x1,r.x1,x.y1,y.y1,z.y1,r.y1,x.x2,y.x2,z.x2,r.x2,x.y2,y.y2,z.y2,r.y2,NOOP
      z.x1,r.x1,x.y1,y.y1,z.y1,r.y1,x.x2,y.x2,z.x2,r.x2,x.y2,y.y2,z.y2,r.y2,NOOP,NOOP
      r.x1,x.y1,y.y1,z.y1,r.y1,x.x2,y.x2,z.x2,r.x2,x.y2,y.y2,z.y2,r.y2,NOOP,NOOP,NOOP
    ]= bezier

    {x,y,z,r}

  # 実験的 http://harigane.at.webry.info/201103/article_1.html
  getBezierCamera: (bezier)->
    x= {}
    y= {}
    z= {}
    r= {}
    l= {}
    v= {}
    [
      x.x1,x.x2,x.y1,x.y2
      y.x1,y.x2,y.y1,y.y2
      z.x1,z.x2,z.y1,z.y2
      r.x1,r.x2,r.y1,r.y2
      l.x1,l.x2,l.y1,l.y2
      v.x1,v.x2,v.y1,v.y2
    ]= bezier

    {x,y,z,r,l,v}

module.exports= new Utility
module.exports.Utility= Utility
