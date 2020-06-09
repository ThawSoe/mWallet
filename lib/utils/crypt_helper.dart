import 'dart:convert';
import 'dart:typed_data';
import "package:pointycastle/export.dart";
import "package:hex/hex.dart";
import 'dart:math';

const KEY_SIZE = 16; // 16 Bytes for 128 bits
const ITERATION_COUNT = 1000;
const KEY = r"!@#$29!@#$Gp**&*"; // 128 bit key

class AesUtil {

  static final Random _random = Random.secure();

  static String random(int length) {
    final random = Random.secure();

    const int seedLength = 16;
    const int randomMax = 128;
    final Uint8List uint8list = Uint8List(seedLength);

    for (int i=0; i < seedLength; i++) {
      uint8list[i] = random.nextInt(randomMax);
    }

    return HEX.encode(uint8list);
  }

  static String encrypt(String salt, String iv, String plaintext){
    // Uint8List -  A fixed-length list of 8-bit unsigned integers.
    // Int8List -  A fixed-length list of 8-bit signed integers.
    if(plaintext == null || plaintext.isEmpty){
      return "";
    }
    Uint8List _uIntKey = generateKey(salt, KEY);
    print("key is "+_uIntKey.toString());

    Int8List _intKey = Int8List.fromList(_uIntKey);
    print("key1 is "+_intKey.toString());

    KeyParameter keyParam = new KeyParameter(_uIntKey);
    print("HEX.decode(iv) :"+HEX.decode(iv).toString());

    Uint8List ivBytes = HEX.decode(iv);

    final params = new ParametersWithIV(keyParam, ivBytes);
    print("params :"+params.toString());

    BlockCipher aes = new AESFastEngine();
    BlockCipher cipher;
    cipher = new CBCBlockCipher(aes);
    cipher.init(true, params);

    Uint8List textBytes = utf8.encode(plaintext);
    print("textBytes :"+textBytes.toString());

    //add padding for needed size of textBytes
    Uint8List paddedText = pad(textBytes, aes.blockSize);
    print("paddedText :"+paddedText.toString());

    Uint8List cipherBytes = _processBlocks(cipher, paddedText);
    print("cipherBytes :"+cipherBytes.toString());

    Int8List _intCipherBytes = Int8List.fromList(cipherBytes);
    print("_intCipherBytes is "+_intCipherBytes.toString());

    return base64.encode(cipherBytes);

  }

  static Uint8List _processBlocks(BlockCipher cipher, Uint8List inp) {
    var out = new Uint8List(inp.lengthInBytes);

    for (var offset = 0; offset < inp.lengthInBytes;) {
      var len = cipher.processBlock(inp, offset, out, offset);
      offset += len;
    }

    return out;
  }

  static Uint8List pad(Uint8List src, int blockSize) {
    var pad = new PKCS7Padding();
    pad.init(null);

    int padLength = blockSize - (src.length % blockSize);
    var out = new Uint8List(src.length + padLength)..setAll(0, src);
    pad.addPadding(out, src.length);

    return out;
  }

  static Uint8List generateKey(String salt, dynamic passphrase){
    if (passphrase == null || passphrase.isEmpty) {
      throw new ArgumentError('password must not be empty');
    }
    if (passphrase is String) {
      passphrase = createUint8ListFromString(passphrase);
      print("passphrase :"+passphrase.toString());
    }
    Uint8List saltBytes = HEX.decode(salt);
    Pbkdf2Parameters params =
    new Pbkdf2Parameters(saltBytes, ITERATION_COUNT, KEY_SIZE);
    KeyDerivator d = new KeyDerivator("SHA-1/HMAC/PBKDF2");
    d.init(params);

    return d.process(passphrase);
  }

  static Uint8List createUint8ListFromString(String s) {
    var ret = new Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }
      
}