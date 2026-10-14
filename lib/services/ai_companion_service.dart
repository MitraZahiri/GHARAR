import '../models/ai_message_model.dart';

class AICompanionService {
  AICompanionService._();

  static List<AIMessageModel> getInitialMessages() => [
        AIMessageModel(
          id: 'welcome_noor',
          sender: MessageSender.noor,
          contentEn:
              'Hello, lovely souls. I am Noor, your gentle relationship companion. I am here to help you articulate tender feelings respectfully, spark cozy date ideas, and cultivate emotional safety. How can I nurture your bond today?',
          contentTr:
              'Merhaba güzel kalpler. Ben Noor, şefkatli ilişki yoldaşınız. Duygularınızı incitmeden ifade etmenize, tatlı randevu fikirleri bulmanıza ve aranızdaki güveni derinleştirmenize yardımcı olmak için buradayım. Bugün sevginize nasıl bir ışık tutabilirim?',
          timestamp: DateTime.now(),
        ),
      ];

  static Future<AIMessageModel> generateResponse({
    required String userPrompt,
    required bool isTurkish,
  }) async {
    // Simulate brief thoughtful reflection
    await Future.delayed(const Duration(milliseconds: 600));

    final lower = userPrompt.toLowerCase();

    if (lower.contains('feeling') ||
        lower.contains('express') ||
        lower.contains('his') ||
        lower.contains('duygu') ||
        lower.contains('ifade')) {
      return AIMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: MessageSender.noor,
        contentEn:
            'When expressing tender emotions, lead with vulnerability rather than critique. Try this gentle framing:\n\n'
            '“When our evenings feel rushed, I sometimes feel a quiet distance and I miss our closeness. I treasure our connection so deeply, could we create a 20-minute cozy pocket tonight just to talk without distractions?”\n\n'
            'Notice how this centers your love and longing rather than fault.',
        contentTr:
            'Duygularınızı paylaşırken eleştiri yerine kendi özleminizle başlamak kalpleri hemen birbirine yaklaştırır. Şöyle bir ifade deneyebilirsiniz:\n\n'
            '“Akşamlarımız telaşlı geçtiğinde bazen aramızda ufak bir mesafe hissediyorum ve o derin sohbetlerimizi çok özlüyorum. Aramızdaki bağı o kadar çok seviyorum ki, bu akşam baş başa sakin bir 20 dakika geçirebilir miyiz?”\n\n'
            'Bu yaklaşım bir suçlama değil, sevgi dolu bir davettir.',
        timestamp: DateTime.now(),
      );
    }

    if (lower.contains('surprise') ||
        lower.contains('date') ||
        lower.contains('randevu') ||
        lower.contains('sürpriz') ||
        lower.contains('fikir')) {
      return AIMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: MessageSender.noor,
        contentEn:
            'Here is an intimate, zero-stress idea: **The Golden Hour Tea Ceremony**.\n\n'
            'Prepare a small tray with warm herbal tea, two sliced figs or chocolates, and light a candle. When your partner finishes their day, hand it to them with a warm hug and say: “No talking about work or to-do lists for the next 15 minutes—just you and me enjoying this warmth.”',
        contentTr:
            'İşte sıfır stresli, kalbe dokunan bir öneri: **Altın Saat Çay Seremonisi**.\n\n'
            'Küçük bir tepsiye sıcak bitki çayı veya kahve hazırlayın, yanına iki parça çikolata koyun ve bir mum yakın. Partneriniz gününü bitirdiğinde sımsıkı sarılarak şunu söyleyin: “Önümüzdeki 15 dakika boyunca iş veya sorumluluklardan bahsetmek yok—sadece sen, ben ve bu huzur.”',
        timestamp: DateTime.now(),
      );
    }

    if (lower.contains('disagree') ||
        lower.contains('fight') ||
        lower.contains('tartışma') ||
        lower.contains('kırgın')) {
      return AIMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: MessageSender.noor,
        contentEn:
            'Differences of perspective are natural in every healthy relationship—they do not mean you are incompatible. Remember the 3-second pause:\n\n'
            '1. Take one shared slow breath before responding.\n'
            '2. Say: “I hear that this matters to you, and I want to understand your perspective completely.”\n'
            '3. Ask: “What is the most important thing you need me to understand right now?”',
        contentTr:
            'Fikir ayrılıkları her canlı ilişkide son derece doğaldır; uyumsuz olduğunuz anlamına asla gelmez. Şu 3 adımlı sihirli duraklamayı deneyin:\n\n'
            '1. Cevap vermeden önce derin ve yavaş bir nefes alın.\n'
            '2. “Bunun senin için ne kadar önemli olduğunu görüyorum ve tam olarak ne hissettiğini anlamak istiyorum” deyin.\n'
            '3. “Şu anda seni en çok üzen veya duymamı istediğin temel nokta nedir?” diye şefkatle sorun.',
        timestamp: DateTime.now(),
      );
    }

    // Default warm reflection
    return AIMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: MessageSender.noor,
      contentEn:
          'Love is built not just in grand romantic milestones, but in the hundreds of quiet, gentle choices you make to turn toward each other every single day. What is one small appreciation you can whisper to your partner before tonight ends?',
      contentTr:
          'Büyük aşklar sadece görkemli anlarda değil, her gün birbirinize doğru attığınız o sessiz ve şefkatli küçük adımlarla inşa edilir. Gece bitmeden partnerinize kulağına fısıldayabileceğiniz tatlı bir teşekkürünüz var mı?',
      timestamp: DateTime.now(),
    );
  }
}
