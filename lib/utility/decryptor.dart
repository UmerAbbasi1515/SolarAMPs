import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pointycastle/asymmetric/api.dart';

class Decryptor{

  dynamic decryptAES(String keyAES, Encrypted encrypted){
    final key = Key.fromUtf8(keyAES);
    final iv = IV.fromLength(16);
    final encryptor = Encrypter(AES(key));
    return encryptor.decrypt(encrypted, iv: iv);
  }

  dynamic decryptRSA(String publicKeyPath, String privateKeyPath, Encrypted encrypted) async{
    final publicKey = await parseKeyFromFile<RSAPublicKey>(publicKeyPath);
    final privKey = await parseKeyFromFile<RSAPrivateKey>(privateKeyPath);
    final encryptor = Encrypter(RSA(publicKey: publicKey, privateKey: privKey));
    return encryptor.decrypt(encrypted);
  }

  Map<String, dynamic> decryptJWT(String jwtToken){
    return JwtDecoder.decode(jwtToken);
  }

}