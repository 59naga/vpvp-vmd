# Dependencies
vpvpVmd= require '../src'

fs= require 'fs'

# Environment
unhandledChar= '�'# iconv.defaultCharUnicode
buffer= fs.readFileSync './test/fixtures/motion.vmd'

describe 'API',->
  describe '.parse',->
    it 'TypeError',->
      throws= [
        -> vpvpVmd.parse new Buffer 'vmdファイルじゃないバイナリ'
        -> vpvpVmd.parse 'バッファですらないナリ'
      ]

      expect(throws[0]).toThrowError TypeError,'buffer is not a Vocaloid Motion Data 0002'
      expect(throws[1]).toThrowError TypeError,'argument is not a Buffer'
      
    it 'ok',->
      data= vpvpVmd.parse buffer
      expect(Object.keys data).toEqual ['header','bone','morph','ik','camera','light','shadow']
