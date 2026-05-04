import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

void makeWav(String filename, double freq, double duration, [double volume = 0.5]) {
  final file = File(filename);
  file.parent.createSync(recursive: true);

  final sampleRate = 44100;
  final numSamples = (duration * sampleRate).toInt();
  final dataSize = numSamples * 2; // 16-bit
  final fileSize = 36 + dataSize;

  final builder = BytesBuilder();
  // RIFF header
  builder.add('RIFF'.codeUnits);
  builder.add(_int32(fileSize));
  builder.add('WAVE'.codeUnits);

  // fmt chunk
  builder.add('fmt '.codeUnits);
  builder.add(_int32(16)); // chunk size
  builder.add(_int16(1));  // PCM
  builder.add(_int16(1));  // Mono
  builder.add(_int32(sampleRate));
  builder.add(_int32(sampleRate * 2)); // byte rate
  builder.add(_int16(2)); // block align
  builder.add(_int16(16)); // bits per sample

  // data chunk
  builder.add('data'.codeUnits);
  builder.add(_int32(dataSize));

  for (var i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    final val = (volume * 32767.0 * math.sin(2.0 * math.pi * freq * t)).toInt();
    builder.add(_int16(val));
  }

  file.writeAsBytesSync(builder.toBytes());
  // ignore: avoid_print
  print('Created \$filename');
}

List<int> _int16(int value) {
  return [value & 0xff, (value >> 8) & 0xff];
}

List<int> _int32(int value) {
  return [
    value & 0xff,
    (value >> 8) & 0xff,
    (value >> 16) & 0xff,
    (value >> 24) & 0xff,
  ];
}

void main() {
  makeWav('assets/sounds/correct.wav', 880.0, 0.2);
  makeWav('assets/sounds/wrong.wav', 220.0, 0.4);
  makeWav('assets/sounds/click.wav', 1000.0, 0.05, 0.2);
  makeWav('assets/sounds/bgm.wav', 0.0, 1.0); // silent bgm for now
}
