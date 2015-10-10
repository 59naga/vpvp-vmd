# VpvpVmd [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

[![Sauce Test Status][sauce-image]][sauce]

> MikuMikuDance Vocaloid-Motion-Data(.vmd) Parser

## インストール

```bash
$ npm install vpvp-vmd --save
```

# API

## vmd.parse(buffer) -> `{header,bone,morph,ik,camera,light,shadow}`

MikuMikuDanceの「モーションデータ保存」で生成した`SHIFT_JIS`の`.vmd`ファイルを`UTF-8`に変換して、オブジェクトを返します。

```js
// Dependencies
var vmd= require('vpvp-vmd');
var fs= require('fs');

// Main
var vmdFile= fs.readFileSync('./pose.vmd');
var data= vmd.parse(vpdFile);
console.log(data);
// {
//   "header": {
//     "signature": "Vocaloid Motion Data 0002",
//     "name": "初音ミク"
//   },
//   "bone": [
//     {
//       "frame": 0,
//       "name": "センター",
//       "position": [
//         0.9396730065345764,
//         -1.350000023841858,
//         0.129938006401062
//       ],
//       "quaternion": [
//         0,
//         0,
//         0,
//         1
//       ],
//       "bezier": {
//         "x": {
//           "x1": 20,
//           "y1": 20,
//           "x2": 107,
//           "y2": 107
//         },
//         "y": {
//           "x1": 20,
//           "y1": 20,
//           "x2": 107,
//           "y2": 107
//         },
//         "z": {
//           "x1": 20,
//           "y1": 20,
//           "x2": 107,
//           "y2": 107
//         },
//         "r": {
//           "x1": 20,
//           "y1": 20,
//           "x2": 107,
//           "y2": 107
//         }
//       }
//     },
//     // more 163 bones...
//   ],
//   "morph": [
//     {
//       "frame": 0,
//       "name": "あ",
//       "weight": 1
//     },
//     {
//       "frame": 1,
//       "name": "あ",
//       "weight": 0
//     },
//     // more 28 morphs...
//   ],
//   "ik": [
//     {
//       "frame": 0,
//       "show": true,
//       "count": 7,
//       "iks": [
//         {
//           "name": "ﾈｸﾀｲＩＫ",
//           "enable": true
//         },
//         {
//           "name": "左髪ＩＫ",
//           "enable": true
//         },
//         {
//           "name": "右髪ＩＫ",
//           "enable": true
//         },
//         {
//           "name": "左足ＩＫ",
//           "enable": true
//         },
//         {
//           "name": "右足ＩＫ",
//           "enable": true
//         },
//         {
//           "name": "左つま先ＩＫ",
//           "enable": true
//         },
//         {
//           "name": "右つま先ＩＫ",
//           "enable": true
//         }
//       ]
//     },
//     // more 1 ik...
//   ],
//   "camera": [],
//   "light": [],
//   "shadow": []
// }
```

# 参考
* [2010-02-20 / MMDのモーションデータ(VMD)形式　めも - 通りすがりの記憶](http://blog.goo.ne.jp/torisu_tetosuki/e/bc9f1c4d597341b394bd02b64597499d)
* [MMDモーションデータをセカンドライフで利用するためのメモ - VMDファイルフォーマット](http://www55.atwiki.jp/kumiho_k/pages/15.html)

# Related projects
* __vpvp-vmd__
* [vpvp-vpd](https://github.com/59naga/vpvp-vpd/)

License
---
[MIT][License]

[License]: http://59naga.mit-license.org/

[sauce-image]: http://soysauce.berabou.me/u/59798/vpvp-vmd.svg
[sauce]: https://saucelabs.com/u/59798
[npm-image]:https://img.shields.io/npm/v/vpvp-vmd.svg?style=flat-square
[npm]: https://npmjs.org/package/vpvp-vmd
[travis-image]: http://img.shields.io/travis/59naga/vpvp-vmd.svg?style=flat-square
[travis]: https://travis-ci.org/59naga/vpvp-vmd
[coveralls-image]: http://img.shields.io/coveralls/59naga/vpvp-vmd.svg?style=flat-square
[coveralls]: https://coveralls.io/r/59naga/vpvp-vmd?branch=master
