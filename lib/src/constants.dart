const String apiBaseUrl = 'https://api.appcockpit.dev';
const String clientVersion = '1.1.0';

class LocalizedStrings {
  final String updateRequired;
  final String updateAvailable;
  final String updateNow;
  final String later;
  final String forceUpdateDescription;
  final String updateDescription;

  const LocalizedStrings({
    required this.updateRequired,
    required this.updateAvailable,
    required this.updateNow,
    required this.later,
    required this.forceUpdateDescription,
    required this.updateDescription,
  });
}

const Map<String, LocalizedStrings> localizedStrings = {
  'en': LocalizedStrings(
    updateRequired: 'Update Required',
    updateAvailable: 'Update Available',
    updateNow: 'Update Now',
    later: 'Later',
    forceUpdateDescription:
        'A critical update is required. Please update to continue using the app.',
    updateDescription:
        'An update is available. Please update to get the latest features and improvements.',
  ),
  'es': LocalizedStrings(
    updateRequired: 'Actualización Requerida',
    updateAvailable: 'Actualización Disponible',
    updateNow: 'Actualizar Ahora',
    later: 'Más Tarde',
    forceUpdateDescription:
        'Se requiere una actualización crítica. Actualice para continuar usando la aplicación.',
    updateDescription:
        'Hay una actualización disponible. Actualice ahora para obtener las últimas funciones y mejoras.',
  ),
  'fr': LocalizedStrings(
    updateRequired: 'Mise à Jour Requise',
    updateAvailable: 'Mise à Jour Disponible',
    updateNow: 'Mettre à Jour',
    later: 'Plus Tard',
    forceUpdateDescription:
        'Une mise à jour critique est requise. Veuillez mettre à jour pour continuer à utiliser l\'application.',
    updateDescription:
        'Une mise à jour est disponible. Mettez à jour maintenant pour obtenir les dernières fonctionnalités et améliorations.',
  ),
  'de': LocalizedStrings(
    updateRequired: 'Update Erforderlich',
    updateAvailable: 'Update Verfügbar',
    updateNow: 'Jetzt Aktualisieren',
    later: 'Später',
    forceUpdateDescription:
        'Ein kritisches Update ist erforderlich. Bitte aktualisieren Sie, um die App weiterhin nutzen zu können.',
    updateDescription:
        'Ein Update ist verfügbar. Aktualisieren Sie jetzt, um die neuesten Funktionen und Verbesserungen zu erhalten.',
  ),
  'it': LocalizedStrings(
    updateRequired: 'Aggiornamento Richiesto',
    updateAvailable: 'Aggiornamento Disponibile',
    updateNow: 'Aggiorna Ora',
    later: 'Più Tardi',
    forceUpdateDescription:
        'È richiesto un aggiornamento critico. Aggiorna per continuare a utilizzare l\'app.',
    updateDescription:
        'È disponibile un aggiornamento. Aggiorna ora per ottenere le ultime funzionalità e miglioramenti.',
  ),
  'pt': LocalizedStrings(
    updateRequired: 'Atualização Necessária',
    updateAvailable: 'Atualização Disponível',
    updateNow: 'Atualizar Agora',
    later: 'Mais Tarde',
    forceUpdateDescription:
        'Uma atualização crítica é necessária. Atualize para continuar usando o aplicativo.',
    updateDescription:
        'Uma atualização está disponível. Atualize agora para obter os recursos e melhorias mais recentes.',
  ),
  'ru': LocalizedStrings(
    updateRequired: 'Требуется Обновление',
    updateAvailable: 'Доступно Обновление',
    updateNow: 'Обновить Сейчас',
    later: 'Позже',
    forceUpdateDescription:
        'Требуется критическое обновление. Пожалуйста, обновите приложение, чтобы продолжить его использование.',
    updateDescription:
        'Доступно обновление. Обновите сейчас, чтобы получить последние функции и улучшения.',
  ),
  'ja': LocalizedStrings(
    updateRequired: '更新が必要です',
    updateAvailable: '更新が利用可能です',
    updateNow: '今すぐ更新',
    later: '後で',
    forceUpdateDescription: '重要な更新が必要です。アプリを引き続き使用するには更新してください。',
    updateDescription:
        'アップデートが利用可能です。最新の機能と改善を取得するには今すぐ更新してください。',
  ),
  'ko': LocalizedStrings(
    updateRequired: '업데이트 필요',
    updateAvailable: '업데이트 가능',
    updateNow: '지금 업데이트',
    later: '나중에',
    forceUpdateDescription: '중요한 업데이트가 필요합니다. 앱을 계속 사용하려면 업데이트하세요.',
    updateDescription:
        '업데이트를 사용할 수 있습니다. 최신 기능과 개선 사항을 받으려면 지금 업데이트하세요.',
  ),
  'zh': LocalizedStrings(
    updateRequired: '需要更新',
    updateAvailable: '可用更新',
    updateNow: '立即更新',
    later: '稍后',
    forceUpdateDescription: '需要进行关键更新。请更新以继续使用该应用程序。',
    updateDescription: '有可用更新。立即更新以获取最新功能和改进。',
  ),
  'ar': LocalizedStrings(
    updateRequired: 'التحديث مطلوب',
    updateAvailable: 'التحديث متاح',
    updateNow: 'التحديث الآن',
    later: 'لاحقاً',
    forceUpdateDescription:
        'مطلوب تحديث حرج. يرجى التحديث لمواصلة استخدام التطبيق.',
    updateDescription:
        'يتوفر تحديث. قم بالتحديث الآن للحصول على أحدث الميزات والتحسينات.',
  ),
  'hi': LocalizedStrings(
    updateRequired: 'अपडेट आवश्यक है',
    updateAvailable: 'अपडेट उपलब्ध है',
    updateNow: 'अभी अपडेट करें',
    later: 'बाद में',
    forceUpdateDescription:
        'एक महत्वपूर्ण अपडेट आवश्यक है। ऐप का उपयोग जारी रखने के लिए कृपया अपडेट करें।',
    updateDescription:
        'एक अपडेट उपलब्ध है। नवीनतम सुविधाएँ और सुधार प्राप्त करने के लिए अभी अपडेट करें।',
  ),
  'nl': LocalizedStrings(
    updateRequired: 'Update Vereist',
    updateAvailable: 'Update Beschikbaar',
    updateNow: 'Nu Updaten',
    later: 'Later',
    forceUpdateDescription:
        'Een kritieke update is vereist. Update om de app te blijven gebruiken.',
    updateDescription:
        'Er is een update beschikbaar. Update nu om de nieuwste functies en verbeteringen te krijgen.',
  ),
  'sv': LocalizedStrings(
    updateRequired: 'Uppdatering Krävs',
    updateAvailable: 'Uppdatering Tillgänglig',
    updateNow: 'Uppdatera Nu',
    later: 'Senare',
    forceUpdateDescription:
        'En kritisk uppdatering krävs. Vänligen uppdatera för att fortsätta använda appen.',
    updateDescription:
        'En uppdatering finns tillgänglig. Uppdatera nu för att få de senaste funktionerna och förbättringarna.',
  ),
  'da': LocalizedStrings(
    updateRequired: 'Opdatering Påkrævet',
    updateAvailable: 'Opdatering Tilgængelig',
    updateNow: 'Opdater Nu',
    later: 'Senere',
    forceUpdateDescription:
        'En kritisk opdatering er påkrævet. Opdater venligst for at fortsætte med at bruge appen.',
    updateDescription:
        'En opdatering er tilgængelig. Opdater nu for at få de nyeste funktioner og forbedringer.',
  ),
  'no': LocalizedStrings(
    updateRequired: 'Oppdatering Påkrevd',
    updateAvailable: 'Oppdatering Tilgjengelig',
    updateNow: 'Oppdater Nå',
    later: 'Senere',
    forceUpdateDescription:
        'En kritisk oppdatering er påkrevd. Vennligst oppdater for å fortsette å bruke appen.',
    updateDescription:
        'En oppdatering er tilgjengelig. Oppdater nå for å få de nyeste funksjonene og forbedringene.',
  ),
  'fi': LocalizedStrings(
    updateRequired: 'Päivitys Vaaditaan',
    updateAvailable: 'Päivitys Saatavilla',
    updateNow: 'Päivitä Nyt',
    later: 'Myöhemmin',
    forceUpdateDescription:
        'Kriittinen päivitys vaaditaan. Päivitä jatkaaksesi sovelluksen käyttöä.',
    updateDescription:
        'Päivitys on saatavilla. Päivitä nyt saadaksesi uusimmat ominaisuudet ja parannukset.',
  ),
  'pl': LocalizedStrings(
    updateRequired: 'Wymagana Aktualizacja',
    updateAvailable: 'Dostępna Aktualizacja',
    updateNow: 'Aktualizuj Teraz',
    later: 'Później',
    forceUpdateDescription:
        'Wymagana jest krytyczna aktualizacja. Zaktualizuj, aby kontynuować korzystanie z aplikacji.',
    updateDescription:
        'Dostępna jest aktualizacja. Zaktualizuj teraz, aby uzyskać najnowsze funkcje i ulepszenia.',
  ),
  'tr': LocalizedStrings(
    updateRequired: 'Güncelleme Gerekli',
    updateAvailable: 'Güncelleme Mevcut',
    updateNow: 'Şimdi Güncelle',
    later: 'Daha Sonra',
    forceUpdateDescription:
        'Kritik bir güncelleme gerekli. Uygulamayı kullanmaya devam etmek için lütfen güncelleyin.',
    updateDescription:
        'Bir güncelleme mevcut. En son özellikleri ve iyileştirmeleri almak için şimdi güncelleyin.',
  ),
  'he': LocalizedStrings(
    updateRequired: 'נדרש עדכון',
    updateAvailable: 'עדכון זמין',
    updateNow: 'עדכן עכשיו',
    later: 'מאוחר יותר',
    forceUpdateDescription:
        'נדרש עדכון קריטי. אנא עדכן כדי להמשיך להשתמש באפליקציה.',
    updateDescription:
        'עדכון זמין. עדכן כעת כדי לקבל את התכונות והשיפורים האחרונים.',
  ),
};
