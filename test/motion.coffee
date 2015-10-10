# Dependencies
reader= require '../src/reader'

fs= require 'fs'

# Environment
unhandledChar= '�'# iconv.defaultCharUnicode
buffer= fs.readFileSync './test/fixtures/motion.vmd'

describe 'Use motion.vmd',->
  it '.readMeta',->
    meta= reader.readMeta buffer

    expect(meta.header.begin).toBe             0
    expect(meta.header.byte).toBe             50
    expect(meta.header.signature).toBe        30
    expect(meta.header.name).toBe             20
    expect(meta.header.total).toBe            50
  
    expect(meta.bone.begin).toBe              54
    expect(meta.bone.byte).toBe              111
    expect(meta.bone.count).toBe             164
    expect(meta.bone.total).toBe       111 * 164
  
    expect(meta.morph.begin).toBe          18262
    expect(meta.morph.byte).toBe              23
    expect(meta.morph.count).toBe             30
    expect(meta.morph.total).toBe       23 *  30
  
    expect(meta.camera.begin).toBe         18956
    expect(meta.camera.byte).toBe             61
    expect(meta.camera.count).toBe             0
    expect(meta.camera.total).toBe      61 *   0
  
    expect(meta.light.begin).toBe          18960
    expect(meta.light.byte).toBe              28
    expect(meta.light.count).toBe              0
    expect(meta.light.total).toBe       28 *   0
  
    expect(meta.shadow.begin).toBe         18964
    expect(meta.shadow.byte).toBe              9
    expect(meta.shadow.count).toBe             0
    expect(meta.shadow.total).toBe       9 *   0
  
    expect(meta.ik.begin).toBe             18968
    expect(meta.ik.byte).toBe                156
    expect(meta.ik.count).toBe                 2
    expect(meta.ik.total).toBe         156 *   2

  it '.readHeader',->
    header= reader.readHeader buffer

    expect(header.signature).toBe 'Vocaloid Motion Data 0002'
    expect(header.name).toBe '初音ミク'

  it '.readBone',->
    data= reader.readBone buffer

    expect(data.length).toBe 164
    for bone in data
      expect(bone.frame).toBeGreaterThan -1

      expect(bone.name).not.toMatch unhandledChar

      expect(bone.position.length).toBe 3
      for vector in bone.position
        expect(vector).toEqual jasmine.any Number
        expect(vector).not.toBeNaN()

      expect(bone.quaternion.length).toBe 4
      for vector in bone.quaternion
        expect(vector).toEqual jasmine.any Number
        expect(vector).not.toBeNaN()

      expect(Object.keys bone.bezier).toEqual ['x','y','z','r']
      for key of bone.bezier
        expect(bone.bezier[key].x1).toEqual jasmine.any Number
        expect(bone.bezier[key].x2).toEqual jasmine.any Number
        expect(bone.bezier[key].y1).toEqual jasmine.any Number
        expect(bone.bezier[key].y2).toEqual jasmine.any Number

  it '.readMorph',->
    data= reader.readMorph buffer

    expect(data.length).toBe 30
    for bone in data
      expect(bone.frame).toBeGreaterThan -1

      expect(bone.name).not.toMatch unhandledChar

      expect(bone.weight).toEqual jasmine.any Number
      expect(bone.weight).not.toBeNaN()

  it '.readIK',->
    data= reader.readIK buffer

    expect(data.length).toBe 2
    for frame in data
      expect(frame.frame).toBeGreaterThan -1

      expect(frame.show).toBe true

      expect(frame.count).toBe 7

      expect(frame.iks.length).toBe frame.count

      for ik in frame.iks
        expect(ik.name).not.toMatch unhandledChar
        expect(ik.enable).toBe true
