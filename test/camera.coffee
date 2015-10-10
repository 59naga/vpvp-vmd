# Dependencies
reader= require '../src/reader'

fs= require 'fs'

# Environment
unhandledChar= '�'# iconv.defaultCharUnicode
buffer= fs.readFileSync './test/fixtures/camera.vmd'

describe 'Use camera.vmd',->
  it '.readMeta',->
    meta= reader.readMeta buffer

    expect(meta.header.begin).toBe             0
    expect(meta.header.byte).toBe             50
    expect(meta.header.signature).toBe        30
    expect(meta.header.name).toBe             20
    expect(meta.header.total).toBe            50
  
    expect(meta.bone.begin).toBe              54
    expect(meta.bone.byte).toBe              111
    expect(meta.bone.count).toBe               0
    expect(meta.bone.total).toBe       111 *   0

    expect(meta.morph.begin).toBe             58
    expect(meta.morph.byte).toBe              23
    expect(meta.morph.count).toBe              0
    expect(meta.morph.total).toBe       23 *   0

    expect(meta.camera.begin).toBe            62
    expect(meta.camera.byte).toBe             61
    expect(meta.camera.count).toBe             2
    expect(meta.camera.total).toBe      61 *   2

    expect(meta.light.begin).toBe            188
    expect(meta.light.byte).toBe              28
    expect(meta.light.count).toBe              2
    expect(meta.light.total).toBe       28 *   2

    expect(meta.shadow.begin).toBe           248
    expect(meta.shadow.byte).toBe              9
    expect(meta.shadow.count).toBe             2
    expect(meta.shadow.total).toBe       9 *   2

    expect(meta.ik.begin).toBe               270
    expect(meta.ik.byte).toBe                  9
    expect(meta.ik.count).toBe                 0
    expect(meta.ik.total).toBe           9 *   0

  it '.readHeader',->
    header= reader.readHeader buffer

    expect(header.signature).toBe 'Vocaloid Motion Data 0002'
    expect(header.name).toBe 'カメラ・照明'

  it '.readCamera',->
    frames= reader.readCamera buffer

    expect(frames.length).toBe 2
    for frame in frames
      expect(frame.frame).toBeGreaterThan -1

      expect(frame.length).toEqual jasmine.any Number

      expect(frame.location.length).toBe 3
      for vector in frame.location
        expect(vector).toEqual jasmine.any Number
        expect(vector).not.toBeNaN()

      expect(frame.rotation.length).toBe 3
      for vector in frame.rotation
        expect(vector).toEqual jasmine.any Number
        expect(vector).not.toBeNaN()

      expect(Object.keys frame.bezier).toEqual ['x','y','z','r','l','v']
      for key of frame.bezier
        expect(frame.bezier[key].x1).toBe 20
        expect(frame.bezier[key].x2).toBe 107
        expect(frame.bezier[key].y1).toBe 20
        expect(frame.bezier[key].y2).toBe 107

      expect(frame.viewAngle).toBe 30
      expect(frame.parspective).toBe true

  it '.readLight',->
    frames= reader.readLight buffer

    expect(frames.length).toBe 2
    for frame in frames
      expect(frame.frame).toBeGreaterThan -1

      expect(frame.rgb.length).toBe 3
      for vector in frame.rgb
        expect(vector).toEqual jasmine.any Number
        expect(vector).not.toBeNaN()

      expect(frame.location.length).toBe 3
      for vector in frame.location
        expect(vector).toEqual jasmine.any Number
        expect(vector).not.toBeNaN()

  it '.readShadow',->
    frames= reader.readShadow buffer

    expect(frames.length).toBe 2
    for frame in frames
      expect(frame.frame).toBeGreaterThan -1

      expect(frame.mode).toBe 1

      expect(frame.distance).toEqual jasmine.any Number
